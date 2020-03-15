//
//  SpreadsheetGridCellConfig.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-18.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol GridCellConfig {
	var key: String { get }

	var backgroundColor: UIColor? { get }
	var topBorder: Spreadsheet.BorderConfig? { get }
	var bottomBorder: Spreadsheet.BorderConfig? { get }
	var leftBorder: Spreadsheet.BorderConfig? { get }
	var rightBorder: Spreadsheet.BorderConfig? { get }

	var view: CellConfigType { get }

	func isEqual(to other: GridCellConfig?) -> Bool
}

extension Spreadsheet {
	struct TextGridCellConfig: GridCellConfig {
		private typealias Cell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

		let key: String
		let style: CellStyle?
		let actions: CellActions
		let state: LabelState
		let backgroundColor: UIColor?

		let topBorder: Spreadsheet.BorderConfig?
		let bottomBorder: Spreadsheet.BorderConfig?
		let leftBorder: Spreadsheet.BorderConfig?
		let rightBorder: Spreadsheet.BorderConfig?

		init(
			key: String,
			style: CellStyle? = nil,
			actions: CellActions = CellActions(),
			state: LabelState,
			backgroundColor: UIColor? = nil,
			topBorder: Spreadsheet.BorderConfig? = nil,
			bottomBorder: Spreadsheet.BorderConfig? = nil,
			leftBorder: Spreadsheet.BorderConfig? = nil,
			rightBorder: Spreadsheet.BorderConfig? = nil
		) {
			self.key = key
			self.style = style
			self.actions = actions
			self.state = state
			self.backgroundColor = backgroundColor
			self.topBorder = topBorder
			self.bottomBorder = bottomBorder
			self.leftBorder = leftBorder
			self.rightBorder = rightBorder
		}

		var view: CellConfigType {
			return Cell(
				key: key,
				style: style,
				actions: actions,
				state: state,
				cellUpdater: LabelState.updateView
			)
		}

		func isEqual(to other: GridCellConfig?) -> Bool {
			guard let other = other as? TextGridCellConfig else { return false }
			return key == other.key &&
				style == other.style &&
				state == other.state &&
				backgroundColor == other.backgroundColor &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}

	struct ImageGridCellConfig: GridCellConfig {
		private typealias Cell = HostCell<ImageView, ImageState, LayoutMarginsTableItemLayout>

		let key: String
		let style: CellStyle?
		let actions: CellActions
		let state: ImageState
		let backgroundColor: UIColor?

		let topBorder: Spreadsheet.BorderConfig?
		let bottomBorder: Spreadsheet.BorderConfig?
		let leftBorder: Spreadsheet.BorderConfig?
		let rightBorder: Spreadsheet.BorderConfig?

		init(
			key: String,
			style: CellStyle? = nil,
			actions: CellActions = CellActions(),
			state: ImageState,
			backgroundColor: UIColor? = nil,
			topBorder: Spreadsheet.BorderConfig? = nil,
			bottomBorder: Spreadsheet.BorderConfig? = nil,
			leftBorder: Spreadsheet.BorderConfig? = nil,
			rightBorder: Spreadsheet.BorderConfig? = nil
		) {
			self.key = key
			self.style = style
			self.actions = actions
			self.state = state
			self.backgroundColor = backgroundColor
			self.topBorder = topBorder
			self.bottomBorder = bottomBorder
			self.leftBorder = leftBorder
			self.rightBorder = rightBorder
		}

		var view: CellConfigType {
			return Cell(
				key: key,
				style: style,
				actions: actions,
				state: state,
				cellUpdater: ImageState.updateImageView
			)
		}

		func isEqual(to other: GridCellConfig?) -> Bool {
			guard let other = other as? ImageGridCellConfig else { return false }
			return key == other.key &&
				style == other.style &&
				state == other.state &&
				backgroundColor == other.backgroundColor &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}

	struct GridCellBackgroundViewProvider: BackgroundViewProvider {
		private enum BorderPosition {
			case top, bottom, right, left
		}

		let backgroundColor: UIColor?
		let topBorder: BorderConfig?
		let bottomBorder: BorderConfig?
		let leftBorder: BorderConfig?
		let rightBorder: BorderConfig?

		func backgroundView() -> UIView? {
			let view = UIView()

			if let backgroundColor = backgroundColor {
				view.backgroundColor = backgroundColor
			}

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
			return backgroundColor == other.backgroundColor &&
				topBorder == other.topBorder &&
				bottomBorder == other.bottomBorder &&
				leftBorder == other.leftBorder &&
				rightBorder == other.rightBorder
		}
	}
}
