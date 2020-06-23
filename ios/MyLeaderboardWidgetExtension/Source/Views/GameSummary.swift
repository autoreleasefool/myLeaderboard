//
//  GameSummary.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI
import WidgetKit

struct GameSummary: View {
	let game: MyLeaderboardAPI.WidgetGameFragment
	let record: MyLeaderboardAPI.RecordFragment

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(game.name)
				.foregroundColor(Color(.text))
				.font(.system(.caption2))
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
}
