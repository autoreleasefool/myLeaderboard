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

struct PlaysListBuilder {
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .long
		return formatter
	}()

	static func sections(
		forPlayer playerID: ID,
		plays: [GamePlay],
		games: [Game],
		players: [Player],
		actionable: PlaysListActionable
	) -> [TableSection] {
		var lastDatePlayed: Date?
		var rows: [CellConfigType] = []
		plays.forEach { play in
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }),
				let game = games.first(where: { $0.id == play.game }) else { return }

			let opponent: Player
			var playerScore: Int?
			var opponentScore: Int?
			if firstPlayer.id == playerID {
				opponent = secondPlayer
				if let scores = play.scores, scores.count >= 2 {
					playerScore = scores[0]
					opponentScore = scores[1]
				}
			} else {
				opponent = firstPlayer
				if let scores = play.scores, scores.count >= 2 {
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
					gameImage: game.image,
					playerID: GraphID(rawValue: String(playerID))!,
					opponentAvatar: opponent.avatar,
					winners: play.winners.map { GraphID(rawValue: String($0))! },
					playerScore: playerScore,
					opponentScore: opponentScore
				),
				cellUpdater: PlayerGamePlayState.updateView
			))
		}

		return [TableSection(key: "Plays", rows: rows)]
	}

	static func sections(plays: [GamePlay], players: [Player], actionable: PlaysListActionable) -> [TableSection] {
		var lastDatePlayed: Date?
		var rows: [CellConfigType] = []
		plays.forEach { play in
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }) else { return }

			if let date = play.playedOnDay, date != lastDatePlayed {
				rows.append(dateCell(for: date))
				lastDatePlayed = date
			}

			rows.append(GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(
					firstPlayerID: firstPlayer.graphID,
					firstPlayerAvatar: firstPlayer.qualifiedAvatar,
					secondPlayerAvatar: secondPlayer.qualifiedAvatar,
					winners: play.winners.map { GraphID(rawValue: String($0)) },
					scores: play.scores
				),
				cellUpdater: GamePlayState.updateView
			))
		}

		return [TableSection(key: "Plays", rows: rows)]
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
