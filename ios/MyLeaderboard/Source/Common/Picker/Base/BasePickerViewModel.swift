//
//  BasePickerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

protocol PickerItemQueryable {
	associatedtype Query: GraphApiQuery & ResponseAssociable
	associatedtype Item: GraphQLIdentifiable

	func query(completion: @escaping (Query.ResponseResult) -> Void)
	func pickerItems(from: Query.Response) -> [Item]
}

enum PickerAction<Item: GraphQLIdentifiable>: BaseAction {
	case itemsUpdated
	case limitExceeded(Int)
	case donePicking([Item])
	case graphQLError(GraphAPIError)
}

enum PickerViewAction<Item: GraphQLIdentifiable>: BaseViewAction {
	case initialize
	case refresh
	case finish
	case itemSelected(GraphID, Bool)
}

class BasePickerViewModel<Item, Queryable: PickerItemQueryable>: ViewModel where Queryable.Item == Item {
	typealias ActionHandler = (_ action: PickerAction<Item>) -> Void

	private let multiSelect: Bool
	private let limit: Int?
	private var queryable: Queryable
	var handleAction: ActionHandler

	private(set) var items: [Item] = [] {
		didSet {
			handleAction(.itemsUpdated)
		}
	}

	private(set) var selectedItems: Set<GraphID> {
		didSet {
			handleAction(.itemsUpdated)
		}
	}

	private var limitReached: Bool {
		if let limit = self.limit {
			return selectedItems.count >= limit
		}

		return false
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
		case .itemSelected(let itemID, let selected):
			selectItem(itemID, selected: selected)
		case .finish:
			submit()
		}
	}

	private func loadItems() {
		queryable.query { [weak self] result in
			switch result {
			case .success(let response):
				self?.items = self?.queryable.pickerItems(from: response) ?? []
			case .failure(let error):
				self?.handleAction(.graphQLError(error))
			}
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
