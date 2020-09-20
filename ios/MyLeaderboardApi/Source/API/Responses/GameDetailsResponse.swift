// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct GameDetailsResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Find a single game.
		public var game: Game?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(game: Game?) {
			self.game = game
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Game: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player vs player records, and score statistics for the game.
			public var standings: Standings
			/// Most recent plays of the game.
			public var recentPlays: [RecentPlays]
			/// Unique ID.
			public var id: GraphID {
				get {
					return asGameDetailsFragmentFragment.id
				}
				set {
					asGameDetailsFragmentFragment.id = newValue
				}
			}
			/// Name of the game.
			public var name: String {
				get {
					return asGameDetailsFragmentFragment.name
				}
				set {
					asGameDetailsFragmentFragment.name = newValue
				}
			}
			/// Indicates if the game includes score keeping.
			public var hasScores: Bool {
				get {
					return asGameDetailsFragmentFragment.hasScores
				}
				set {
					asGameDetailsFragmentFragment.hasScores = newValue
				}
			}
			/// Image for the game.
			public var image: String? {
				get {
					return asGameDetailsFragmentFragment.image
				}
				set {
					asGameDetailsFragmentFragment.image = newValue
				}
			}
			public var asGameDetailsFragmentFragment: MyLeaderboardApi.GameDetailsFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case standings
					case recentPlays
					case asGameDetailsFragmentFragment = "fragment:asGameDetailsFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					self.standings = try container.decode(Standings.self, forKey: .standings)
					self.recentPlays = try container.decode([RecentPlays].self, forKey: .recentPlays)
					do {
						self.asGameDetailsFragmentFragment = try MyLeaderboardApi.GameDetailsFragment(from: decoder)
					} catch let originalError {
						do {
							self.asGameDetailsFragmentFragment = try container.decode(MyLeaderboardApi.GameDetailsFragment.self, forKey: .asGameDetailsFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(standings: Standings, recentPlays: [RecentPlays], gameDetailsFragmentFragment: MyLeaderboardApi.GameDetailsFragment) {
				self.standings = standings
				self.recentPlays = recentPlays
				self.asGameDetailsFragmentFragment = gameDetailsFragmentFragment
				self.__typename = "Game"
		}
			// MARK: - Nested Types
				public struct Standings: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// General score stats for the game.
				public var scoreStats: MyLeaderboardApi.GameDetailsStandingsFragment.ScoreStats? {
					get {
						return asGameDetailsStandingsFragmentFragment.scoreStats
					}
					set {
						asGameDetailsStandingsFragmentFragment.scoreStats = newValue
					}
				}
				/// Player vs player records.
				public var records: [MyLeaderboardApi.GameDetailsStandingsFragment.Records] {
					get {
						return asGameDetailsStandingsFragmentFragment.records
					}
					set {
						asGameDetailsStandingsFragmentFragment.records = newValue
					}
				}
				public var asGameDetailsStandingsFragmentFragment: MyLeaderboardApi.GameDetailsStandingsFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asGameDetailsStandingsFragmentFragment = "fragment:asGameDetailsStandingsFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asGameDetailsStandingsFragmentFragment = try MyLeaderboardApi.GameDetailsStandingsFragment(from: decoder)
						} catch let originalError {
							do {
								self.asGameDetailsStandingsFragmentFragment = try container.decode(MyLeaderboardApi.GameDetailsStandingsFragment.self, forKey: .asGameDetailsStandingsFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(gameDetailsStandingsFragmentFragment: MyLeaderboardApi.GameDetailsStandingsFragment) {
					self.asGameDetailsStandingsFragmentFragment = gameDetailsStandingsFragmentFragment
					self.__typename = "GameStandings"
			}
		}
				public struct RecentPlays: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID {
					get {
						return asRecentPlayFragmentFragment.id
					}
					set {
						asRecentPlayFragmentFragment.id = newValue
					}
				}
				/// Date and time the play was recorded.
				public var playedOn: Date {
					get {
						return asRecentPlayFragmentFragment.playedOn
					}
					set {
						asRecentPlayFragmentFragment.playedOn = newValue
					}
				}
				/// Scores for the game. Order is in respect to `players`.
				public var scores: [Int]? {
					get {
						return asRecentPlayFragmentFragment.scores
					}
					set {
						asRecentPlayFragmentFragment.scores = newValue
					}
				}
				/// Game that was played.
				public var game: MyLeaderboardApi.RecentPlayFragment.Game {
					get {
						return asRecentPlayFragmentFragment.game
					}
					set {
						asRecentPlayFragmentFragment.game = newValue
					}
				}
				/// Players that played in the game.
				public var players: [MyLeaderboardApi.RecentPlayFragment.Players] {
					get {
						return asRecentPlayFragmentFragment.players
					}
					set {
						asRecentPlayFragmentFragment.players = newValue
					}
				}
				/// Winners of the game.
				public var winners: [MyLeaderboardApi.RecentPlayFragment.Winners] {
					get {
						return asRecentPlayFragmentFragment.winners
					}
					set {
						asRecentPlayFragmentFragment.winners = newValue
					}
				}
				public var asRecentPlayFragmentFragment: MyLeaderboardApi.RecentPlayFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecentPlayFragmentFragment = "fragment:asRecentPlayFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecentPlayFragmentFragment = try MyLeaderboardApi.RecentPlayFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecentPlayFragmentFragment = try container.decode(MyLeaderboardApi.RecentPlayFragment.self, forKey: .asRecentPlayFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recentPlayFragmentFragment: MyLeaderboardApi.RecentPlayFragment) {
					self.asRecentPlayFragmentFragment = recentPlayFragmentFragment
					self.__typename = "Play"
			}
		}
	}
}
}
