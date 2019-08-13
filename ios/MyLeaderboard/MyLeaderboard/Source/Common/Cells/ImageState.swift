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
	let url: URL?
	let tintColor: UIColor?
	let width: CGFloat?
	let height: CGFloat?
	let rounded: Bool

	init(image: UIImage?, tintColor: UIColor? = nil, width: CGFloat? = nil, height: CGFloat? = nil, rounded: Bool = false) {
		self.url = nil
		self.image = image
		self.tintColor = tintColor
		self.width = width
		self.height = height
		self.rounded = rounded
	}

	init(url: URL?, tintColor: UIColor? = nil, width: CGFloat? = nil, height: CGFloat? = nil, rounded: Bool = false) {
		self.image = nil
		self.url = url
		self.tintColor = tintColor
		self.width = width
		self.height = height
		self.rounded = rounded
	}

	static func updateView(_ view: UIImageView, state: ImageState?) {
		guard let state = state else {
			view.image = nil
			view.layer.cornerRadius = 0
			view.clipsToBounds = false
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

		if let width = state.width, state.height == state.width && state.rounded {
			view.clipsToBounds = true
			view.layer.cornerRadius = width / 2
		} else {
			view.clipsToBounds = false
			view.layer.cornerRadius = 0
		}

		view.contentMode = .scaleAspectFit
		view.tintColor = state.tintColor

		if let url = state.url {
			view.image = ImageLoader.shared.fetch(url: url) { result in
				if case .success(let url, let image) = result, url == state.url {
					view.image = image
				}
			}
		} else {
			view.image = state.image
		}
	}

	public static func == (lhs: ImageState, rhs: ImageState) -> Bool {
		return lhs.image == rhs.image &&
			lhs.width == rhs.width &&
			lhs.height == rhs.height
	}
}
