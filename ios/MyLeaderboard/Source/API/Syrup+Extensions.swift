//
//  Syrup+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2020-03-02.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import Foundation

extension GraphID: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.rawValue)
	}
}

extension GraphID: Comparable {
	public static func < (lhs: GraphID, rhs: GraphID) -> Bool {
		if let lhsInt = Int(lhs.rawValue), let rhsInt = Int(rhs.rawValue) {
			return lhsInt < rhsInt
		}
		return lhs.rawValue < rhs.rawValue
	}
}

public extension GraphApiQuery {
	static var errorLogger: GraphApiLogger? {
		return Logger()
	}
}

public extension GraphApiResponse {
	static var errorLogger: GraphApiLogger? {
		return Logger()
	}
}

public extension MyLeaderboardAPI {
	static var customDecoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(GraphQL.iso8601DateParser)
		return decoder
	}

	static var customEncoder: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(GraphQL.iso8601DateParser)
		return encoder
	}

	static var customScalarResolver: MyLeaderboardAPI.CustomScalarResolver {
		let dateResolver = DateResolver()
		return MyLeaderboardAPI.CustomScalarResolver(decoderForDateTime: dateResolver.decoder, encoderForDateTime: dateResolver.encoder)
	}
}

public struct DateResolver {
	public init() {}

	public var decoder: (String?) throws -> Date = { stringValue in
		guard let stringValue = stringValue,
			let value = GraphQL.iso8601DateParser.date(from: stringValue) else {
			throw BaseCustomScalarResolver.ResolverError(type: Date.self)
		}
		return value
	}

	public var encoder: (Date) throws -> String = { date in
		return GraphQL.iso8601DateParser.string(from: date)
	}
}

private struct Logger: GraphApiLogger {
	func logError(_ message: StaticString, fileName file: StaticString, functionName function: StaticString, lineNumber line: Int, _ args: CVarArg...) {
		let formattedMessage = String(format: message.description, args)
		print("ERROR: \(file):\(function):\(line) - \(formattedMessage)")
	}
}
