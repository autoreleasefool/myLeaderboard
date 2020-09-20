// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct GameDetailsStandingsFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// General score stats for the game.
		public var scoreStats: ScoreStats?
		/// Player vs player records.
		public var records: [Records]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

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
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
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
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
		public init(player: Player, record: Record) {
				self.player = player
				self.record = record
				self.__typename = "PlayerRecord"
		}
			// MARK: - Nested Types
				public struct Player: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID {
					get {
						return asOpponentFragmentFragment.id
					}
					set {
						asOpponentFragmentFragment.id = newValue
					}
				}
				/// Avatar of the player.
				public var avatar: String? {
					get {
						return asOpponentFragmentFragment.avatar
					}
					set {
						asOpponentFragmentFragment.avatar = newValue
					}
				}
				/// Display name of the player.
				public var displayName: String {
					get {
						return asOpponentFragmentFragment.displayName
					}
					set {
						asOpponentFragmentFragment.displayName = newValue
					}
				}
				public var asOpponentFragmentFragment: MyLeaderboardApi.OpponentFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asOpponentFragmentFragment = "fragment:asOpponentFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asOpponentFragmentFragment = try MyLeaderboardApi.OpponentFragment(from: decoder)
						} catch let originalError {
							do {
								self.asOpponentFragmentFragment = try container.decode(MyLeaderboardApi.OpponentFragment.self, forKey: .asOpponentFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(opponentFragmentFragment: MyLeaderboardApi.OpponentFragment) {
					self.asOpponentFragmentFragment = opponentFragmentFragment
					self.__typename = "BasicPlayer"
			}
		}
				public struct Record: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// All time record for the player.
				public var overallRecord: MyLeaderboardApi.GameDetailsPlayerRecordFragment.OverallRecord {
					get {
						return asGameDetailsPlayerRecordFragmentFragment.overallRecord
					}
					set {
						asGameDetailsPlayerRecordFragmentFragment.overallRecord = newValue
					}
				}
				/// Records against other players.
				public var records: [MyLeaderboardApi.GameDetailsPlayerRecordFragment.Records] {
					get {
						return asGameDetailsPlayerRecordFragmentFragment.records
					}
					set {
						asGameDetailsPlayerRecordFragmentFragment.records = newValue
					}
				}
				public var asGameDetailsPlayerRecordFragmentFragment: MyLeaderboardApi.GameDetailsPlayerRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asGameDetailsPlayerRecordFragmentFragment = "fragment:asGameDetailsPlayerRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asGameDetailsPlayerRecordFragmentFragment = try MyLeaderboardApi.GameDetailsPlayerRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asGameDetailsPlayerRecordFragmentFragment = try container.decode(MyLeaderboardApi.GameDetailsPlayerRecordFragment.self, forKey: .asGameDetailsPlayerRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(gameDetailsPlayerRecordFragmentFragment: MyLeaderboardApi.GameDetailsPlayerRecordFragment) {
					self.asGameDetailsPlayerRecordFragmentFragment = gameDetailsPlayerRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
