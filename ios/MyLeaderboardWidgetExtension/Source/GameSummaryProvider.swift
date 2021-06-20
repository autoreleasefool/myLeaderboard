//
//  GameSummaryProvider.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-23.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi
import WidgetKit

class GameSummaryProvider: TimelineProvider {
	typealias SmallQuery = MyLeaderboardApi.SmallWidgetQuery
	typealias MediumQuery = MyLeaderboardApi.MediumWidgetQuery

	private var cancellable: AnyCancellable?

	func placeholder(in context: Context) -> RecordEntry {
		RecordEntry(content: .preview)
	}

	func getSnapshot(in context: Context, completion: @escaping (RecordEntry) -> Void) {
		completion(placeholder(in: context))
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<RecordEntry>) -> Void) {
		func onFinish(entry: RecordEntry?) {
			let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
			let timeline = Timeline(entries: [entry ?? placeholder(in: context)], policy: .after(nextUpdateDate))
			completion(timeline)
		}

		switch context.family {
		case .systemSmall:
			performSmallQuery(completion: onFinish)
		default:
			fatalError("WidgetFamily \(context.family) not supported")
		}
	}

	private func performSmallQuery(completion: @escaping (RecordEntry?) -> Void) {
		guard let preferredPlayer = Player.preferred else {
			completion(RecordEntry(content: .noPreferredPlayer))
			return
		}

		cancellable = MLApi.shared.fetch(query: SmallQuery(player: preferredPlayer.id))
			.sink(receiveCompletion: { result in
				if case .failure = result {
					completion(nil)
				}
			}, receiveValue: { value in
				guard let response = value.response else { return }
				let images = response.player?.records.map {
					$0.game.image
				}.compactMap { $0} ?? []

				ImageLoader.shared.bulkPreFetch(images) {
					completion(RecordEntry(from: response))
				}
			})
	}

	private func performMediumQuery(completion: @escaping (RecordEntry?) -> Void) {
		guard let preferredPlayer = Player.preferred else {
			completion(RecordEntry(content: .noPreferredPlayer))
			return
		}

		cancellable = MLApi.shared.fetch(query: MediumQuery(player: preferredPlayer.id))
			.sink(receiveCompletion: { result in
				if case .failure = result {
					completion(nil)
				}
			}, receiveValue: { value in
				guard let response = value.response else { return }
				let images = response.player?.records.map {
					$0.asMediumWidgetRecordFragmentFragment.game.image
				}.compactMap { $0} ?? []

				ImageLoader.shared.bulkPreFetch(images) {
					completion(RecordEntry(from: response))
				}
			})
	}
}
