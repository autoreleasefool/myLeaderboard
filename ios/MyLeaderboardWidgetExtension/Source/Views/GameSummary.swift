//
//  GameSummary.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import MyLeaderboardApi
import SwiftUI
import WidgetKit

struct GameSummary: View {
	let game: MyLeaderboardApi.WidgetGameFragment
	let record: MyLeaderboardApi.RecordFragment

	var body: some View {
		HStack(spacing: Metrics.Spacing.small) {
			RemoteImage(url: URL(string: game.image ?? ""))
				.frame(width: Metrics.Image.medium, height: Metrics.Image.medium)
			Text(record.formatted)
				.lineLimit(1)
				.foregroundColor(Color(record.backgroundColor ?? .text))
				.font(.system(.caption))
			Spacer()
		}
	}
}
