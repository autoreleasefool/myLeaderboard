//
//  MyLeaderboardWidget.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-09-20.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MyLeaderboardWidget: View {
	let entry: RecordEntry

	@ViewBuilder
	var body: some View {
		switch entry.content {
		case .noPreferredPlayer:
			NoPreferredPlayer()
		default:
			GameRecords(entry: entry)
				.modifier(ConditionalRedactor(isRedacted: entry.isPreview))
		}
	}
}

struct ConditionalRedactor: ViewModifier {
	let isRedacted: Bool

	@ViewBuilder
	func body(content: Content) -> some View {
		if isRedacted {
			content.redacted(reason: .placeholder)
		} else {
			content
		}
	}
}
