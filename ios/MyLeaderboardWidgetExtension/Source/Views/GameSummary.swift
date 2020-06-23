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
	let	record: SmallRecord

	var body: some View {
		HStack {
			RemoteImage(url: URL(string: record.game.image ?? ""))
			Text(record.)
		}
	}
}
