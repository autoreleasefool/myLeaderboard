//
//  BasePickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import MyLeaderboardApi
import UIKit
import FunctionalTableData
import Loaf

class BasePickerViewController<Item, State: ViewState, Queryable: PickerItemQueryable>: FTDViewController where
	Queryable.Item == Item {
	typealias FinishedSelection = ([Item]) -> Void

	private var viewModel: BasePickerViewModel<Item, Queryable>!
	private var finishedSelection: FinishedSelection

	init(
		initiallySelected: Set<GraphID>,
		multiSelect: Bool,
		limit: Int?,
		queryable: Queryable,
		completion: @escaping FinishedSelection
	) {
		self.finishedSelection = completion
		super.init()
		refreshable = true
		paginated = true

		self.viewModel = BasePickerViewModel(
			initiallySelected: initiallySelected,
			multiSelect: multiSelect,
			limit: limit,
			queryable: queryable
		) { [weak self] action in
			switch action {
			case .dataChanged:
				self?.render()
			case .limitExceeded(let limit):
				self?.notifyLimitExceeded(limit)
			case .donePicking(let selectedItems):
				self?.finish(with: selectedItems)
			case .graphQLError(let error):
				self?.presentError(error)
			}
		}

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(submit)
		)
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
		if viewModel.items.count == 0 && viewModel.dataLoading {
			tableData.renderAndDiff([LoadingCell.section()])
			return
		}

		let renderedItems = renderItems(viewModel.items)
		var sections = BasePickerBuilder.sections(
			items: renderedItems,
			selectedItems:
			viewModel.selectedItems,
			actionable: self
		)

		if viewModel.loadingMore {
			sections.append(LoadingCell.section(style: .medium, backgroundColor: .primary))
		}

		tableData.renderAndDiff(sections)
	}

	open func renderItems(_ items: [Item]) -> [PickerItem<State>] {
		fatalError("Pickers must implement renderItems")
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	private func notifyLimitExceeded(_ limit: Int) {
		let limitMessage: String
		if limit == 1 {
			limitMessage = "\(limit) item"
		} else {
			limitMessage = "\(limit) items"
		}
		Loaf("You can only select up to \(limitMessage)", state: .error, sender: self).show()
	}

	@objc private func submit() {
		viewModel.postViewAction(.finish)
	}

	private func finish(with selectedItems: [Item]) {
		self.finishedSelection(selectedItems)
		dismiss(animated: true)
	}

	override func refresh() {
		viewModel.postViewAction(.refresh)
	}

	override func loadMore() {
		viewModel.postViewAction(.loadMore)
	}
}

extension BasePickerViewController: BasePickerActionable {
	func didSelectItem(_ item: GraphID, selected: Bool) {
		viewModel.postViewAction(.itemSelected(item, selected))
	}
}
