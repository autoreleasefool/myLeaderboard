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
	let opacity: CGFloat

	init(
		image: UIImage?,
		tintColor: UIColor? = nil,
		width: CGFloat? = nil,
		height: CGFloat? = nil,
		rounded: Bool = false,
		opacity: CGFloat = 1.0
	) {
		self.url = nil
		self.image = image
		self.tintColor = tintColor
		self.width = width
		self.height = height
		self.rounded = rounded
		self.opacity = opacity
	}

	init(
		url: URL?,
		tintColor: UIColor? = nil,
		width: CGFloat? = nil,
		height: CGFloat? = nil,
		rounded: Bool = false,
		opacity: CGFloat = 1.0
	) {
		self.image = nil
		self.url = url
		self.tintColor = tintColor
		self.width = width
		self.height = height
		self.rounded = rounded
		self.opacity = opacity
	}

	static func updateView(_ view: UIImageView, state: ImageState?) {
		guard let state = state else {
			view.image = nil
			view.layer.cornerRadius = 0
			view.clipsToBounds = false
			view.isOpaque = true
			view.alpha = 1.0
			return
		}

		let constraints = view.constraints.filter {
			$0.identifier == ImageState.widthAnchorIdentifier || $0.identifier == ImageState.heightAnchorIdentifier
		}
		constraints.forEach { $0.isActive = false }

		view.contentMode = .scaleAspectFit
		view.tintColor = state.tintColor

		if state.opacity < 1.0 {
			view.alpha = state.opacity
			view.isOpaque = false
		} else {
			view.alpha = 1.0
			view.isOpaque = true
		}

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
			view.layer.cornerRadius = width / 2
			view.clipsToBounds = true
		} else {
			view.layer.cornerRadius = 0
			view.clipsToBounds = false
		}

		if let url = state.url {
			view.image = ImageLoader.shared.fetch(url: url) { result in
				if case .success((let url, let image)) = result, url == state.url {
					view.image = image
				}
			}
		} else {
			view.image = state.image
		}
	}

	static func updateImageView(_ view: ImageView, state: ImageState?) {
		ImageState.updateView(view.imageView, state: state)
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
