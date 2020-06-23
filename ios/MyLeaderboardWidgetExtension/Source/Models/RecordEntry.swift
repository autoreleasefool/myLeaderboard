//
//  RecordEntry.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation
import WidgetKit

struct RecordEntry: TimelineEntry {
	enum Content {
		case small(MyLeaderboardAPI.SmallWidgetResponse)
		case medium(MyLeaderboardAPI.MediumWidgetResponse)
	}

	let date: Date
	let content: Content

	init(content: Content) {
		self.date = Date()
		self.content = content
	}

	init?(from response: GraphApiResponse) {
		self.date = Date()
		if let smallResponse = response as? MyLeaderboardAPI.SmallWidgetResponse {
			self.content = .small(smallResponse)
		} else if let mediumResponse = response as? MyLeaderboardAPI.MediumWidgetResponse {
			self.content = .medium(mediumResponse)
		} else {
			return nil
		}
	}
}

// MARK: - Accessors

extension RecordEntry {
	var isValidEntry: Bool {
		switch content {
		case .small(let response): return response.player != nil
		case .medium(let response): return response.player != nil
		}
	}

	var summaries: [(MyLeaderboardAPI.WidgetGameFragment, MyLeaderboardAPI.RecordFragment)] {
		guard isValidEntry else { return [] }
		return Array(zip(games, overallRecords))
	}

	var games: [MyLeaderboardAPI.WidgetGameFragment] {
		guard isValidEntry else { return [] }
		switch content {
		case .small(let response):
			return response.player!.records.map {
				$0.game.asWidgetGameFragmentFragment
			}
		case .medium(let response):
			return response.player!.records.map {
				$0.asMediumWidgetRecordFragmentFragment.game.asWidgetGameFragmentFragment
			}
		}
	}

	var overallRecords: [MyLeaderboardAPI.RecordFragment] {
		switch content {
		case .small(let response):
			return response.player!.records.map {
				$0.asSmallWidgetRecordFragmentFragment
					.overallRecord
					.asRecordFragmentFragment
			}
		case .medium(let response):
			return response.player!.records.map {
				$0.asMediumWidgetRecordFragmentFragment
					.asSmallWidgetRecordFragmentFragment
					.overallRecord
					.asRecordFragmentFragment
			}
		}
	}
}

// MARK: RecordEntry preview

extension RecordEntry {
	static func preview(family: WidgetFamily) -> RecordEntry {
		switch family {
		case .systemSmall:
			return RecordEntry(content: .small(.preview))
		case .systemMedium:
			return RecordEntry(content: .medium(.preview))
		case .systemLarge:
			fatalError("WidgetFamily \(family) not supported")
		@unknown default:
			return RecordEntry(content: .small(.preview))
		}
	}
}
