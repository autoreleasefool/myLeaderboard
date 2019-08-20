//
//  SpreadsheetRowCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

extension Spreadsheet {
	typealias RowCell = HostCell<RowCellView, RowCellState, EdgeBasedTableItemLayout>

	class RowCellView: UIView {
		var spreadsheetKey: String?
		let collectionView: UICollectionView

		fileprivate let collectionData = FunctionalCollectionData()
		fileprivate let heightConstraint: NSLayoutConstraint

		override init(frame: CGRect) {
			let layout = UICollectionViewFlowLayout()
			layout.scrollDirection = .horizontal
			layout.minimumInteritemSpacing = 0
			layout.minimumLineSpacing = 0

			collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
			collectionView.translatesAutoresizingMaskIntoConstraints = false
			collectionView.showsHorizontalScrollIndicator = false
			collectionView.backgroundColor = .clear

			heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
			heightConstraint.priority = .defaultLow
			heightConstraint.isActive = true

			collectionData.collectionView = collectionView

			super.init(frame: frame)
			setupView()
		}

		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		private func setupView() {
			addSubview(collectionView)
			NSLayoutConstraint.activate([
				collectionView.topAnchor.constraint(equalTo: topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
				collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
				])
		}
	}

	struct RowCellState: ViewState {
		let spreadsheetKey: String
		let config: RowConfig
		let columns: [Int: ColumnConfig]
		let cells: [GridCellConfig]
		let didScroll: (CGPoint) -> Void

		init(spreadsheetKey: String, config: RowConfig, columns: [Int: ColumnConfig], cells: [GridCellConfig], didScroll: @escaping (CGPoint) -> Void) {
			self.spreadsheetKey = spreadsheetKey
			self.config = config
			self.columns = columns
			self.cells = cells
			self.didScroll = didScroll
		}

		static func updateView(_ view: RowCellView, state: RowCellState?) {
			guard let state = state else {
				view.collectionData.scrollViewDidScroll = nil
				view.collectionData.renderAndDiff([])
				return
			}

			if let layout = view.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				let maxWidth = state.columns.max { left, right -> Bool in left.value.columnWidth < right.value.columnWidth }?.value.columnWidth ?? 48
				layout.itemSize = CGSize(width: maxWidth, height: state.config.rowHeight)
				view.heightConstraint.constant = state.config.rowHeight
			}

			view.spreadsheetKey = state.spreadsheetKey
			view.collectionData.scrollViewDidScroll = { scrollView in
				state.didScroll(scrollView.contentOffset)
			}

			let rows: [CellConfigType] = state.cells.enumerated().map { index, cell in
				let backgroundViewProvider = GridCellBackgroundViewProvider(
					topBorder: cell.topBorder ?? state.config.topBorder,
					bottomBorder: cell.bottomBorder ?? state.config.bottomBorder,
					leftBorder: cell.leftBorder ?? state.columns[index]?.leftBorder,
					rightBorder: cell.rightBorder ?? state.columns[index]?.rightBorder
				)

				var view = cell.view
				if var style = view.style {
					style.backgroundViewProvider = backgroundViewProvider
					view.style = style
				} else {
					view.style = CellStyle(backgroundViewProvider: backgroundViewProvider)
				}

				return view
			}

			view.collectionData.renderAndDiff([TableSection(key: "Row", rows: rows)])
		}

		static func == (lhs: RowCellState, rhs: RowCellState) -> Bool {
			guard lhs.spreadsheetKey == rhs.spreadsheetKey &&
				lhs.config == rhs.config &&
				lhs.columns == rhs.columns else {
				return false
			}

			guard lhs.cells.count == rhs.cells.count else { return false }
			for (index, cell) in lhs.cells.enumerated() {
				if cell.isEqual(rhs.cells[index]) == false {
					return false
				}
			}

			return true
		}
	}

	struct GridCellBackgroundViewProvider: BackgroundViewProvider {
		private enum BorderPosition {
			case top, bottom, right, left
		}

		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?
		let leftBorder: BorderConfig?
		let rightBorder: BorderConfig?

		func backgroundView() -> UIView? {
			let view = UIView()

			if let topBorder = topBorder {
				apply(border: topBorder, at: .top, toView: view)
			}

			if let bottomBorder = bottomBorder {
				apply(border: bottomBorder, at: .bottom, toView: view)
			}

			if let leftBorder = leftBorder {
				apply(border: leftBorder, at: .left, toView: view)
			}

			if let rightBorder = rightBorder {
				apply(border: rightBorder, at: .right, toView: view)
			}

			return view
		}

		private func apply(border config: BorderConfig, at position: BorderPosition, toView: UIView) {
			let border = UIView()
			border.backgroundColor = config.color
			border.translatesAutoresizingMaskIntoConstraints = false
			toView.addSubview(border)

			switch position {
			case .top, .bottom:
				border.heightAnchor.constraint(equalToConstant: config.thickness).isActive = true
				border.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
				border.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
			case .left, .right:
				border.widthAnchor.constraint(equalToConstant: config.thickness).isActive = true
				border.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
				border.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
			}

			switch position {
			case .top:
				border.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
			case .bottom:
				border.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
			case .left:
				border.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
			case .right:
				border.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
			}

		}

		func isEqualTo(_ other: BackgroundViewProvider?) -> Bool {
			guard let other = other as? GridCellBackgroundViewProvider else { return false }
			return topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}
}
