//
//  ContributorsListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-23.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class ContributorsListViewController: FTDViewController {
	private static let contributors: [Player] = [
		Player(id: 0, avatar: "https://github.com/josephroquedev.png", displayName: "Joseph Roque", username: "josephroquedev"),
		Player(id: 1, avatar: "https://github.com/mori-ahk.png", displayName: "Mori Ahmadi", username: "mori-ahk"),
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Contributors"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish))

		let rows: [CellConfigType] = ContributorsListViewController.contributors.map { contributor in
			return PlayerListItemCell(
				key: "Contributor-\(contributor.id)",
				style: CellStyle(highlight: true, accessoryType: .disclosureIndicator),
				actions: CellActions(selectionAction: { [weak self] _ in
					self?.openURL(URL(string: "https://github.com/\(contributor.username)"))
					return .deselected
				}),
				state: PlayerListItemState(displayName: contributor.displayName, username: contributor.username, avatar: contributor.qualifiedAvatar),
				cellUpdater: PlayerListItemState.updateView
			)
		}

		let section = TableSection(key: "Contributors", rows: rows)
		tableData.renderAndDiff([section])
	}

	private func openURL(_ url: URL?) {
		guard let url = url, UIApplication.shared.canOpenURL(url) else { return }
		UIApplication.shared.open(url)
	}

	@objc private func finish() {
		dismiss(animated: true)
	}
}
