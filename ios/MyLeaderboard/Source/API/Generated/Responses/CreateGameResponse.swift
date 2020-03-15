// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct CreateGameResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Create a new game.
		public var createGame: CreateGame?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(createGame: CreateGame?) {
			self.createGame = createGame
			self.__typename = "Mutation"
	}

		// MARK: - Nested Types
			public struct CreateGame: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asNewGameFragmentFragment.id
				}
				set {
					asNewGameFragmentFragment.id = newValue
				}
			}
			/// Name of the game.
			public var name: String {
				get {
					return asNewGameFragmentFragment.name
				}
				set {
					asNewGameFragmentFragment.name = newValue
				}
			}
			public var asNewGameFragmentFragment: MyLeaderboardAPI.NewGameFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asNewGameFragmentFragment = "fragment:asNewGameFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asNewGameFragmentFragment = try MyLeaderboardAPI.NewGameFragment(from: decoder)
					} catch let originalError {
						do {
							self.asNewGameFragmentFragment = try container.decode(MyLeaderboardAPI.NewGameFragment.self, forKey: .asNewGameFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(newGameFragmentFragment: MyLeaderboardAPI.NewGameFragment) {
				self.asNewGameFragmentFragment = newGameFragmentFragment
				self.__typename = "Game"
		}
	}
}
}
