//
//  Avatar.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-01-11.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit

enum Avatar: Equatable {
	case url(String)
	case image(UIImage)

	func applyImage(to imageView: UIImageView) {
		switch self {
		case .image(let image):
			imageView.image = image
		case .url(let urlString):
			imageView.image = ImageLoader.shared.fetch(string: urlString) { [weak imageView] result in
				if case .success(let url, let image) = result, url.absoluteString == urlString {
					imageView?.image = image
				}
			}
		}
	}
}

extension Optional where Wrapped == Avatar {
	func applyImage(to imageView: UIImageView) {
		switch self {
		case .some(let avatar):
			avatar.applyImage(to: imageView)
		case .none:
			imageView.image = nil
		}
	}
}
