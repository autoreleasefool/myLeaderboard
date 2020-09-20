//
//  GameRecords.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI

struct GameRecords: View {
	let entry: GameSummaryProvider.Entry

	var body: some View {
		VStack {
			Spacer()
			ForEach(entry.summaries, id: \.0.id) { (game, record) in
				GameSummary(game: game, record: record)
			}
			Spacer()
		}
		.padding()
	}
}
