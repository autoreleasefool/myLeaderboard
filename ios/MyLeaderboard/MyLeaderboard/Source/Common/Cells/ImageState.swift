//
//  ImageState.swift
//  Shopify
//
//  Created by Raul Riera on 2017-10-13.
//  Copyright © 2017 Shopify. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias ImageCell = HostCell<UIImageView, ImageState, LayoutMarginsTableItemLayout>

struct ImageState: ViewState {
	private static let widthAnchorIdentifier = "ImageState.Width"
	private static let heightAnchorIdentifier = "ImageState.Height"

	let image: UIImage?
	let width: CGFloat?
	let height: CGFloat?

	init(image: UIImage?, width: CGFloat? = nil, height: CGFloat? = nil) {
		self.image = image
		self.width = width
		self.height = height
	}

	static func updateView(_ view: UIImageView, state: ImageState?) {
		guard let state = state else {
			view.image = nil
			return
		}

		let constraints = view.constraints.filter { $0.identifier == ImageState.widthAnchorIdentifier || $0.identifier == ImageState.heightAnchorIdentifier }
		constraints.forEach { $0.isActive = false }

		if let width = state.width {
			let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
			widthConstraint.isActive = true
			widthConstraint.identifier = ImageState.widthAnchorIdentifier
		}

		if let height = state.height {
			let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
			heightConstraint.isActive = true
			heightConstraint.identifier = ImageState.heightAnchorIdentifier
		}

		view.contentMode = .scaleAspectFit
		view.image = state.image
	}

	public static func == (lhs: ImageState, rhs: ImageState) -> Bool {
		return lhs.image == rhs.image &&
			lhs.width == rhs.width &&
			lhs.height == rhs.height
	}
}
