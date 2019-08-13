//
//  BlankStandingsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-12.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

class BlankStandingsViewController: FTDViewController {
	private var api: LeaderboardAPI

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()

		self.title = "Standings"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(recordPlay))
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func recordPlay() {
		presentModal(RecordPlayViewController(api: api))
	}
}
