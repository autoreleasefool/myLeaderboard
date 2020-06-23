//
//  MyLeaderboardWidgetExtension.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct MyLeaderboardWidgetExtension: Widget {
	private let kind: String = "MyLeaderboardWidgetExtension"

	public var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind,
			provider: GameSummaryProvider(),
			placeholder: Placeholder()
		) { entry in
			ZStack {
				GameRecords(entry: entry)
			}
			.background(Color(.primary))
		}
		.configurationDisplayName("Game Records")
		.description("An overview of your MyLeaderboard game records.")
		.supportedFamilies([.systemSmall])
	}
}
