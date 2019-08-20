//
//  ImageState.swift
//  Shopify
//
//  Created by Raul Riera on 2017-10-13.
//  Copyright © 2017 Shopify. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias ImageCell = HostCell<ImageView, ImageState, LayoutMarginsTableItemLayout>

class ImageView: UIView {
	fileprivate let imageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(imageView)

		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
			imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			])
	}
}

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

	static func updateView(_ view: ImageView, state: ImageState?) {
		guard let state = state else {
			view.imageView.image = nil
			view.imageView.layer.cornerRadius = 0
			view.imageView.clipsToBounds = false
			return
		}

		let constraints = view.constraints.filter { $0.identifier == ImageState.widthAnchorIdentifier || $0.identifier == ImageState.heightAnchorIdentifier }
		constraints.forEach { $0.isActive = false }

		view.imageView.contentMode = .scaleAspectFit
		view.imageView.tintColor = state.tintColor

		if let width = state.width {
			let widthConstraint = view.imageView.widthAnchor.constraint(equalToConstant: width)
			widthConstraint.isActive = true
			widthConstraint.identifier = ImageState.widthAnchorIdentifier
		}

		if let height = state.height {
			let heightConstraint = view.imageView.heightAnchor.constraint(equalToConstant: height)
			heightConstraint.isActive = true
			heightConstraint.identifier = ImageState.heightAnchorIdentifier
		}

		if let width = state.width, state.height == state.width && state.rounded {
			view.imageView.layer.cornerRadius = width / 2
			view.imageView.clipsToBounds = true
		} else {
			view.imageView.layer.cornerRadius = 0
			view.imageView.clipsToBounds = false
		}

		if let url = state.url {
			view.imageView.image = ImageLoader.shared.fetch(url: url) { result in
				if case .success(let url, let image) = result, url == state.url {
					view.imageView.image = image
				}
			}
		} else {
			view.imageView.image = state.image
		}
	}

	public static func == (lhs: ImageState, rhs: ImageState) -> Bool {
		return lhs.image == rhs.image &&
			lhs.url == rhs.url &&
			lhs.tintColor == rhs.tintColor &&
			lhs.width == rhs.width &&
			lhs.height == rhs.height &&
			lhs.rounded == rhs.rounded
	}
}
