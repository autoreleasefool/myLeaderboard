//
//  BasePickerViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

protocol PickerItemQueryable: AnyObject {
	associatedtype Item: Identifiable

	func query(api: LeaderboardAPI, completion: (LeaderboardAPIResult<[Item]>) -> Void)
}

enum PickerAction<Item: Identifiable>: BaseAction {
	case itemsUpdated
	case donePicking([Item])
	case apiError(LeaderboardAPIError)
}

enum PickerViewAction<Item: Identifiable>: BaseViewAction {
	case initialize
	case refresh
	case finish
	case itemSelected(ID, Bool)
}

class BasePickerViewModel<Item, Queryable: PickerItemQueryable>: ViewModel where Queryable.Item == Item {
	typealias ActionHandler = (_ action: PickerAction<Item>) -> Void

	private var api: LeaderboardAPI
	private weak var queryable: Queryable?
	var handleAction: ActionHandler

	private(set) var items: [Item] = [] {
		didSet {
			handleAction(.itemsUpdated)
		}
	}

	private(set) var selectedItems: Set<ID> {
		didSet {
			handleAction(.itemsUpdated)
		}
	}

	init(api: LeaderboardAPI, initiallySelected: Set<ID>, queryable: Queryable, handleAction: @escaping ActionHandler) {
		self.api = api
		self.selectedItems = initiallySelected
		self.queryable = queryable
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: PickerViewAction<Item>) {
		switch viewAction {
		case .initialize:
			loadItems()
		case .refresh:
			reloadItems()
		case .itemSelected(let id, let selected):
			if selected {
				selectedItems.insert(id)
			} else {
				selectedItems.remove(id)
			}
		case .finish:
			submit()
		}
	}

	private func loadItems() {
		queryable?.query(api: api) { [weak self] result in
			switch result {
			case .success(let items):
				self?.items = items
			case .failure(let error):
				self?.handleAction(.apiError(error))
			}
		}
	}

	private func reloadItems() {
		api.refresh { [weak self] result in
			switch result {
			case .success:
				self?.loadItems()
			case .failure(let error):
				self?.handleAction(.apiError(error))
			}
		}
	}

	private func submit() {
		let selected = items.filter { selectedItems.contains($0.id) }
		handleAction(.donePicking(selected))
	}
}
