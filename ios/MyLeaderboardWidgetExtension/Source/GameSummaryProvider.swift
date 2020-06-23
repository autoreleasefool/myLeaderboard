//
//  GameSummaryProvider.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import WidgetKit

struct GameSummaryProvider: TimelineProvider {
	typealias SmallQuery = MyLeaderboardAPI.SmallWidgetQuery
	typealias MediumQuery = MyLeaderboardAPI.MediumWidgetQuery

	var queryResults: [WidgetFamily: GraphApiResponse] = [:]
	var cancellable: AnyCancellable?

	public func snapshot(with context: Context, completion: @escaping (RecordEntry) -> Void) {
		var entry: RecordEntry?
		if let data = queryResults[context.family] {
			entry = RecordEntry(from: data)
		}

		completion(entry ?? RecordEntry.preview(family: context.family))
	}

	public func timeline(with context: Context, completion: @escaping (Timeline<RecordEntry>) -> Void) {
		func onFinish(entry: RecordEntry?) {
			let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
			let timeline = Timeline(entries: [entry].compactMap { $0 }, policy: .after(nextUpdateDate))
			completion(timeline)
		}

		switch context.family {
		case .systemSmall: performSmallQuery(completion: onFinish)
		case .systemMedium: performMediumQuery(completion: onFinish)
		default: fatalError("WidgetFamily \(context.family) not supported")
		}
	}

	private func performSmallQuery(completion: @escaping (RecordEntry?) -> Void) {
		SmallQuery(player: GraphID("0")).perform {
			switch $0 {
			case .success(let response):
				let images = response.player?.records.map { $0.game.image }.compactMap { $0 } ?? []
				ImageLoader.shared.bulkPreFetch(images) {
					completion(RecordEntry(from: response))
				}
			case .failure:
				completion(nil)
			}
		}
	}

	private func performMediumQuery(completion: @escaping (RecordEntry?) -> Void) {
		MediumQuery(player: GraphID("0")).perform {
			switch $0 {
			case .success(let response):
				let images = response.player?.records.map {
					$0.asMediumWidgetRecordFragmentFragment.game.image
				}.compactMap { $0 } ?? []

				ImageLoader.shared.bulkPreFetch(images) {
					completion(RecordEntry(from: response))
				}
			case .failure:
				completion(nil)
			}
		}
	}
}
