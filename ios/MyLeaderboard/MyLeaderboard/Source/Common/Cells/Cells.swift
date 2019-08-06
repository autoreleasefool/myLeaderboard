//
//  Cells.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias GameCell = CombinedCell<UIImageView, ImageState, UILabel, LabelState, LayoutMarginsTableItemLayout>
typealias GameCellState = CombinedState<ImageState, LabelState>

typealias PlayerCell = CombinedCell<UIImageView, ImageState, UILabel, LabelState, LayoutMarginsTableItemLayout>
typealias PlayerCellState = CombinedState<ImageState, LabelState>

struct Cells {
	static func gameState(for game: Game) -> GameCellState {
		let imageState = ImageState(url: URL(string: game.image ?? ""), width: Metrics.Image.listIcon, height: Metrics.Image.listIcon)
		let labelState = LabelState(text: .attributed(NSAttributedString(string: game.name, textColor: .text)), size: Metrics.Text.title)

		return GameCellState(state1: imageState, state2: labelState)
	}

	static func playerState(for player: Player) -> PlayerCellState {
		let imageState = ImageState(url: URL(string: player.avatar ?? ""), width: Metrics.Image.listIcon, height: Metrics.Image.listIcon)
		let labelState = LabelState(text: .attributed(NSAttributedString(string: player.displayName, textColor: .text)), size: Metrics.Text.body)

		return PlayerCellState(state1: imageState, state2: labelState)
	}
}
