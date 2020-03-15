// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerDetailsResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Find a single player.
		public var player: Player?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(player: Player?) {
			self.player = player
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Player: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Game records.
			public var records: [Records]
			/// The player's most recent plays.
			public var recentPlays: [RecentPlays]
			/// Unique ID.
			public var id: GraphID {
				get {
					return asPlayerDetailsFragmentFragment.id
				}
				set {
					asPlayerDetailsFragmentFragment.id = newValue
				}
			}
			/// Display name of the player.
			public var displayName: String {
				get {
					return asPlayerDetailsFragmentFragment.displayName
				}
				set {
					asPlayerDetailsFragmentFragment.displayName = newValue
				}
			}
			/// GitHub username of the player.
			public var username: String {
				get {
					return asPlayerDetailsFragmentFragment.username
				}
				set {
					asPlayerDetailsFragmentFragment.username = newValue
				}
			}
			/// Avatar of the player.
			public var avatar: String? {
				get {
					return asPlayerDetailsFragmentFragment.avatar
				}
				set {
					asPlayerDetailsFragmentFragment.avatar = newValue
				}
			}
			public var asPlayerDetailsFragmentFragment: MyLeaderboardAPI.PlayerDetailsFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case records
					case recentPlays
					case asPlayerDetailsFragmentFragment = "fragment:asPlayerDetailsFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					self.records = try container.decode([Records].self, forKey: .records)
					self.recentPlays = try container.decode([RecentPlays].self, forKey: .recentPlays)
					do {
						self.asPlayerDetailsFragmentFragment = try MyLeaderboardAPI.PlayerDetailsFragment(from: decoder)
					} catch let originalError {
						do {
							self.asPlayerDetailsFragmentFragment = try container.decode(MyLeaderboardAPI.PlayerDetailsFragment.self, forKey: .asPlayerDetailsFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(records: [Records], recentPlays: [RecentPlays], playerDetailsFragmentFragment: MyLeaderboardAPI.PlayerDetailsFragment) {
				self.records = records
				self.recentPlays = recentPlays
				self.asPlayerDetailsFragmentFragment = playerDetailsFragmentFragment
				self.__typename = "Player"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Game the record represents.
				public var game: MyLeaderboardAPI.PlayerDetailsRecordFragment.Game {
					get {
						return asPlayerDetailsRecordFragmentFragment.game
					}
					set {
						asPlayerDetailsRecordFragmentFragment.game = newValue
					}
				}
				/// All time score statistics for the player.
				public var scoreStats: MyLeaderboardAPI.PlayerDetailsRecordFragment.ScoreStats? {
					get {
						return asPlayerDetailsRecordFragmentFragment.scoreStats
					}
					set {
						asPlayerDetailsRecordFragmentFragment.scoreStats = newValue
					}
				}
				public var asPlayerDetailsRecordFragmentFragment: MyLeaderboardAPI.PlayerDetailsRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asPlayerDetailsRecordFragmentFragment = "fragment:asPlayerDetailsRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asPlayerDetailsRecordFragmentFragment = try MyLeaderboardAPI.PlayerDetailsRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asPlayerDetailsRecordFragmentFragment = try container.decode(MyLeaderboardAPI.PlayerDetailsRecordFragment.self, forKey: .asPlayerDetailsRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(playerDetailsRecordFragmentFragment: MyLeaderboardAPI.PlayerDetailsRecordFragment) {
					self.asPlayerDetailsRecordFragmentFragment = playerDetailsRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
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
				public var game: MyLeaderboardAPI.RecentPlayFragment.Game {
					get {
						return asRecentPlayFragmentFragment.game
					}
					set {
						asRecentPlayFragmentFragment.game = newValue
					}
				}
				/// Players that played in the game.
				public var players: [MyLeaderboardAPI.RecentPlayFragment.Players] {
					get {
						return asRecentPlayFragmentFragment.players
					}
					set {
						asRecentPlayFragmentFragment.players = newValue
					}
				}
				/// Winners of the game.
				public var winners: [MyLeaderboardAPI.RecentPlayFragment.Winners] {
					get {
						return asRecentPlayFragmentFragment.winners
					}
					set {
						asRecentPlayFragmentFragment.winners = newValue
					}
				}
				public var asRecentPlayFragmentFragment: MyLeaderboardAPI.RecentPlayFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecentPlayFragmentFragment = "fragment:asRecentPlayFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecentPlayFragmentFragment = try MyLeaderboardAPI.RecentPlayFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecentPlayFragmentFragment = try container.decode(MyLeaderboardAPI.RecentPlayFragment.self, forKey: .asRecentPlayFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recentPlayFragmentFragment: MyLeaderboardAPI.RecentPlayFragment) {
					self.asRecentPlayFragmentFragment = recentPlayFragmentFragment
					self.__typename = "Play"
			}
		}
	}
}
}
