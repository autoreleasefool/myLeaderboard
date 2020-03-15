//
//  PlaysListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol PlaysListActionable: AnyObject {

}

enum PlaysListBuilder {
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(
		forPlayer playerID: GraphID,
		plays: [PlayListItem],
		actionable: PlaysListActionable
	) -> [TableSection] {
		var lastDatePlayed: Date?
		var rows: [CellConfigType] = []
		plays.forEach { play in
			guard let player = play.players.first(where: { $0.id == playerID }),
				let opponent = play.players.first(where: { $0.id != player.id }) else { return }

			var playerScore: Int?
			var opponentScore: Int?
			if let scores = play.scores, scores.count >= 2 {
				if play.players.first == player {
					playerScore = scores[0]
					opponentScore = scores[1]
				} else {
					playerScore = scores[1]
					opponentScore = scores[0]
				}
			}

			if let date = play.playedOnDay, date != lastDatePlayed {
				rows.append(dateCell(for: date))
				lastDatePlayed = date
			}

			rows.append(PlayerGamePlayCell(
				key: "Play-\(play.id)",
				state: PlayerGamePlayState(
					gameImage: play.game.image,
					playerID: playerID,
					opponentAvatar: opponent.avatar,
					winners: play.winners.map { $0.id },
					playerScore: playerScore,
					opponentScore: opponentScore
				),
				cellUpdater: PlayerGamePlayState.updateView
			))
		}

		return [TableSection(key: "Plays", rows: rows)]
	}

	static func sections(plays: [PlayListItem], actionable: PlaysListActionable) -> [TableSection] {
		var lastDatePlayed: Date?
		var rows: [CellConfigType] = []
		plays.forEach { play in
			guard let firstPlayer = play.players.first,
				let secondPlayer = play.players.last,
				play.players.count == 2 else { return }

			if let date = play.playedOnDay, date != lastDatePlayed {
				rows.append(dateCell(for: date))
				lastDatePlayed = date
			}

			rows.append(GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(
					firstPlayerID: firstPlayer.id,
					firstPlayerAvatar: Avatar(from: firstPlayer.avatar),
					secondPlayerAvatar: Avatar(from: secondPlayer.avatar),
					winners: play.winners.map { $0.id },
					scores: play.scores
				),
				cellUpdater: GamePlayState.updateView
			))
		}

		return [TableSection(key: "Plays", rows: rows)]
	}

	static func emptySection() -> TableSection {
		return TableSection(
			key: "Empty",
			rows: [
				LabelCell(
					key: "NoData",
					style: CellStyle(backgroundColor: .primaryDark),
					state: LabelState(
						text: .attributed(NSAttributedString(
							string: "There doesn't seem to be anything here 😿",
							textColor: .textSecondary
						)),
						alignment: .center,
						size: Metrics.Text.body
					),
					cellUpdater: LabelState.updateView
				),
			]
		)
	}

	static func dateCell(for date: Date) -> CellConfigType {
		let dateString = PlaysListBuilder.dateFormatter.string(from: date)
		return LabelCell(
			key: "Date-\(dateString)",
			state: LabelState(
				text: .attributed(NSAttributedString(string: dateString, textColor: .textSecondary)),
				size: Metrics.Text.caption
			),
			cellUpdater: LabelState.updateView
		)
	}
}
