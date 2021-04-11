//
//  ChangeBoardViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-08.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import FunctionalTableData
import Loaf
import myLeaderboardApi
import UIKit

class ChangeBoardViewController: FTDViewController {
	private var viewModel: ChangeBoardViewModel!
	private var onChange: (BoardDetailsFragment?) -> Void

	init(onChange: @escaping (BoardDetailsFragment?) -> Void) {
		self.onChange = onChange
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = ChangeBoardViewModel { [weak self] action in
			switch action {
			case .openBoard(let board):
				self?.openBoard(board: board)
			case .updatedData:
				self?.render()
			case .graphQLError(let error):
				self?.presentError(error)
			case .error(let errorMessage):
				self?.presentErrorMessage(errorMessage)
			}
		}

		self.title = "Boards"

		if Board.lastUsedBoard != nil {
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(
				barButtonSystemItem: .cancel,
				target: self,
				action: #selector(cancel)
			)
		}

		DispatchQueue.main.async {
			self.render()
		}
	}

	private func render() {
		let sections = ChangeBoardBuilder.sections(
			boardName: viewModel.boardName,
			boardState: viewModel.boardState,
			actionable: self
		)

		self.tableData.renderAndDiff(sections)
	}

	@objc private func cancel() {
		onChange(nil)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	private func presentErrorMessage(_ errorMessage: String) {
		Loaf(errorMessage, state: .error, sender: self).show()
	}

	private func openBoard(board: BoardDetailsFragment) {
		Board.lastUsedBoard = board
		onChange(board)
		dismiss(animated: true)
	}
}

extension ChangeBoardViewController: ChangeBoardActionable {
	func updatedBoardName(to name: String) {
		viewModel.postViewAction(.updateBoardName(name))
	}

	func createBoard(withName name: String) {
		viewModel.postViewAction(.createBoard(name))
	}

	func findBoard(withName name: String) {
		DispatchQueue.main.async {
			self.view.endEditing(true)
			self.viewModel.postViewAction(.findBoard(name))
		}
	}

	func joinBoard(withName name: String) {
		viewModel.postViewAction(.joinBoard(name))
	}

	func openPublicBoard() {
		viewModel.postViewAction(.selectPublicBoard)
	}
}
