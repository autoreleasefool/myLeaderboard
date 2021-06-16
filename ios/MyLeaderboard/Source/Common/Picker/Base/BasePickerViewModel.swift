//
//  BasePickerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

protocol PickerItemQueryable {
	associatedtype Query: GraphApiQuery & ResponseAssociable
	associatedtype Item: Identifiable

	func query(pageSize: Int, offset: Int) -> AnyPublisher<Query.Response, MyLeaderboardAPIError>
	func pickerItems(from: Query.Response) -> [Item]
}

enum PickerAction<Item: Identifiable>: BaseAction {
	case dataChanged
	case limitExceeded(Int)
	case donePicking([Item])
	case graphQLError(MyLeaderboardAPIError)
}

enum PickerViewAction<Item: Identifiable>: BaseViewAction {
	case initialize
	case refresh
	case loadMore
	case finish
	case itemSelected(GraphID, Bool)
}

class BasePickerViewModel<Item, Queryable: PickerItemQueryable>: ViewModel where Queryable.Item == Item {
	typealias ActionHandler = (_ action: PickerAction<Item>) -> Void
	private let pageSize = 25

	private let multiSelect: Bool
	private let limit: Int?
	private var queryable: Queryable
	var handleAction: ActionHandler

	private var queryCancellable: AnyCancellable?

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var items: [Item] = []
	private(set) var selectedItems: Set<GraphID> {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private var limitReached: Bool {
		if let limit = self.limit {
			return selectedItems.count >= limit
		}

		return false
	}

	private(set) var hasMore: Bool = false
	private(set) var loadingMore: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	init(
		initiallySelected: Set<GraphID>,
		multiSelect: Bool,
		limit: Int?,
		queryable: Queryable,
		handleAction: @escaping ActionHandler
	) {
		self.selectedItems = initiallySelected
		self.multiSelect = multiSelect
		self.limit = limit
		self.queryable = queryable
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PickerViewAction<Item>) {
		switch viewAction {
		case .initialize, .refresh:
			loadItems()
		case .loadMore:
			guard !dataLoading && !loadingMore && hasMore else { return }
			loadItems(offset: items.count)
		case .itemSelected(let itemID, let selected):
			selectItem(itemID, selected: selected)
		case .finish:
			submit()
		}
	}

	private func loadItems(offset: Int = 0) {
		dataLoading = true
		if offset > 0 {
			loadingMore = true
		}

		queryCancellable = queryable.query(pageSize: pageSize, offset: offset)
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result {
					self?.handleAction(.graphQLError(error))
				}

				self?.dataLoading = false
				if offset > 0 {
					self?.loadingMore = false
				}
			}, receiveValue: { [weak self] value in
				self?.handle(items: self?.queryable.pickerItems(from: value) ?? [], offset: offset)
			})
	}

	private func handle(items: [Item], offset: Int) {
		hasMore = items.count == pageSize
		if offset > 0 {
			self.items.append(contentsOf: items)
		} else {
			self.items = items
		}
	}

	private func selectItem(_ itemID: GraphID, selected: Bool) {
		var selectedItems = Set(self.selectedItems)
		if selected {
			if limitReached {
				handleAction(.limitExceeded(limit!))
				return
			}

			if !multiSelect {
				selectedItems.removeAll()
			}
			selectedItems.insert(itemID)
		} else {
			selectedItems.remove(itemID)
		}

		self.selectedItems = selectedItems
	}

	private func submit() {
		let selected = items.filter { selectedItems.contains($0.graphID) }
		handleAction(.donePicking(selected))
	}
}
