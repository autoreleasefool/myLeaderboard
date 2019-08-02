//
//  BasePickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData
import Loaf

class BasePickerViewController<Item, State: ViewState, Queryable: PickerItemQueryable>: FTDViewController where Queryable.Item == Item {
	typealias FinishedSelection = ([Item]) -> Void

	private let api: LeaderboardAPI
	private var viewModel: BasePickerViewModel<Item, Queryable>!
	private var finishedSelection: FinishedSelection

	init(api: LeaderboardAPI, initiallySelected: Set<ID>, queryable: Queryable, completion: @escaping FinishedSelection) {
		self.api = api
		self.finishedSelection = completion
		super.init()

		self.viewModel = BasePickerViewModel(api: api, initiallySelected: initiallySelected, queryable: queryable) { [weak self] action in
			switch action {
			case .itemsUpdated:
				self?.render()
			case .donePicking(let selectedItems):
				self?.finishedSelection(selectedItems)
			case .apiError(let error):
				self?.presentError(error)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func render() {
		let renderedItems = renderItems(viewModel.items)
		let sections = BasePickerBuilder.sections(items: renderedItems, selectedItems: viewModel.selectedItems, actionable: self)
		tableData.renderAndDiff(sections)
	}

	open func renderItems(_ items: [Item]) -> [PickerItem<State>] {
		fatalError("Pickers must implement renderItems")
	}

	private func presentError(_ error: LeaderboardAPIError) {
		let message: String
		if let errorDescription = error.errorDescription {
			message = errorDescription
		} else {
			message = "Unknown error."
		}

		Loaf(message, state: .error, sender: self).show()
	}
}

extension BasePickerViewController: BasePickerActionable {
	func didSelectItem(_ item: ID, selected: Bool) {
		viewModel.postViewAction(.itemSelected(item, selected))
	}
}
