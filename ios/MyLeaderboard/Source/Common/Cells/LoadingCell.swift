//
//  LoadingCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-15.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias LoadingCell = HostCell<LoadingCellView, LoadingCellState, LayoutMarginsTableItemLayout>

class LoadingCellView: UIView {
	private let spinner = UIActivityIndicatorView(style: .large)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		prepareForReuse()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		addSubview(spinner)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			spinner.leadingAnchor.constraint(equalTo: leadingAnchor),
			spinner.trailingAnchor.constraint(equalTo: trailingAnchor),
			spinner.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.Spacing.standard),
			spinner.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}

	fileprivate func prepareForReuse() {
		isLoading = false
	}

	var isLoading: Bool = false {
		didSet {
			if isLoading {
				self.isHidden = false
				DispatchQueue.main.async {
					self.spinner.startAnimating()
				}
			} else {
				self.isHidden = true
				self.spinner.stopAnimating()
			}
		}
	}
}

struct LoadingCellState: ViewState {
	let style: UIActivityIndicatorView.Style
	let loading: Bool

	static func updateView(_ view: LoadingCellView, state: LoadingCellState?) {
		guard let state = state else {
			return view.prepareForReuse()
		}

		view.isLoading = state.loading
	}
}

extension LoadingCell {
	static func section(
		style: UIActivityIndicatorView.Style = .large,
		backgroundColor: UIColor = .primaryDark
	) -> TableSection {
		return TableSection(key: "Loading", rows: [loadingCell(style: style, backgroundColor: backgroundColor)])
	}

	private static func loadingCell(style: UIActivityIndicatorView.Style, backgroundColor: UIColor) -> CellConfigType {
		return LoadingCell(
			key: "Loading",
			style: CellStyle(backgroundColor: backgroundColor),
			state: LoadingCellState(style: style, loading: true),
			cellUpdater: LoadingCellState.updateView
		)
	}
}
