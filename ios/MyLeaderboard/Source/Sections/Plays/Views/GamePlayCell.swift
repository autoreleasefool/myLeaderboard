//
//  GamePlayCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias GamePlayCell = HostCell<GamePlayView, GamePlayState, LayoutMarginsTableItemLayout>

class GamePlayView: UIView {
	fileprivate let firstPlayerResult = UILabel()
	fileprivate let secondPlayerResult = UILabel()
	fileprivate let firstPlayerScore = UILabel()
	fileprivate let secondPlayerScore = UILabel()
	fileprivate let firstPlayer = UIImageView()
	fileprivate let secondPlayer = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		setupImageView(firstPlayer)
		setupImageView(secondPlayer)
		setupLabel(firstPlayerScore)
		setupLabel(secondPlayerScore)
		setupLabel(firstPlayerResult)
		setupLabel(secondPlayerResult)

		let separator = UILabel()
		separator.textColor = .textSecondary
		separator.font = separator.font.withSize(Metrics.Text.body)
		separator.text = "—"
		separator.setContentHuggingPriority(.required, for: .horizontal)

		let stackView = UIStackView(arrangedSubviews: [firstPlayerScore, firstPlayerResult, firstPlayer, separator, secondPlayer, secondPlayerResult, secondPlayerScore])
		stackView.spacing = Metrics.Spacing.standard
		stackView.alignment = .center
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
			stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
			stackView.centerXAnchor.constraint(equalTo: centerXAnchor),

			firstPlayer.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			firstPlayer.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			firstPlayerScore.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),
			firstPlayerResult.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),

			secondPlayer.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			secondPlayer.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			secondPlayerScore.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),
			secondPlayerResult.widthAnchor.constraint(equalToConstant: Metrics.Spacing.large),
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
		firstPlayer.image = nil
		firstPlayerResult.text = nil
		firstPlayerScore.text = nil
		secondPlayer.image = nil
		secondPlayerResult.text = nil
		secondPlayerScore.text = nil
	}
}

struct GamePlayState: ViewState {
	let firstPlayer: Player
	let secondPlayer: Player
	let winners: [ID]
	let scores: [Int]?

	static func updateView(_ view: GamePlayView, state: GamePlayState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		if let avatar = state.firstPlayer.avatar {
			view.firstPlayer.image = ImageLoader.shared.fetch(string: avatar) { result in
				if case .success(let url, let image) = result, url.absoluteString == avatar {
					view.firstPlayer.image = image
				}
			}
		}

		if let avatar = state.secondPlayer.avatar {
			view.secondPlayer.image = ImageLoader.shared.fetch(string: avatar) { result in
				if case .success(let url, let image) = result, url.absoluteString == avatar {
					view.secondPlayer.image = image
				}
			}
		}

		if state.winners.count == 2 {
			view.firstPlayerResult.text = "T"
			view.firstPlayerResult.textColor = .warning
			view.secondPlayerResult.text = "T"
			view.secondPlayerResult.textColor = .warning
		} else if state.winners.contains(state.firstPlayer.id) {
			view.firstPlayerResult.text = "W"
			view.firstPlayerResult.textColor = .success
			view.secondPlayerResult.text = "L"
			view.secondPlayerResult.textColor = .error
		} else {
			view.firstPlayerResult.text = "L"
			view.firstPlayerResult.textColor = .error
			view.secondPlayerResult.text = "W"
			view.secondPlayerResult.textColor = .success
		}

		if let scores = state.scores, scores.count >= 2 {
			view.firstPlayerScore.text = "\(scores[0])"
			view.secondPlayerScore.text = "\(scores[1])"
		} else {
			view.firstPlayerScore.text = nil
			view.secondPlayerScore.text = nil
		}
	}
}
