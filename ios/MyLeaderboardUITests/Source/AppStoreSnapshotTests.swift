//
//  AppStoreSnapshotTests.swift
//  MyLeaderboardUITests
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import MyLeaderboard

class MyLeaderboardUITests: XCTestCase {

	override func setUp() {
		continueAfterFailure = false

		let app = XCUIApplication()

		app.launchEnvironment = [
			"initialBoardName": "Shopify Mobile",
			"disableFreshness": true,
		]

		setupSnapshot(app)
		app.launch()
	}

	func testCaptureScreenshots() {
		captureStandings()
		captureGameList()
		captureGameDetails()
		capturePlayerDetails()
	}

	private func captureStandings() {
		let app = XCUIApplication()
		app.textViews["Hive"].waitForExistence(timeout: 10)

		snapshotPortraitAndLandscape("Standings")
	}

	private func captureGameList() {
		let app = XCUIApplication()
		app.tabs["Games"].firstMatch.tap()

		snapshotPortraitAndLandscape("Games")
	}

	private func captureGameDetails() {
		let app = XCUIApplication()
		app.textViews["Hive"].waitForExistence(timeout: 10)
		app.textViews["Hive"].firstMatch.tap()

		app.textViews["Most Recent Plays"].waitForExistence(timeout: 10)

		snapshotPortraitAndLandscape("GameDetails")
	}

	private func capturePlayerDetails() {
		let app = XCUIApplication()
		app.tabs["Players"].firstMatch.tap()
		app.textViews["autoreleasefool"].waitForExistence(timeout: 10)
		app.textViews["autoreleasefool"].firstMatch.tap()
		app.textViews["Most Recent Plays"].waitForExistence(timeout: 10)

		snapshotPortraitAndLandscape("PlayerDetails")
	}

	private var isPhone: Bool {
			UIDevice.current.userInterfaceIdiom == .phone
		}

		private func snapshotPortraitAndLandscape(_ name: String) {
			snapshot(name)
			if !isPhone {
				XCUIDevice.shared.orientation = .landscapeLeft
				sleep(2)
				snapshot("\(name)Landscape")
				XCUIDevice.shared.orientation = .portrait
				sleep(2)
			}
		}
}
