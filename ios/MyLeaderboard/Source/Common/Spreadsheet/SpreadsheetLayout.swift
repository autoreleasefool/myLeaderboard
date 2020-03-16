//
//  SpreadsheetLayout.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-16.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit

class SpreadsheetLayout: UICollectionViewFlowLayout {
	private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]

	var stickyItems: Set<IndexPath> = [] {
		didSet {
			prepare()
		}
	}

	override init() {
		super.init()
		self.scrollDirection = .horizontal
		self.minimumInteritemSpacing = .zero
		self.minimumLineSpacing = .zero
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

	override func prepare() {
		super.prepare()
		prepareCache()
		updateStickyItems()
	}

	private func prepareCache() {
		guard let collectionView = collectionView else { return }
		cache.removeAll(keepingCapacity: true)

		var zIndex = 0
		var xOffset: CGFloat = 0

		let totalItems = (0..<collectionView.numberOfSections).reduce(0, { prev, section in
			return prev + collectionView.numberOfItems(inSection: section)
		})

		for section in 0..<collectionView.numberOfSections {
			for item in 0..<collectionView.numberOfItems(inSection: section) {
				let indexPath = IndexPath(item: item, section: section)
				let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

				attributes.zIndex = stickyItems.contains(indexPath) ? zIndex + totalItems : zIndex
				attributes.frame = CGRect(
					x: xOffset,
					y: 0,
					width: itemSize.width,
					height: itemSize.height
				)

				xOffset += itemSize.width + minimumInteritemSpacing
				zIndex += 1
				cache[indexPath] = attributes
			}
		}
	}

	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return cache.values.filter { rect.intersects($0.frame) }
	}

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath]
	}

	private func updateStickyItems() {
		guard let collectionView = collectionView, stickyItems.count > 0 else { return }

		Array(stickyItems).sorted().enumerated().forEach { stickyIndex, indexPath in
			guard let attributes = cache[indexPath] else { return }
			let stickyPosition = collectionView.contentOffset.x +
				CGFloat(stickyIndex) * (itemSize.width + minimumInteritemSpacing)
			guard stickyPosition > attributes.frame.origin.x else { return }
			attributes.frame.origin.x = stickyPosition
		}
	}
}
