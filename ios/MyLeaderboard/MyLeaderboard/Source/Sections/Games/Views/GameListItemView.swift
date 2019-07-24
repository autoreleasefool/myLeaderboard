//
//  GameListItemView.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias GameListItemCell = HostCell<GameListItemView, GameListItemState, LayoutMarginsTableItemLayout>

class GameListItemView: UIView {
	fileprivate let gameImage = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		prepareForReuse()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		gameImage.contentMode = .scaleAspectFit
		gameImage.translatesAutoresizingMaskIntoConstraints = false
		addSubview(gameImage)

		NSLayoutConstraint.activate([
			gameImage.topAnchor.constraint(equalTo: topAnchor),
			gameImage.bottomAnchor.constraint(equalTo: bottomAnchor),
			gameImage.centerXAnchor.constraint(equalTo: centerXAnchor),
			gameImage.widthAnchor.constraint(equalToConstant: Metrics.Image.large),
			gameImage.heightAnchor.constraint(equalToConstant: Metrics.Image.large),
			])
	}

	fileprivate func prepareForReuse() {
		gameImage.image = nil
	}
}

struct GameListItemState: Equatable {
	let game: Game

	static func updateView(_ view: GameListItemView, state: GameListItemState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		if let image = state.game.image {
			view.gameImage.image = ImageLoader.shared.fetch(string: image) { result in
				if case .success(let image) = result {
					view.gameImage.image = image
				}
			}
		}
	}
}
