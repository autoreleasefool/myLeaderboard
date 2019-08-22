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

		private let topBorder = UIView()
		private let topBorderHeightConstraint: NSLayoutConstraint
		private let bottomBorder = UIView()
		private let bottomBorderHeightConstraint: NSLayoutConstraint
		private let leftBorder = UIView()
		private let leftBorderWidthConstraint: NSLayoutConstraint
		private let rightBorder = UIView()
		private let rightBorderWidthConstraint: NSLayoutConstraint

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

			topBorderHeightConstraint = topBorder.heightAnchor.constraint(equalToConstant: 0)
			topBorderHeightConstraint.isActive = true
			bottomBorderHeightConstraint = bottomBorder.heightAnchor.constraint(equalToConstant: 0)
			bottomBorderHeightConstraint.isActive = true
			leftBorderWidthConstraint = leftBorder.widthAnchor.constraint(equalToConstant: 0)
			leftBorderWidthConstraint.isActive = true
			rightBorderWidthConstraint = rightBorder.widthAnchor.constraint(equalToConstant: 0)
			rightBorderWidthConstraint.isActive = true

			collectionData.collectionView = collectionView

			super.init(frame: frame)
			setupView()
		}

		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		private func setupView() {
			topBorder.translatesAutoresizingMaskIntoConstraints = false
			addSubview(topBorder)

			bottomBorder.translatesAutoresizingMaskIntoConstraints = false
			addSubview(bottomBorder)

			leftBorder.translatesAutoresizingMaskIntoConstraints = false
			addSubview(leftBorder)

			rightBorder.translatesAutoresizingMaskIntoConstraints = false
			addSubview(rightBorder)

			addSubview(collectionView)
			NSLayoutConstraint.activate([
				topBorder.topAnchor.constraint(equalTo: topAnchor),
				topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
				topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),

				bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
				bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
				bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),

				leftBorder.topAnchor.constraint(equalTo: topAnchor),
				leftBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
				leftBorder.leadingAnchor.constraint(equalTo: leadingAnchor),

				rightBorder.topAnchor.constraint(equalTo: topAnchor),
				rightBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
				rightBorder.trailingAnchor.constraint(equalTo: trailingAnchor),

				collectionView.topAnchor.constraint(equalTo: topBorder.bottomAnchor),
				collectionView.bottomAnchor.constraint(equalTo: bottomBorder.topAnchor),
				collectionView.leadingAnchor.constraint(equalTo: leftBorder.trailingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: rightBorder.leadingAnchor),
				])
		}

		fileprivate func applyBorder(_ border: RowCellBorderConfig) {
			if let topBorderConfig = border.topBorder {
				topBorderHeightConstraint.constant = topBorderConfig.thickness
				topBorder.backgroundColor = topBorderConfig.color
				topBorder.isHidden = false
			} else {
				topBorderHeightConstraint.constant = 0
				topBorder.isHidden = true
			}

			if let bottomBorderConfig = border.bottomBorder {
				bottomBorderHeightConstraint.constant = bottomBorderConfig.thickness
				bottomBorder.backgroundColor = bottomBorderConfig.color
				bottomBorder.isHidden = false
			} else {
				bottomBorderHeightConstraint.constant = 0
				bottomBorder.isHidden = true
			}

			if let leftBorderConfig = border.leftBorder {
				leftBorderWidthConstraint.constant = leftBorderConfig.thickness
				leftBorder.backgroundColor = leftBorderConfig.color
				leftBorder.isHidden = false
			} else {
				leftBorderWidthConstraint.constant = 0
				leftBorder.isHidden = true
			}

			if let rightBorderConfig = border.rightBorder {
				rightBorderWidthConstraint.constant = rightBorderConfig.thickness
				rightBorder.backgroundColor = rightBorderConfig.color
				rightBorder.isHidden = false
			} else {
				rightBorderWidthConstraint.constant = 0
				rightBorder.isHidden = true
			}
		}
	}

	struct RowCellState: ViewState {
		let spreadsheetKey: String
		let border: RowCellBorderConfig
		let config: RowConfig
		let columns: [Int: ColumnConfig]
		let cells: [GridCellConfig]
		let didScroll: (CGPoint) -> Void

		init(spreadsheetKey: String, config: RowConfig, columns: [Int: ColumnConfig], cells: [GridCellConfig], border: RowCellBorderConfig, didScroll: @escaping (CGPoint) -> Void) {
			self.spreadsheetKey = spreadsheetKey
			self.config = config
			self.columns = columns
			self.cells = cells
			self.border = border
			self.didScroll = didScroll
		}

		static func updateView(_ view: RowCellView, state: RowCellState?) {
			guard let state = state else {
				view.collectionData.scrollViewDidScroll = nil
				return
			}

			if let layout = view.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				let maxWidth = state.columns.max { left, right -> Bool in left.value.columnWidth < right.value.columnWidth }?.value.columnWidth ?? 48
				layout.itemSize = CGSize(width: maxWidth, height: state.config.rowHeight)
				view.heightConstraint.constant = state.config.rowHeight
			}

			view.applyBorder(state.border)

			view.spreadsheetKey = state.spreadsheetKey
			view.collectionData.scrollViewDidScroll = { scrollView in
				state.didScroll(scrollView.contentOffset)
			}

			let rows: [CellConfigType] = state.cells.enumerated().map { index, cell in
				let backgroundViewProvider = GridCellBackgroundViewProvider(
					backgroundColor: cell.backgroundColor,
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
				lhs.config.isEqual(to: rhs.config) &&
				lhs.columns == rhs.columns else {
				return false
			}

			guard lhs.cells.count == rhs.cells.count else { return false }
			for (index, cell) in lhs.cells.enumerated() {
				if cell.isEqual(to: rhs.cells[index]) == false {
					return false
				}
			}

			return true
		}
	}

	struct RowCellBorderConfig {
		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?
		let leftBorder: BorderConfig?
		let rightBorder: BorderConfig?
	}
}
