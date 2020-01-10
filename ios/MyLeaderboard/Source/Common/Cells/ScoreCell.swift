//
//  ScoreCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias ScoreCell = HostCell<ScoreCellView, ScoreCellState, LayoutMarginsTableItemLayout>

class ScoreCellView: UIView {
	fileprivate let bestScore = UILabel()
	fileprivate let worstScore = UILabel()
	fileprivate let averageScore = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		let trophyView = setupImageView(UIImage(named: "Score/Trophy"), size: Metrics.Image.medium)
		bestScore.textColor = .text
		bestScore.font = bestScore.font.withSize(Metrics.Text.body)

		let rainyView = setupImageView(UIImage(named: "Score/Rain"), size: Metrics.Image.small)
		rainyView.tintColor = .textSecondary
		rainyView.alpha = 0.5
		rainyView.isOpaque = false
		worstScore.textColor = .text
		worstScore.font = worstScore.font.withSize(Metrics.Text.caption)

		let averageView = setupImageView(UIImage(named: "Score/Average"), size: Metrics.Image.small)
		averageView.tintColor = .textSecondary
		averageView.alpha = 0.7
		averageView.isOpaque = false
		averageScore.textColor = .text
		averageScore.font = averageScore.font.withSize(Metrics.Text.caption)

		let bestStackView = UIStackView(arrangedSubviews: [trophyView, bestScore])
		bestStackView.alignment = .center
		bestStackView.spacing = Metrics.Spacing.small

		let worstStackView = UIStackView(arrangedSubviews: [rainyView, worstScore])
		worstStackView.alignment = .center
		worstStackView.spacing = Metrics.Spacing.small

		let averageStackView = UIStackView(arrangedSubviews: [averageView, averageScore])
		averageStackView.alignment = .center
		averageStackView.spacing = Metrics.Spacing.small

		let mainStackView = UIStackView(arrangedSubviews: [bestStackView, worstStackView, averageStackView])
		mainStackView.alignment = .leading
		mainStackView.axis = .vertical
		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		mainStackView.spacing = Metrics.Spacing.small
		addSubview(mainStackView)

		NSLayoutConstraint.activate([
			mainStackView.topAnchor.constraint(equalTo: topAnchor),
			mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			])
	}

	private func setupImageView(_ image: UIImage?, size: CGFloat) -> UIImageView {
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.widthAnchor.constraint(equalToConstant: Metrics.Image.medium).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
		return imageView
	}

	fileprivate func prepareForReuse() {
		bestScore.text = nil
		worstScore.text = nil
		averageScore.text = nil
	}
}

struct ScoreCellState: ViewState {
	let bestScore: Int
	let worstScore: Int
	let averageScore: Double

	static func updateView(_ view: ScoreCellView, state: ScoreCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.bestScore.text = "\(state.bestScore) points"
		view.worstScore.text = "\(state.worstScore) points"
		view.averageScore.text = "\(String(format: "%.2f", state.averageScore)) points per game"
	}
}
