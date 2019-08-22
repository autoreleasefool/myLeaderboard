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
		let trophyView = UIImageView(image: UIImage(named: "Score/Trophy"))
		bestScore.textColor = .text
		bestScore.font = bestScore.font.withSize(Metrics.Text.body)

		let poopView = UIImageView(image: UIImage(named: "Score/Poop"))
		worstScore.textColor = .text
		worstScore.font = worstScore.font.withSize(Metrics.Text.caption)

		let averageView = UIImageView(image: UIImage(named: "Score/Average"))
		averageScore.textColor = .text
		averageScore.font = averageScore.font.withSize(Metrics.Text.caption)

		let bestStackView = UIStackView(arrangedSubviews: [trophyView, bestScore])
		bestStackView.alignment = .center
		bestStackView.spacing = Metrics.Spacing.small

		let worstStackView = UIStackView(arrangedSubviews: [poopView, worstScore])
		worstStackView.alignment = .center
		worstStackView.spacing = Metrics.Spacing.small

		let averageStackView = UIStackView(arrangedSubviews: [averageView, averageScore])
		averageStackView.alignment = .center
		averageStackView.spacing = Metrics.Spacing.small

		let mainStackView = UIStackView(arrangedSubviews: [bestStackView, worstStackView, averageStackView])
		mainStackView.alignment = .center
		mainStackView.axis = .vertical
		mainStackView.translatesAutoresizingMaskIntoConstraints = false
		mainStackView.spacing = Metrics.Spacing.small
		addSubview(mainStackView)

		NSLayoutConstraint.activate([
			mainStackView.topAnchor.constraint(equalTo: topAnchor),
			mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

			trophyView.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			trophyView.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			poopView.widthAnchor.constraint(equalToConstant: Metrics.Image.medium),
			poopView.heightAnchor.constraint(equalToConstant: Metrics.Image.medium),

			averageView.widthAnchor.constraint(equalToConstant: Metrics.Image.medium),
			averageView.heightAnchor.constraint(equalToConstant: Metrics.Image.medium),
			])
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
