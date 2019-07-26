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
	private static var baseURL = URL(string: "")!

	// MARK: - Players

	func players(withAvatars: Bool = true, completion: @escaping (LeaderboardAPIResult<[Player]>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<[Player]>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/players/list?withAvatars=\(withAvatars)")
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	func playerRecord(playerID: ID, gameID: ID, completion: @escaping (LeaderboardAPIResult<PlayerStandings>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<PlayerStandings>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/players/record/\(playerID)/\(gameID)")
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	func createPlayer(name: String, username: String, completion: @escaping (LeaderboardAPIResult<Player>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<Player>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let body = ["name": name, "username": username]
		guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			finishRequest(.failure(.invalidData))
			return
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/players/new")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = bodyData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	// MARK: - Games

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

		let body = ["name": name]
		guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			finishRequest(.failure(.invalidData))
			return
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/games/new")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = bodyData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	// MARK: - Play

	func record(gameID: ID, playerIDs: [ID], winnerIDs: [ID], scores: [ID]?, completion: @escaping (LeaderboardAPIResult<GamePlay>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<GamePlay>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		var body: [String: Any] = [
			"game": gameID,
			"players": playerIDs,
			"winners": winnerIDs,
		]

		if let scores = scores {
			body["scores"] = scores
		}

		guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
			finishRequest(.failure(.invalidData))
			return
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/plays/record")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = bodyData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.handleResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	// MARK: - Misc

	func refresh(completion: @escaping (LeaderboardAPIResult<Bool>) -> Void) {
		func finishRequest(_ result: LeaderboardAPIResult<Bool>) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let url = LeaderboardAPI.baseURL.appendingPathComponent("/misc/refresh")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.handleVoidResponse(data: data, response: response, error: error, completion: finishRequest)
		}.resume()
	}

	// MARK: - Common

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

	private func handleVoidResponse<Result: Codable>(data: Data?, response: URLResponse?, error: Error?, completion: (LeaderboardAPIResult<Bool>) -> Void) {
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

		completion(.success(true))
	}
}
