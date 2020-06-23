//
//  MyLeaderboardAPI+WidgetExtensions.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit

extension MyLeaderboardAPI.WidgetGameFragment {
	var previewImage: UIImage? {
		guard let image = image, image.hasPrefix("#") else { return nil }
		return UIImage(named: String(image.dropFirst()))
	}
}

extension MyLeaderboardAPI.SmallWidgetRecordFragment: Identifiable {
	// swiftlint:disable:next identifier_name
	public var id: GraphID {
		return game.id
	}
}

// MARK: - Mocks

extension MyLeaderboardAPI.SmallWidgetResponse {
	static var preview: MyLeaderboardAPI.SmallWidgetResponse {
		fatalError()
	}
}

extension MyLeaderboardAPI.MediumWidgetResponse {
	static var preview: MyLeaderboardAPI.MediumWidgetResponse {
		fatalError()
	}
}

//let smallPreviewGames = [
//	SmallRecord(
//		game: .init(widgetGameFragmentFragment: .init(id: GraphID(rawValue: "1"), image: "HivePreview")),
//		overallRecord: .init(recordFragmentFragment: .init(wins: 12, losses: 8, ties: 2, isBest: true, isWorst: false))
//	),
//	SmallRecord(
//		game: .init(widgetGameFragmentFragment: .init(id: GraphID(rawValue: "2"), image: "PatchworkPreview")),
//		overallRecord: .init(recordFragmentFragment: .init(wins: 12, losses: 8, ties: 2, isBest: true, isWorst: false))
//	),
//]
