//
//  MyLeaderboardApi+WidgetExtensions.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit

extension MyLeaderboardApi.WidgetGameFragment {
	var previewImage: UIImage? {
		guard let image = image, image.hasPrefix("#") else { return nil }
		return UIImage(named: String(image.dropFirst()))
	}
}

extension MyLeaderboardApi.SmallWidgetRecordFragment: Identifiable {
	// swiftlint:disable:next identifier_name
	public var id: GraphID {
		return game.id
	}
}

// MARK: - Mocks

extension MyLeaderboardApi.SmallWidgetResponse {
	// swiftlint:disable line_length
	static var preview: MyLeaderboardApi.SmallWidgetResponse {
		.init(player: .init(records: [
			MyLeaderboardApi.SmallWidgetResponse.Player.Records(smallWidgetRecordFragmentFragment: .init(game: .init(widgetGameFragmentFragment: .init(id: GraphID(rawValue: "0"), image: "#HivePreview", name: "Hive")), overallRecord: .init(recordFragmentFragment: .init(wins: 12, losses: 2, ties: 1, isBest: true, isWorst: false)))),
			MyLeaderboardApi.SmallWidgetResponse.Player.Records(smallWidgetRecordFragmentFragment: .init(game: .init(widgetGameFragmentFragment: .init(id: GraphID(rawValue: "1"), image: "#PatchworkPreview", name: "Hive")), overallRecord: .init(recordFragmentFragment: .init(wins: 29, losses: 3, ties: 0, isBest: false, isWorst: false)))),
		]))
	}
	// swiftlint:enable line_length
}

extension MyLeaderboardApi.MediumWidgetResponse {
	static var preview: MyLeaderboardApi.MediumWidgetResponse {
		fatalError()
	}
}
