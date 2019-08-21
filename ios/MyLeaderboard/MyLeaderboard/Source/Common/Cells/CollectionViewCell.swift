//
//  CollectionViewCell.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class CollectionViewCellView: UIView {
	fileprivate let collectionView: UICollectionView
	fileprivate let collectionData = FunctionalCollectionData()

	fileprivate let heightConstraint: NSLayoutConstraint

	override init(frame: CGRect) {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0

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

	fileprivate func prepareForReuse() {
		collectionData.renderAndDiff([])
	}
}

struct CollectionViewCellState: ViewState {
	let sections: [TableSection]
	let itemSize: CGSize

	init(sections: [TableSection], itemSize: CGSize) {
		self.sections = sections
		self.itemSize = itemSize
	}

	static func updateView(_ view: CollectionViewCellView, state: CollectionViewCellState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		if let layout = view.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.itemSize = state.itemSize
			view.heightConstraint.constant = state.itemSize.height
		}

		view.collectionData.renderAndDiff(state.sections)
	}
}
