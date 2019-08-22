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
	fileprivate let firstPlayer = UIImageView()
	fileprivate let secondPlayerResult = UILabel()
	fileprivate let secondPlayer = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		firstPlayer.contentMode = .scaleAspectFit
		firstPlayer.layer.cornerRadius = Metrics.Image.listIcon / 2
		firstPlayer.clipsToBounds = true
		firstPlayer.setContentHuggingPriority(.required, for: .horizontal)

		firstPlayerResult.textAlignment = .right
		firstPlayerResult.setContentHuggingPriority(.required, for: .horizontal)

		secondPlayer.contentMode = .scaleAspectFit
		secondPlayer.layer.cornerRadius = Metrics.Image.listIcon / 2
		secondPlayer.clipsToBounds = true
		secondPlayer.setContentHuggingPriority(.required, for: .horizontal)

		secondPlayerResult.textAlignment = .left
		secondPlayerResult.setContentHuggingPriority(.required, for: .horizontal)

		let separator = UILabel()
		separator.textColor = .textSecondary
		separator.font = separator.font.withSize(Metrics.Text.body)
		separator.text = "—"
		separator.setContentHuggingPriority(.required, for: .horizontal)

		let stackView = UIStackView(arrangedSubviews: [firstPlayerResult, firstPlayer, separator, secondPlayer, secondPlayerResult])
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

			firstPlayerResult.widthAnchor.constraint(equalToConstant: Metrics.Spacing.massive),

			secondPlayer.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			secondPlayer.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			secondPlayerResult.widthAnchor.constraint(equalToConstant: Metrics.Spacing.massive),
			])
	}

	fileprivate func prepareForReuse() {
		firstPlayer.image = nil
		firstPlayerResult.text = nil
		secondPlayer.image = nil
		secondPlayerResult.text = nil
	}
}

struct GamePlayState: ViewState {
	let firstPlayer: Player
	let secondPlayer: Player
	let winners: [ID]

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
	}
}
