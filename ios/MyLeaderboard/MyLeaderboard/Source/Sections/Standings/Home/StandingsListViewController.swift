//
//  StandingsListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-17.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class StandingsListViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: StandingsListViewModel!
	private var spreadsheetBuilder: SpreadsheetBuilder!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
		refreshable = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = StandingsListViewModel(api: api) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .standingsUpdated:
				self.finishRefresh()
				self.render()
			case .playersUpdated:
				self.render()
			case .apiError(let error):
				self.presentError(error)
			case .openRecordPlay:
				self.showRecordPlay()
			case .openGameDetails(let game):
				self.showGameDetails(for: game)
			case .openPlayerDetails(let player):
				self.showPlayerDetails(for: player)
			case .openPlays(let game, let players):
				self.openPlays(game: game, players: players)
			}
		}

		self.title = "Standings"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(recordPlay))
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(openSettings))
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		let sections = StandingsListBuilder.sections(standings: viewModel.standings, players: viewModel.players, builder: spreadsheetBuilder, actionable: self)
		tableData.renderAndDiff(sections)
	}

	@objc private func recordPlay() {
		viewModel.postViewAction(.recordPlay)
	}

	private func showRecordPlay() {
		presentModal(RecordPlayViewController(api: api) { _ in
			Loaf("Play recorded!", state: .success, sender: self).show()
		})
	}

	private func showGameDetails(for game: Game) {
		show(GameDetailsViewController(api: api, game: game), sender: self)
	}

	private func showPlayerDetails(for player: Player) {
		show(PlayerDetailsViewController(api: api, player: player), sender: self)
	}

	private func openPlays(game: Game, players: [Player]) {
		show(PlaysListViewController(api: api, games: [game], players: players), sender: self)
	}

	@objc private func openSettings() {
		presentModal(SettingsViewController(api: api))
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

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension StandingsListViewController: StandingsListActionable {
	func selectedGame(game: Game) {
		viewModel.postViewAction(.selectGame(game))
	}

	func selectedPlayer(player: Player) {
		viewModel.postViewAction(.selectPlayer(player))
	}

	func showPlays(game: Game, players: [Player]) {
		viewModel.postViewAction(.showPlays(game, players))
	}
}
