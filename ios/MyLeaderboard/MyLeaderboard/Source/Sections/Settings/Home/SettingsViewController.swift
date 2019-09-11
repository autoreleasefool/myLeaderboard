//
//  SettingsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class SettingsViewController: FTDViewController {
	private let api: LeaderboardAPI
	private var viewModel: SettingsViewModel!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Settings"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish))

		viewModel = SettingsViewModel { [weak self] action in
			switch action {
			case .playerUpdated:
				self?.render()
			case .openURL(let url):
				self?.openURL(url)
			case .openPlayerPicker:
				self?.openPlayerPicker()
			case .openLicenses:
				self?.openLicenses()
			case .openContributors:
				self?.openContributors()
			}
		}

		viewModel.postViewAction(.initialize)
		render()
	}

	@objc private func finish() {
		dismiss(animated: true)
	}

	private func render() {
		let sections = SettingsBuilder.sections(preferredPlayer: viewModel.preferredPlayer, actionable: self)
		tableData.renderAndDiff(sections)
	}

	private func openURL(_ url: URL) {
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		}
	}

	private func openLicenses() {
		presentModal(LicensesListViewController())
	}

	private func openContributors() {
		presentModal(ContributorsListViewController())
	}

	private func openPlayerPicker() {
		let initiallySelected: Set<ID>
		if let player = viewModel.preferredPlayer {
			initiallySelected = [player.id]
		} else {
			initiallySelected = []
		}

		let playerPicker = PlayerPickerViewController(api: api, multiSelect: false, initiallySelected: initiallySelected) { [weak self] selectedPlayers in
			self?.viewModel.postViewAction(.selectPreferredPlayer(selectedPlayers.first))
			self?.render()
		}
		presentModal(playerPicker)
	}
}

extension SettingsViewController: SettingsActionable {
	func changePreferredPlayer() {
		viewModel.postViewAction(.editPlayer)
	}

	func viewSource() {
		viewModel.postViewAction(.viewSource)
	}

	func viewLicenses() {
		viewModel.postViewAction(.viewLicenses)
	}

	func viewContributors() {
		viewModel.postViewAction(.viewContributors)
	}
}
