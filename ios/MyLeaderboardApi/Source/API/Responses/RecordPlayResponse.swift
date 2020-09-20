// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct RecordPlayResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Record a play between at least two players.
		public var recordPlay: RecordPlay?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(recordPlay: RecordPlay?) {
			self.recordPlay = recordPlay
			self.__typename = "Mutation"
	}

		// MARK: - Nested Types
			public struct RecordPlay: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asNewPlayFragmentFragment.id
				}
				set {
					asNewPlayFragmentFragment.id = newValue
				}
			}
			public var asNewPlayFragmentFragment: MyLeaderboardApi.NewPlayFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asNewPlayFragmentFragment = "fragment:asNewPlayFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asNewPlayFragmentFragment = try MyLeaderboardApi.NewPlayFragment(from: decoder)
					} catch let originalError {
						do {
							self.asNewPlayFragmentFragment = try container.decode(MyLeaderboardApi.NewPlayFragment.self, forKey: .asNewPlayFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(newPlayFragmentFragment: MyLeaderboardApi.NewPlayFragment) {
				self.asNewPlayFragmentFragment = newPlayFragmentFragment
				self.__typename = "Play"
		}
	}
}
}
