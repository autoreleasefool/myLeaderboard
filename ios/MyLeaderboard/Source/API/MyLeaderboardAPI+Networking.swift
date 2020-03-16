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
	case invalidResponse
	case invalidHTTPResponse(Int)
	case invalidData(GraphAPIQuery, Error?)
	case missingData

	var shortDescription: String {
		switch self {
		case .encodingError:
			return "Encoding error"
		case .networkError:
			return "Network error"
		case .invalidHTTPResponse(let code):
			if (500..<600).contains(code) {
				return "Server error (\(code))"
			} else {
				return "Unexpected HTTP error: \(code)"
			}
		case .invalidData, .invalidResponse:
			return "Could not parse response"
		case .missingData:
			return "Could not find data"
		}
	}

	var localizedDescription: String {
		switch self {
		case .encodingError(let query, let error):
			return "Error encoding \(query): \(error)"
		case .networkError(let query, let error):
			return "Error performing network request for \(query): \(error)"
		case .invalidData(let query, let error):
			if let error = error {
				return "Invalid data response for \(query): \(error)"
			} else {
				return "Invalid data response for \(query)"
			}
		case .invalidHTTPResponse(let code):
			if (500..<600).contains(code) {
				return "Server error (\(code))"
			} else {
				return "Unexpected HTTP error: \(code)"
			}
		case .missingData:
			return "Could not find data"
		case .invalidResponse:
			return "Could not parse response"
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

		URLSession.shared.dataTask(with: request) { data, response, error in
			guard error == nil else {
				return finish(.failure(.networkError(self, error!)))
			}

			guard let data = data else {
				return finish(.failure(.invalidData(self, nil)))
			}

			guard let response = response as? HTTPURLResponse else {
				return finish(.failure(.invalidResponse))
			}

			guard (200..<400).contains(response.statusCode) else {
				return finish(.failure(.invalidHTTPResponse(response.statusCode)))
			}

			do {
				if let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
					let responseDataData = responseData["data"] as? [String: Any] {
					return finish(.success(try .init(from: responseDataData)))
				} else {
					return finish(.failure(.invalidData(self, nil)))
				}
			} catch {
				return finish(.failure(.invalidData(self, error)))
			}
		}.resume()
	}
}
