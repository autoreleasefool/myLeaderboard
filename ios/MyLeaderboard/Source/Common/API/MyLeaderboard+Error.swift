//
//  MyLeaderboard+Error.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-06-03.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation
import myLeaderboardApi

extension ResponseAssociable where Self: GraphApiQuery {
	typealias ResponseResult = Result<Response, MyLeaderboardAPIError>
	typealias QueryResultHandler = (ResponseResult) -> Void
}

enum MyLeaderboardAPIError: LocalizedError {
  case encodingError(Error)
  case networkingError(Error)
  case invalidResponse
  case invalidHTTPResponse(Int, message: String?)
  case invalidData
  case missingData

  var shortDescription: String {
    switch self {
    case .encodingError:
      return "Encoding error"
    case .networkingError:
      return "Network error"
    case .invalidHTTPResponse(let code, let message):
      if let message = message {
        return "\(message) (\(code))"
      }

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
    case .encodingError(let error):
      return "Encoding error: \(error)"
    case .networkingError(let error):
      return "Network error: \(error)"
    case .invalidData:
      return "Invalid data"
    case .invalidResponse:
      return "Invalid response"
    case .invalidHTTPResponse(let code, _):
      if (500..<600).contains(code) {
        return "Server error (\(code))"
      } else {
        return "Unexpected HTTP error: \(code)"
      }
    case .missingData:
      return "Could not find data"
    }
  }
}
