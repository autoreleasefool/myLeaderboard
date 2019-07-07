//
//  GameListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

class GameListViewController: UIViewController {

	private var viewModel: GameListViewModel!

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		viewModel = GameListViewModel { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			}
		}
	}

	private func showGameDetails(for game: Game) {
		print("Selected game \(game.name)")
	}
}
