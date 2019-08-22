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
