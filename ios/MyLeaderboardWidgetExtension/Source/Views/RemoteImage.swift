//
//  RemoteImage.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import SwiftUI
import Combine

private class RemoteImageFetcher: ObservableObject {
	@Published private(set) var image: UIImage?

	private let url: URL?
	private var cancellable: AnyCancellable?

	init(url: URL?) {
		self.url = url
	}

	deinit {
		cancel()
	}

	func fetch() {
		cancellable = ImageLoader
			.shared
			.fetch(url: url)
			.receive(on: RunLoop.main)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { [weak self] result in
					guard self?.url == result.0 else { return }
					self?.image = result.1
				}
			)
	}

	func cancel() {
		cancellable?.cancel()
	}
}

struct RemoteImage: View {
	@ObservedObject private var imageFetcher: RemoteImageFetcher
	private let placeholder: UIImage

	init(url: URL?, placeholder: UIImage = UIImage()) {
		self.placeholder = placeholder
		self.imageFetcher = RemoteImageFetcher(url: url)
		self.imageFetcher.fetch()
	}

	var body: some View {
		GeometryReader { geometry in
			if self.imageFetcher.image != nil {
				Image(uiImage: self.imageFetcher.image!)
					.resizable()
					.scaledToFit()
					.frame(width: geometry.size.width, height: geometry.size.height)

			} else {
				Image(uiImage: self.placeholder)
					.resizable()
					.scaledToFit()
					.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
		.onDisappear(perform: imageFetcher.cancel)
	}
}
