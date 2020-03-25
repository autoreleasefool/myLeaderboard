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
	fileprivate let gameName = UILabel()
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

		gameName.textColor = .text
		gameName.font = gameName.font.withSize(Metrics.Text.title)

		let stackView = UIStackView(arrangedSubviews: [gameImage, gameName])
		stackView.spacing = Metrics.Spacing.small
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			gameImage.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			gameImage.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			])
	}

	fileprivate func prepareForReuse() {
		gameImage.image = nil
		gameName.text = nil
	}
}

struct GameListItemState: ViewState {
	let name: String
	let image: String?

	static func updateView(_ view: GameListItemView, state: GameListItemState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.gameName.text = state.name

		if let image = state.image {
			view.gameImage.isHidden = false
			view.gameImage.image = ImageLoader.shared.fetch(string: image) { result in
				if case .success((let url, let image)) = result, url.absoluteString == state.image {
					view.gameImage.image = image
				}
			}
		} else {
			view.gameImage.isHidden = true
		}
	}
}
