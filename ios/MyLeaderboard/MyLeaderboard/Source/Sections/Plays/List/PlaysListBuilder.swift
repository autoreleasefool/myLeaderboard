//
//  PlaysListBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

protocol PlaysListActionable: AnyObject {

}

struct PlaysListBuilder {
	static func sections(forPlayer player: Player, plays: [GamePlay], games: [Game], players: [Player], actionable: PlaysListActionable) -> [TableSection] {
		let rows: [CellConfigType] = plays.compactMap { play in
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }),
				let game = games.first(where: { $0.id == play.game }) else { return nil }

			let opponent: Player
			var playerScore: Int?
			var opponentScore: Int?
			if firstPlayer == player {
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

			return PlayerGamePlayCell(
				key: "Play-\(play.id)",
				state: PlayerGamePlayState(game: game, player: player, opponent: opponent, winners: play.winners, playerScore: playerScore, opponentScore: opponentScore),
				cellUpdater: PlayerGamePlayState.updateView
			)
		}

		return [TableSection(key: "Plays", rows: rows)]
	}

	static func sections(forGame game: Game, plays: [GamePlay], players: [Player], actionable: PlaysListActionable) -> [TableSection] {
		return sections(plays: plays, players: players, actionable: actionable)
	}

	static func sections(plays: [GamePlay], players: [Player], actionable: PlaysListActionable) -> [TableSection] {
		let rows: [CellConfigType] = plays.compactMap { play in
			guard let firstPlayer = players.first(where: { $0.id == play.players[0] }),
				let secondPlayer = players.first(where: { $0.id == play.players[1] }) else { return nil }

			return GamePlayCell(
				key: "Play-\(play.id)",
				state: GamePlayState(firstPlayer: firstPlayer, secondPlayer: secondPlayer, winners: play.winners, scores: play.scores),
				cellUpdater: GamePlayState.updateView
			)
		}

		return [TableSection(key: "Plays", rows: rows)]
	}
}
