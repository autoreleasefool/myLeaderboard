//
//  MyLeaderboardAPI.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum LeaderboardAPIError: LocalizedError {
	case networkingError(Error)
	case invalidResponse
	case invalidHTTPResponse(Int)
	case invalidData
}

typealias LeaderboardAPIResult<Success> = Result<Success, LeaderboardAPIError>

class LeaderboardAPI {
	private static var baseURL: URL {
		return URL(string: "https://6dc46042.ngrok.io")!
	}

	func games(completion: @escaping (LeaderboardAPIResult<[Game]>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<[Game]>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/games/list")
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}
	}

	private func handleResponse<Result: Codable>(data: Data?, response: URLResponse?, error: Error?, completion: (LeaderboardAPIResult<Result>) -> Void) {
		guard error == nil else {
			completion(.failure(.networkingError(error!)))
			return
		}

		guard let response = response as? HTTPURLResponse else {
			completion(.failure(.invalidResponse))
			return
		}

		guard response.statusCode == 200 else {
			completion(.failure(.invalidHTTPResponse(response.statusCode)))
			return
		}

		let decoder = JSONDecoder()
		guard let data = data, let result = try? decoder.decode(Result.self, from: data) else {
			completion(.failure(.invalidData))
			return
		}

		completion(.success(result))
	}
}
