//
//  Placeholder.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI
import WidgetKit

struct Placeholder: View {
	@Environment(\.widgetFamily) var family: WidgetFamily

	@ViewBuilder
	var body: some View {
		switch family {
		case .systemSmall: GameRecords(entry: RecordEntry.preview(family: .systemSmall))
		case .systemMedium: GameRecords(entry: RecordEntry.preview(family: .systemMedium))
		default: GameRecords(entry: RecordEntry.preview(family: .systemSmall))
		}
	}
}
