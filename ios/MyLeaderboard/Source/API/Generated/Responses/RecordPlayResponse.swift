// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct RecordPlayResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Record a play between at least two players.
		public var recordPlay: RecordPlay?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

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
			public var asNewPlayFragmentFragment: MyLeaderboardAPI.NewPlayFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asNewPlayFragmentFragment = "fragment:asNewPlayFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asNewPlayFragmentFragment = try MyLeaderboardAPI.NewPlayFragment(from: decoder)
					} catch let originalError {
						do {
							self.asNewPlayFragmentFragment = try container.decode(MyLeaderboardAPI.NewPlayFragment.self, forKey: .asNewPlayFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(newPlayFragmentFragment: MyLeaderboardAPI.NewPlayFragment) {
				self.asNewPlayFragmentFragment = newPlayFragmentFragment
				self.__typename = "Play"
		}
	}
}
}
