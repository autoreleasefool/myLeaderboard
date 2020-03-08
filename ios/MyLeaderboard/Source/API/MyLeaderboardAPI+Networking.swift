//
//  MyLeaderboardAPI+Networking.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-03.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

typealias GraphAPIQuery = GraphApiQuery

enum GraphAPIError: LocalizedError {
	case encodingError(GraphAPIQuery, Error)
	case networkError(GraphAPIQuery, Error)
	case invalidData(GraphAPIQuery)

	var localizedDescription: String {
		switch self {
		case .encodingError(let query, let error):
			return "Error encoding \(query): \(error)"
		case .networkError(let query, let error):
			return "Error performing network request for \(query): \(error)"
		case .invalidData(let query):
			return "Invalid data response for \(query)"
		}
	}
}

extension MyLeaderboardAPI {
	static let baseURL = URL(string: "https://myleaderboard.josephroque.dev")!
}

extension ResponseAssociable where Self: GraphAPIQuery {
	typealias ResponseResult = Result<Response, GraphAPIError>
	typealias QueryResultHandler = (ResponseResult) -> Void

	func perform(callback: @escaping QueryResultHandler) {
		func finish(_ result: ResponseResult) {
			DispatchQueue.main.async {
				callback(result)
			}
		}

		var request = URLRequest(url: MyLeaderboardAPI.baseURL.appendingPathComponent("graphql"))
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")

		let payload: [String: Any] = [
			"query": self.queryString,
			"variables": self.variables,
		]

		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: payload)
		} catch {
			return finish(.failure(.encodingError(self, error)))
		}

		URLSession.shared.dataTask(with: request) { data, _, error in
			guard error == nil else {
				return finish(.failure(.networkError(self, error!)))
			}

			guard let data = data else {
				return finish(.failure(.invalidData(self)))
			}

			do {
				if let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
					let responseDataData = responseData["data"] as? [String: Any] {
					return finish(.success(try .init(from: responseDataData)))
				} else {
					return finish(.failure(.invalidData(self)))
				}
			} catch {
				return finish(.failure(.invalidData(self)))
			}
		}.resume()
	}
}
