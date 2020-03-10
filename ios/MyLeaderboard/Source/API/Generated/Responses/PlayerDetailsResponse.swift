// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerDetailsResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
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
			public var id: GraphID
			public var displayName: String
			public var username: String
			public var avatar: String?
			public var records: [Records]
			public var recentPlays: [RecentPlays]
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(id: GraphID, displayName: String, username: String, avatar: String?, records: [Records], recentPlays: [RecentPlays]) {
				self.id = id
				self.displayName = displayName
				self.username = username
				self.avatar = avatar
				self.records = records
				self.recentPlays = recentPlays
				self.__typename = "Player"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				public var game: Game
				public var overallRecord: OverallRecord
				public var scoreStats: ScoreStats?
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
					public var id: GraphID
					public var image: String?
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
					public var wins: Int32 {
						get {
							return asRecordFragmentFragment.wins
						}
						set {
							asRecordFragmentFragment.wins = newValue
						}
					}
					public var losses: Int32 {
						get {
							return asRecordFragmentFragment.losses
						}
						set {
							asRecordFragmentFragment.losses = newValue
						}
					}
					public var ties: Int32 {
						get {
							return asRecordFragmentFragment.ties
						}
						set {
							asRecordFragmentFragment.ties = newValue
						}
					}
					public var isBest: Bool? {
						get {
							return asRecordFragmentFragment.isBest
						}
						set {
							asRecordFragmentFragment.isBest = newValue
						}
					}
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
					public var best: Int32
					public var worst: Int32
					public var average: Double
				// MARK: - Helpers
				public let __typename: String
				public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
				public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				public init(best: Int32, worst: Int32, average: Double) {
						self.best = best
						self.worst = worst
						self.average = average
						self.__typename = "ScoreStats"
				}
			}
					public struct Records: GraphApiResponse, Equatable {
				// MARK: - Response Fields
					public var opponent: Opponent
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
						public var id: GraphID
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
						public var wins: Int32 {
							get {
								return asRecordFragmentFragment.wins
							}
							set {
								asRecordFragmentFragment.wins = newValue
							}
						}
						public var losses: Int32 {
							get {
								return asRecordFragmentFragment.losses
							}
							set {
								asRecordFragmentFragment.losses = newValue
							}
						}
						public var ties: Int32 {
							get {
								return asRecordFragmentFragment.ties
							}
							set {
								asRecordFragmentFragment.ties = newValue
							}
						}
						public var isBest: Bool? {
							get {
								return asRecordFragmentFragment.isBest
							}
							set {
								asRecordFragmentFragment.isBest = newValue
							}
						}
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
				public struct RecentPlays: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				public var id: GraphID {
					get {
						return asRecentPlayFragmentFragment.id
					}
					set {
						asRecentPlayFragmentFragment.id = newValue
					}
				}
				public var playedOn: Date {
					get {
						return asRecentPlayFragmentFragment.playedOn
					}
					set {
						asRecentPlayFragmentFragment.playedOn = newValue
					}
				}
				public var scores: [Int32]? {
					get {
						return asRecentPlayFragmentFragment.scores
					}
					set {
						asRecentPlayFragmentFragment.scores = newValue
					}
				}
				public var game: MyLeaderboardAPI.RecentPlayFragment.Game {
					get {
						return asRecentPlayFragmentFragment.game
					}
					set {
						asRecentPlayFragmentFragment.game = newValue
					}
				}
				public var players: [MyLeaderboardAPI.RecentPlayFragment.Players] {
					get {
						return asRecentPlayFragmentFragment.players
					}
					set {
						asRecentPlayFragmentFragment.players = newValue
					}
				}
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
