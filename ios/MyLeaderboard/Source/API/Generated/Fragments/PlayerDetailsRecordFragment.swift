// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerDetailsRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Game the record represents.
		public var game: Game
		/// All time record for the player.
		public var overallRecord: OverallRecord
		/// All time score statistics for the player.
		public var scoreStats: ScoreStats?
		/// Records against other players.
		public var records: [Records]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(game: Game, overallRecord: OverallRecord, scoreStats: ScoreStats?, records: [Records]) {
			self.game = game
			self.overallRecord = overallRecord
			self.scoreStats = scoreStats
			self.records = records
			self.__typename = "PlayerGameRecord"
	}

		// MARK: - Nested Types
			public struct Game: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID
			/// Image for the game.
			public var image: String?
			/// Name of the game.
			public var name: String
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(id: GraphID, image: String?, name: String) {
				self.id = id
				self.image = image
				self.name = name
				self.__typename = "BasicGame"
		}
	}
			public struct OverallRecord: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Number of wins.
			public var wins: Int {
				get {
					return asRecordFragmentFragment.wins
				}
				set {
					asRecordFragmentFragment.wins = newValue
				}
			}
			/// Number of losses.
			public var losses: Int {
				get {
					return asRecordFragmentFragment.losses
				}
				set {
					asRecordFragmentFragment.losses = newValue
				}
			}
			/// Number of ties.
			public var ties: Int {
				get {
					return asRecordFragmentFragment.ties
				}
				set {
					asRecordFragmentFragment.ties = newValue
				}
			}
			/// True if this represents the best record relative to similar records (of the player or the game).
			public var isBest: Bool? {
				get {
					return asRecordFragmentFragment.isBest
				}
				set {
					asRecordFragmentFragment.isBest = newValue
				}
			}
			/// True if this represents the worst record relative to similar records (of the player or the game).
			public var isWorst: Bool? {
				get {
					return asRecordFragmentFragment.isWorst
				}
				set {
					asRecordFragmentFragment.isWorst = newValue
				}
			}
			public var asRecordFragmentFragment: MyLeaderboardAPI.RecordFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asRecordFragmentFragment = try MyLeaderboardAPI.RecordFragment(from: decoder)
					} catch let originalError {
						do {
							self.asRecordFragmentFragment = try container.decode(MyLeaderboardAPI.RecordFragment.self, forKey: .asRecordFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(recordFragmentFragment: MyLeaderboardAPI.RecordFragment) {
				self.asRecordFragmentFragment = recordFragmentFragment
				self.__typename = "Record"
		}
	}
			public struct ScoreStats: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// All time best score.
			public var best: Int
			/// All time worst score.
			public var worst: Int
			/// All time average score.
			public var average: Double
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(best: Int, worst: Int, average: Double) {
				self.best = best
				self.worst = worst
				self.average = average
				self.__typename = "ScoreStats"
		}
	}
			public struct Records: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player the record is against.
			public var opponent: Opponent
			/// Record against the opponent.
			public var record: Record
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(opponent: Opponent, record: Record) {
				self.opponent = opponent
				self.record = record
				self.__typename = "PlayerVSRecord"
		}
			// MARK: - Nested Types
				public struct Opponent: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID
				/// Avatar of the player.
				public var avatar: String?
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			public init(id: GraphID, avatar: String?) {
					self.id = id
					self.avatar = avatar
					self.__typename = "BasicPlayer"
			}
		}
				public struct Record: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Number of wins.
				public var wins: Int {
					get {
						return asRecordFragmentFragment.wins
					}
					set {
						asRecordFragmentFragment.wins = newValue
					}
				}
				/// Number of losses.
				public var losses: Int {
					get {
						return asRecordFragmentFragment.losses
					}
					set {
						asRecordFragmentFragment.losses = newValue
					}
				}
				/// Number of ties.
				public var ties: Int {
					get {
						return asRecordFragmentFragment.ties
					}
					set {
						asRecordFragmentFragment.ties = newValue
					}
				}
				/// True if this represents the best record relative to similar records (of the player or the game).
				public var isBest: Bool? {
					get {
						return asRecordFragmentFragment.isBest
					}
					set {
						asRecordFragmentFragment.isBest = newValue
					}
				}
				/// True if this represents the worst record relative to similar records (of the player or the game).
				public var isWorst: Bool? {
					get {
						return asRecordFragmentFragment.isWorst
					}
					set {
						asRecordFragmentFragment.isWorst = newValue
					}
				}
				public var asRecordFragmentFragment: MyLeaderboardAPI.RecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecordFragmentFragment = try MyLeaderboardAPI.RecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecordFragmentFragment = try container.decode(MyLeaderboardAPI.RecordFragment.self, forKey: .asRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recordFragmentFragment: MyLeaderboardAPI.RecordFragment) {
					self.asRecordFragmentFragment = recordFragmentFragment
					self.__typename = "Record"
			}
		}
	}
}
}
