//
//  PlayerPlayCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias PlayerPlayCell = HostCell<PlayerPlayCellView, PlayerPlayCellState, LayoutMarginsTableItemLayout>

class PaddedUITextField: UITextField {
	let padding = UIEdgeInsets(
		top: Metrics.Spacing.tiny,
		left: Metrics.Spacing.tiny,
		bottom: Metrics.Spacing.tiny,
		right: Metrics.Spacing.tiny
	)

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
}

class PlayerPlayCellView: UIView {
	fileprivate let avatar = UIImageView()
	fileprivate let name = UILabel()
	fileprivate let score = PaddedUITextField()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		avatar.contentMode = .scaleAspectFit
		avatar.layer.cornerRadius = Metrics.Image.listIcon / 2
		avatar.layer.borderColor = UIColor.primary.cgColor
		avatar.layer.borderWidth = Metrics.Spacing.tiny
		avatar.clipsToBounds = true
		avatar.translatesAutoresizingMaskIntoConstraints = false
		addSubview(avatar)

		name.textColor = .text
		name.font = name.font.withSize(Metrics.Text.body)
		name.translatesAutoresizingMaskIntoConstraints = false
		addSubview(name)

		score.font = score.font?.withSize(Metrics.Text.body)
		score.placeholder = "0"
		score.keyboardType = .numbersAndPunctuation
		score.textAlignment = .right
		score.backgroundColor = .primaryExtraDark
		score.textColor = .text
		score.layer.cornerRadius = Metrics.Spacing.small
		score.translatesAutoresizingMaskIntoConstraints = false
		addSubview(score)

		NSLayoutConstraint.activate([
			avatar.leadingAnchor.constraint(equalTo: leadingAnchor),
			avatar.topAnchor.constraint(equalTo: topAnchor),
			avatar.bottomAnchor.constraint(equalTo: bottomAnchor),
			avatar.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			avatar.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: Metrics.Spacing.small),
			name.centerYAnchor.constraint(equalTo: centerYAnchor),

			score.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Spacing.small),
			score.widthAnchor.constraint(equalToConstant: 96),
			score.centerYAnchor.constraint(equalTo: centerYAnchor),
			])
	}

	fileprivate func prepareForReuse() {
		avatar.image = nil
		name.text = nil
		score.text = nil
	}
}

struct PlayerPlayCellState: ViewState {
	let name: String
	let avatar: String?
	let score: Int
	let isWinner: Bool
	let hasScores: Bool

	let onUpdateScore: (Int) -> Void

	static func updateView(_ view: PlayerPlayCellView, state: PlayerPlayCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.name.text = state.name
		view.score.text = "\(state.score)"
		view.score.isHidden = !state.hasScores

		if state.isWinner {
			view.avatar.layer.borderColor = UIColor.success.cgColor
		} else {
			view.avatar.layer.borderColor = UIColor.primary.cgColor
		}

		if let avatar = state.avatar {
			view.avatar.image = ImageLoader.shared.fetch(string: avatar) { result in
				if case .success((let url, let image)) = result, url.absoluteString == avatar {
					view.avatar.image = image
				}
			}
		}

		view.score.setActions([
			ControlAction(events: .editingChanged) { sender in
				guard var text = sender.text else { return }
				text = String(text[..<text.index(text.startIndex, offsetBy: min(text.count, 4))])
				text = text.components(separatedBy: CharacterSet(charactersIn: "0123456789-").inverted).joined()

				var multiplier = 1
				if let negative = text.lastIndex(of: "-") {
					text.remove(at: negative)
					multiplier = -1
				}

				let score = (Int(text) ?? 0) * multiplier
				sender.text = "\(score)"
				state.onUpdateScore(score)
			},
		])
	}

	static func == (lhs: PlayerPlayCellState, rhs: PlayerPlayCellState) -> Bool {
		return lhs.name == rhs.name &&
			lhs.avatar == rhs.avatar &&
			lhs.score == rhs.score &&
			lhs.isWinner == rhs.isWinner &&
			lhs.hasScores == rhs.hasScores
	}
}
