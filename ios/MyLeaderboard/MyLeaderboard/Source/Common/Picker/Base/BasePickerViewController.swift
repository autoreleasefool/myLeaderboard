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

	init(api: LeaderboardAPI, initiallySelected: Set<ID>, multiSelect: Bool, queryable: Queryable, completion: @escaping FinishedSelection) {
		self.api = api
		self.finishedSelection = completion
		super.init()

		self.viewModel = BasePickerViewModel(api: api, initiallySelected: initiallySelected, multiSelect: multiSelect, queryable: queryable) { [weak self] action in
			switch action {
			case .itemsUpdated:
				self?.render()
			case .donePicking(let selectedItems):
				self?.finish(with: selectedItems)
			case .apiError(let error):
				self?.presentError(error)
			}
		}

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.postViewAction(.initialize)
		render()
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

	@objc private func submit() {
		viewModel.postViewAction(.finish)
	}

	private func finish(with selectedItems: [Item]) {
		self.finishedSelection(selectedItems)
		dismiss(animated: true)
	}
}

extension BasePickerViewController: BasePickerActionable {
	func didSelectItem(_ item: ID, selected: Bool) {
		viewModel.postViewAction(.itemSelected(item, selected))
	}
}
