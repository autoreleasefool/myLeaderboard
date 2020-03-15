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
		viewModel = StandingsListViewModel { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .dataChanged:
				self.finishRefresh()
				self.render()
			case .graphQLError(let error):
				self.finishRefresh()
				self.presentError(error)
			case .openRecordPlay:
				self.showRecordPlay()
			case .openGameDetails(let gameID):
				self.showGameDetails(for: gameID)
			case .openPlayerDetails(let playerID):
				self.showPlayerDetails(for: playerID)
			case .openPlays(let filter):
				self.openPlays(filter: filter)
			case .showPreferredPlayerSelection:
				self.openPreferredPlayerSelection()
			}
		}

		self.title = "Standings"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(recordPlay)
		)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "Settings"),
			style: .plain,
			target: self,
			action: #selector(openSettings)
		)
		self.spreadsheetBuilder = SpreadsheetBuilder(tableData: tableData)

		viewModel.postViewAction(.initialize)
		render()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		spreadsheetBuilder.interfaceSize = traitCollection.horizontalSizeClass
		render()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.postViewAction(.willAppear)
	}

	private func render() {
		if viewModel.standings.count == 0 && viewModel.dataLoading {
			tableData.renderAndDiff([LoadingCell.section()])
			return
		}

		let sections = StandingsListBuilder.sections(
			games: viewModel.games,
			standings: viewModel.standings,
			builder: spreadsheetBuilder,
			actionable: self
		)
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

	private func showGameDetails(for gameID: GraphID) {
		let gameName = viewModel.games.first(where: { $0.id == gameID })?.name
		show(GameDetailsViewController(gameID: gameID, withGameName: gameName), sender: self)
	}

	private func showPlayerDetails(for playerID: GraphID) {
		show(PlayerDetailsViewController(playerID: playerID), sender: self)
	}

	private func openPlays(filter: PlayListFilter) {
		show(PlaysListViewController(filter: filter), sender: self)
	}

	private func openPreferredPlayerSelection() {
		let alert = UIAlertController(
			title: "Select a preferred player?",
			message: "You haven't selected a preferred player yet. " +
				"Choosing a preferred player makes it easier to record " +
				"games by automatically adding them (yourself) to games you record! Pick a preferred player now?",
			preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: "Pick", style: .default) { [weak self] _ in
			guard let self = self else { return }
			self.openPreferredPlayerModal()
		})
		alert.addAction(UIAlertAction(title: "Later", style: .cancel))

		present(alert, animated: true)
	}

	private func openPreferredPlayerModal() {
		var initiallySelected: Set<GraphID> = []
		if let player = Player.preferred {
			initiallySelected.insert(player.graphID)
		}

		presentModal(PlayerPickerViewController(
			multiSelect: false,
			initiallySelected: initiallySelected
		) { [weak self] selected in
			self?.viewModel.postViewAction(.selectPreferredPlayer(selected.first))
		})
	}

	private func openPreferredOpponentsModal() {
		let initiallySelected = Set(Player.preferredOpponents.map { $0.graphID })

		presentModal(PlayerPickerViewController(
			multiSelect: true,
			limit: Player.preferredOpponentsLimit,
			initiallySelected: initiallySelected
		) { [weak self] selected in
			self?.viewModel.postViewAction(.selectPreferredOpponents(selected))
		})
	}

	@objc private func openSettings() {
		presentModal(SettingsViewController())
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension StandingsListViewController: StandingsListActionable {
	func selectedGame(gameID: GraphID) {
		viewModel.postViewAction(.selectGame(gameID))
	}

	func selectedPlayer(playerID: GraphID) {
		viewModel.postViewAction(.selectPlayer(playerID))
	}

	func showPlays(gameID: GraphID, playerIDs: [GraphID]) {
		let filter = PlayListFilter(gameID: gameID, playerIDs: playerIDs)
		viewModel.postViewAction(.showPlays(filter))
	}
}

extension StandingsListViewController: RouteHandler {
	func openRoute(_ route: Route) {
		switch route {
		case .preferredOpponents:
			openPreferredOpponentsModal()
		case .preferredPlayer:
			openPreferredPlayerModal()
		default:
			break
		}
	}
}
