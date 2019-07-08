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

	override func viewDidLoad() {
		viewModel = GameListViewModel { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .gamesLoaded(let games):
				self.render(games: games)
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			}
		}
	}

	private func render(games: [Game]) {

	}

	private func showGameDetails(for game: Game) {
		print("Selected game \(game.name)")
	}
}
