//
//  MyLeaderboard+API.swift
//  myLeaderboard
//
//  Created by Joseph Roque on 2021-05-30.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import Maple
import myLeaderboardApi

class MLApi: NSObject, ObservableObject, URLSessionTaskDelegate {
	private var session: URLSession!
	private let requestQueue: DispatchQueue

	static let shared: MLApi = MLApi()

	private let encoder: JSONEncoder = {
		var encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()

	private let decoder: JSONDecoder = {
		var decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()

	private let maple = Maple()

	init(
		configuration: URLSessionConfiguration = .default,
		queue: DispatchQueue = DispatchQueue(label: "ca.josephroque.myLeaderboard.api")
	) {
		self.requestQueue = queue
		let operationQueue = OperationQueue()
		operationQueue.underlyingQueue = requestQueue
		super.init()
		self.session = URLSession(
			configuration: configuration,
			delegate: self,
			delegateQueue: operationQueue
		)
	}

	func fetch<Q: GraphApiQuery & ResponseAssociable & GraphQuery>(
		query: Q
	) -> AnyPublisher<Maple.Result<Q.Response>, GraphError<MyLeaderboardAPIError>> {
		let networkPublisher: () -> AnyPublisher<Q.Response, MyLeaderboardAPIError> = { [weak self] in
			self?.performFetch(query: query) ?? Fail(error: .invalidData).eraseToAnyPublisher()
		}

		guard let graph = maple.graph else {
			return Fail(error: .unimplemented)
				.eraseToAnyPublisher()
		}

		return graph.query(
			queryable: query,
			networkPublisher: networkPublisher
		)
		.drop {
			switch $0 {
			case .cacheMiss: return true
			case .cacheHit, .cacheUpdate, .networkResponse: return false
			}
		}
		.eraseToAnyPublisher()
	}

	private func performFetch<Q: GraphApiQuery & ResponseAssociable>(
		query: Q
	) -> AnyPublisher<Q.Response, MyLeaderboardAPIError> {

		var request = URLRequest(
			url: MyLeaderboardApi.baseURL
				.appendingPathComponent("graphql")
		)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")

		let payload: [String: Any] = [
			"query": query.queryString,
			"variables": query.variables,
		]

		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: payload)
		} catch {
			return Fail(error: MyLeaderboardAPIError.encodingError(error))
				.eraseToAnyPublisher()
		}

		return session.dataTaskPublisher(for: request)
			.tryMap { data, response in
				guard let httpResponse = response as? HTTPURLResponse else {
					print("Invalid response")
					throw MyLeaderboardAPIError.invalidResponse
				}

				guard (200..<400).contains(httpResponse.statusCode) else {
					throw MyLeaderboardAPIError.invalidHTTPResponse(httpResponse.statusCode, message: nil)
				}

				return data
			}
			.decode(type: GraphQLUnwrappable<Q.Response>.self, decoder: decoder)
			.map { $0.data }
			.mapError(MyLeaderboardAPIError.networkingError)
			.eraseToAnyPublisher()
	}

}

struct GraphQLUnwrappable<Wrapped: Decodable>: Decodable {
	let data: Wrapped
}