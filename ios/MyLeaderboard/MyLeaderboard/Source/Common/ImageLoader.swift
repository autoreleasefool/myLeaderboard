//
//  ImageLoader.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

class ExpiringItem {
	let object: AnyObject
	private let expirationDate: Date

	init(object: AnyObject, expiresAfter: TimeInterval = 3600) {
		self.object = object
		self.expirationDate = Date(timeInterval: expiresAfter, since: Date())
	}

	var expired: Bool {
		return expirationDate < Date()
	}
}

enum ImageLoaderError: Error {
	case invalidURL
	case invalidData
	case networkingError(Error)
	case invalidResponse
	case invalidHTTPResponse(Int)
}

typealias ImageLoaderResult = Result<UIImage, ImageLoaderError>

class ImageLoader {
	typealias Completion = (ImageLoaderResult) -> Void

	static let shared: ImageLoader = ImageLoader()

	private let cache = NSCache<AnyObject, ExpiringItem>()
	private let queryLock = NSLock()
	private var queryCompletionQueue: [String: [Completion]] = [:]

	let queryIfCached: Bool

	init(queryIfCached: Bool = false) {
		self.queryIfCached = queryIfCached
	}

	@discardableResult
	func fetch(string: String, completion: @escaping Completion) -> UIImage? {
		func finishRequest(_ result: ImageLoaderResult) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let cachedImage = cached(string: string)
		if let cachedImage = cachedImage, !queryIfCached {
			return cachedImage
		}

		DispatchQueue.global(qos: .background).async { [unowned self] in
			guard let url = URL(string: string) else {
				finishRequest(.failure(.invalidURL))
				return
			}

			self.fetch(url: url, completion: completion)
		}

		return cachedImage
	}

	@discardableResult
	func fetch(url: URL, completion: @escaping Completion) -> UIImage? {
		func finishRequest(_ result: ImageLoaderResult) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let cachedImage = cached(url: url)
		if let cachedImage = cachedImage, !queryIfCached {
			return cachedImage
		}

		DispatchQueue.global(qos: .background).async { [unowned self] in
			self.performFetch(for: url, completion: finishRequest)
		}

		return cachedImage
	}

	func cached(string: String) -> UIImage? {
		guard let url = URL(string: string) else { return nil }
		return cached(url: url)
	}

	func cached(url: URL) -> UIImage? {
		guard let data = retrieveFromCache(url: url) else { return nil }
		return UIImage(data: data)
	}

	private func performFetch(for url: URL, completion: @escaping Completion) {
		if let data = self.retrieveFromCache(url: url) {
			self.image(for: data, completion: completion)
			return
		}

		waitForResult(for: url, completion: completion)
	}

	private func image(for data: Data, completion: @escaping Completion) {
		guard let image = UIImage(data: data) else {
			completion(.failure(.invalidData))
			return
		}

		completion(.success(image))
	}

	private func retrieveFromCache(url: URL) -> Data? {
		let key = url.absoluteString as NSString
		guard let cachedItem = cache.object(forKey: key) else {
			return nil
		}

		if cachedItem.expired {
			cache.removeObject(forKey: key)
			return nil
		}

		return cachedItem.object as? Data
	}

	private func waitForResult(for url: URL, completion: @escaping Completion) {
		defer { queryLock.unlock() }
		queryLock.lock()

		func finished(_ result: ImageLoaderResult) {
			defer { queryLock.unlock() }
			queryLock.lock()

			if let queryQueue = queryCompletionQueue[url.absoluteString] {
				queryQueue.forEach { $0(result) }
			}
			queryCompletionQueue[url.absoluteString] = nil
		}

		if var queryQueue = queryCompletionQueue[url.absoluteString] {
			queryQueue.append(completion)
			queryCompletionQueue[url.absoluteString] = queryQueue
			return
		}

		queryCompletionQueue[url.absoluteString] = [completion]
		URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
			guard error == nil else {
				finished(.failure(.networkingError(error!)))
				return
			}

			guard let response = response as? HTTPURLResponse else {
				finished(.failure(.invalidResponse))
				return
			}

			guard (200..<400).contains(response.statusCode) else {
				finished(.failure(.invalidHTTPResponse(response.statusCode)))
				return
			}

			guard let data = data else {
				finished(.failure(.invalidData))
				return
			}

			self.image(for: data, completion: finished)
		}.resume()
	}
}
