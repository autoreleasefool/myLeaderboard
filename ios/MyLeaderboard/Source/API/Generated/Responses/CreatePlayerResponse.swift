// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct CreatePlayerResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Create a new player.
		public var createPlayer: CreatePlayer?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(createPlayer: CreatePlayer?) {
			self.createPlayer = createPlayer
			self.__typename = "Mutation"
	}

		// MARK: - Nested Types
			public struct CreatePlayer: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asNewPlayerFragmentFragment.id
				}
				set {
					asNewPlayerFragmentFragment.id = newValue
				}
			}
			/// Display name of the player.
			public var displayName: String {
				get {
					return asNewPlayerFragmentFragment.displayName
				}
				set {
					asNewPlayerFragmentFragment.displayName = newValue
				}
			}
			public var asNewPlayerFragmentFragment: MyLeaderboardAPI.NewPlayerFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asNewPlayerFragmentFragment = "fragment:asNewPlayerFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asNewPlayerFragmentFragment = try MyLeaderboardAPI.NewPlayerFragment(from: decoder)
					} catch let originalError {
						do {
							self.asNewPlayerFragmentFragment = try container.decode(MyLeaderboardAPI.NewPlayerFragment.self, forKey: .asNewPlayerFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(newPlayerFragmentFragment: MyLeaderboardAPI.NewPlayerFragment) {
				self.asNewPlayerFragmentFragment = newPlayerFragmentFragment
				self.__typename = "Player"
		}
	}
}
}
