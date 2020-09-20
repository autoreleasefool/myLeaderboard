// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
class CustomScalarResolver: BaseCustomScalarResolver {
		public let decoderForDateTime: (String, [CodingKey]) throws -> Date
		public let encoderForDateTime: (Date, [CodingKey]) throws -> String

	init(decoderForDateTime: @escaping (String) throws -> Date, encoderForDateTime: @escaping (Date) throws -> String) {
			self.decoderForDateTime = { rawValue, codingPath in
				try MyLeaderboardApi.CustomScalarResolver.performDecode(resolver: decoderForDateTime, rawValue: rawValue, codingPath: codingPath)
			}
			self.encoderForDateTime = { value, codingPath in
				try MyLeaderboardApi.CustomScalarResolver.performEncode(resolver: encoderForDateTime, value: value, codingPath: codingPath)
			}
		super.init()
	}

	private static func performDecode<T, R>(resolver: (R) throws -> T, rawValue: R, codingPath: [CodingKey]) throws -> T {
		do {
			return try resolver(rawValue)
		} catch is ResolverError {
			throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected to find value for \(T.self), found nil instead."))
		}
	}

	private static func performEncode<T, R>(resolver: (T) throws -> R, value: T, codingPath: [CodingKey]) throws -> R {
		do {
			return try resolver(value)
		} catch is ResolverError {
			throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "Unable to encode custom value \(value) to type \(T.self)"))
		}
	}
}
}
