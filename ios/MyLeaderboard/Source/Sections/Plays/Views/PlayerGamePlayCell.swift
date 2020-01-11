//
//  PlayerGamePlayCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias PlayerGamePlayCell = HostCell<PlayerGamePlayView, PlayerGamePlayState, LayoutMarginsTableItemLayout>

class PlayerGamePlayView: UIView {
	fileprivate let gameImage = UIImageView()
	fileprivate let opponent = UIImageView()
	fileprivate let playerScore = UILabel()
	fileprivate let opponentScore = UILabel()
	fileprivate let scoreSeparator = UILabel()
	fileprivate let result = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		gameImage.contentMode = .scaleAspectFit

		setupImageView(opponent)

		setupLabel(playerScore)
		setupLabel(opponentScore)
		setupLabel(result)

		let separator = UILabel()
		separator.textColor = .textSecondary
		separator.font = separator.font.withSize(Metrics.Text.caption)
		separator.text = "vs"
		separator.setContentHuggingPriority(.required, for: .horizontal)

		scoreSeparator.textColor = .textSecondary
		scoreSeparator.font = scoreSeparator.font.withSize(Metrics.Text.caption)
		scoreSeparator.text = "—"
		scoreSeparator.setContentHuggingPriority(.required, for: .horizontal)

		let scoreSpacer = UIView()
		let endSpacer = UIView()

		result.translatesAutoresizingMaskIntoConstraints = false

		let stackView = UIStackView(arrangedSubviews: [gameImage, separator, opponent, scoreSpacer, playerScore, scoreSeparator, opponentScore, endSpacer])
		stackView.spacing = Metrics.Spacing.standard
		stackView.alignment = .center
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		addSubview(result)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: result.leadingAnchor),

			result.topAnchor.constraint(equalTo: topAnchor),
			result.bottomAnchor.constraint(equalTo: bottomAnchor),
			result.trailingAnchor.constraint(equalTo: trailingAnchor),
			result.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),

			gameImage.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			gameImage.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			opponent.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			opponent.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			playerScore.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),
			opponentScore.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),
			])
	}

	private func setupImageView(_ imageView: UIImageView) {
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = Metrics.Image.listIcon / 2
		imageView.clipsToBounds = true
		imageView.setContentHuggingPriority(.required, for: .horizontal)
	}

	private func setupLabel(_ label: UILabel) {
		label.textAlignment = .center
		label.setContentHuggingPriority(.required, for: .horizontal)
		label.textColor = .textSecondary
	}

	fileprivate func prepareForReuse() {
		gameImage.image = nil
		opponent.image = nil
		playerScore.text = nil
		opponentScore.text = nil
		result.text = nil
	}
}

struct PlayerGamePlayState: ViewState {
	let game: Game
	let playerID: ID
	let opponent: Player
	let winners: [ID]
	let playerScore: Int?
	let opponentScore: Int?

	static func updateView(_ view: PlayerGamePlayView, state: PlayerGamePlayState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		if let avatar = state.game.image {
			view.gameImage.image = ImageLoader.shared.fetch(string: avatar) { result in
				if case .success(let url, let image) = result, url.absoluteString == avatar {
					view.gameImage.image = image
				}
			}
		}

		if let avatar = state.opponent.avatar {
			view.opponent.image = ImageLoader.shared.fetch(string: avatar) { result in
				if case .success(let url, let image) = result, url.absoluteString == avatar {
					view.opponent.image = image
				}
			}
		}

		if state.winners.count == 2 {
			view.result.text = "T"
			view.result.textColor = .warning
		} else if state.winners.contains(state.playerID) {
			view.result.text = "W"
			view.result.textColor = .success
		} else {
			view.result.text = "L"
			view.result.textColor = .error
		}

		if let playerScore = state.playerScore, let opponentScore = state.opponentScore {
			view.playerScore.text = "\(playerScore)"
			view.opponentScore.text = "\(opponentScore)"
			view.scoreSeparator.isHidden = false
		} else {
			view.playerScore.text = nil
			view.opponentScore.text = nil
			view.scoreSeparator.isHidden = true
		}
	}
}
