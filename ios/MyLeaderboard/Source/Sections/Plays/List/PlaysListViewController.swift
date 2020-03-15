//
//  PlaysListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData
import Loaf

class PlaysListViewController: FTDViewController {
	private var viewModel: PlaysListViewModel!

	init(filter: PlayListFilter) {
		super.init()
		refreshable = true

		viewModel = PlaysListViewModel(filter: filter) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .dataChanged:
				self.updateTitle()
				self.finishRefresh()
				self.render()
			case .titleChanged:
				self.updateTitle()
			case .graphQLError(let error):
				self.finishRefresh()
				self.presentError(error)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.postViewAction(.initialize)
		updateTitle()
		render()
	}

	private func updateTitle() {
		self.title = viewModel.title
	}

	private func render() {
		let sections: [TableSection]
		if viewModel.filter.playerIDs.count == 1, let player = viewModel.filter.playerIDs.first {
			sections = PlaysListBuilder.sections(
				forPlayer: player,
				plays: viewModel.plays,
				actionable: self
			)
		} else {
			sections = PlaysListBuilder.sections(plays: viewModel.plays, actionable: self)
		}

		tableData.renderAndDiff(sections)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension PlaysListViewController: PlaysListActionable {

}
