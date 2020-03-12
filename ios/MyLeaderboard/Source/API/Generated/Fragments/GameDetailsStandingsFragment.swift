// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct GameDetailsStandingsFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// General score stats for the game.
		public var scoreStats: ScoreStats?
		/// Player vs player records.
		public var records: [Records]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(scoreStats: ScoreStats?, records: [Records]) {
			self.scoreStats = scoreStats
			self.records = records
			self.__typename = "GameStandings"
	}

		// MARK: - Nested Types
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
			/// Player the record represents
			public var player: Player
			/// Record of the player.
			public var record: Record
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(player: Player, record: Record) {
				self.player = player
				self.record = record
				self.__typename = "PlayerRecord"
		}
			// MARK: - Nested Types
				public struct Player: GraphApiResponse, Equatable {
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
				/// All time record for the player.
				public var overallRecord: MyLeaderboardAPI.PlayerGameRecordFragment.OverallRecord {
					get {
						return asPlayerGameRecordFragmentFragment.overallRecord
					}
					set {
						asPlayerGameRecordFragmentFragment.overallRecord = newValue
					}
				}
				/// Records against other players.
				public var records: [MyLeaderboardAPI.PlayerGameRecordFragment.Records] {
					get {
						return asPlayerGameRecordFragmentFragment.records
					}
					set {
						asPlayerGameRecordFragmentFragment.records = newValue
					}
				}
				public var asPlayerGameRecordFragmentFragment: MyLeaderboardAPI.PlayerGameRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asPlayerGameRecordFragmentFragment = "fragment:asPlayerGameRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asPlayerGameRecordFragmentFragment = try MyLeaderboardAPI.PlayerGameRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asPlayerGameRecordFragmentFragment = try container.decode(MyLeaderboardAPI.PlayerGameRecordFragment.self, forKey: .asPlayerGameRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(playerGameRecordFragmentFragment: MyLeaderboardAPI.PlayerGameRecordFragment) {
					self.asPlayerGameRecordFragmentFragment = playerGameRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
