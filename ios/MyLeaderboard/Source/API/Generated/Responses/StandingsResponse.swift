// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct StandingsResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Get a list of games, ordered by ID ascending. Default page size is 25.
		public var games: [Games]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(games: [Games]) {
			self.games = games
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Games: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asStandingsGameFragmentFragment.id
				}
				set {
					asStandingsGameFragmentFragment.id = newValue
				}
			}
			/// Name of the game.
			public var name: String {
				get {
					return asStandingsGameFragmentFragment.name
				}
				set {
					asStandingsGameFragmentFragment.name = newValue
				}
			}
			/// Image for the game.
			public var image: String? {
				get {
					return asStandingsGameFragmentFragment.image
				}
				set {
					asStandingsGameFragmentFragment.image = newValue
				}
			}
			/// Player vs player records, and score statistics for the game.
			public var standings: MyLeaderboardAPI.StandingsFragment.Standings {
				get {
					return asStandingsFragmentFragment.standings
				}
				set {
					asStandingsFragmentFragment.standings = newValue
				}
			}
			public var asStandingsGameFragmentFragment: MyLeaderboardAPI.StandingsGameFragment
			public var asStandingsFragmentFragment: MyLeaderboardAPI.StandingsFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asStandingsGameFragmentFragment = "fragment:asStandingsGameFragmentFragment"
					case asStandingsFragmentFragment = "fragment:asStandingsFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asStandingsGameFragmentFragment = try MyLeaderboardAPI.StandingsGameFragment(from: decoder)
					} catch let originalError {
						do {
							self.asStandingsGameFragmentFragment = try container.decode(MyLeaderboardAPI.StandingsGameFragment.self, forKey: .asStandingsGameFragmentFragment)
						} catch {
								throw originalError
						}
					}
					do {
						self.asStandingsFragmentFragment = try MyLeaderboardAPI.StandingsFragment(from: decoder)
					} catch let originalError {
						do {
							self.asStandingsFragmentFragment = try container.decode(MyLeaderboardAPI.StandingsFragment.self, forKey: .asStandingsFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(standingsGameFragmentFragment: MyLeaderboardAPI.StandingsGameFragment, standingsFragmentFragment: MyLeaderboardAPI.StandingsFragment) {
				self.asStandingsGameFragmentFragment = standingsGameFragmentFragment
				self.asStandingsFragmentFragment = standingsFragmentFragment
				self.__typename = "Game"
		}
	}
}
}
