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
		return URL(string: "")!
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
		}.resume()
	}

	func createGame(withName name: String, completion: @escaping (LeaderboardAPIResult<Game>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<Game>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let encoder = JSONEncoder()
		let body: [String: String] = ["name": name]
		guard let bodyData = try?encoder.encode(body) else {
			finishRequest(.failure(.invalidData))
			return
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/games/new")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = bodyData
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
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

		guard (200..<400).contains(response.statusCode) else {
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
