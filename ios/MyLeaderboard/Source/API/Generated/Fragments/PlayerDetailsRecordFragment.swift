// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerDetailsRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Game the record represents.
		public var game: Game
		/// All time score statistics for the player.
		public var scoreStats: ScoreStats?

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
				case game
				case scoreStats
				case asPlayerGameRecordFragmentFragment = "fragment:asPlayerGameRecordFragmentFragment"
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.__typename = try container.decode(String.self, forKey: .__typename)
				self.game = try container.decode(Game.self, forKey: .game)
				self.scoreStats = try container.decodeIfPresent(ScoreStats.self, forKey: .scoreStats)
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

	public init(game: Game, scoreStats: ScoreStats?, playerGameRecordFragmentFragment: MyLeaderboardAPI.PlayerGameRecordFragment) {
			self.game = game
			self.scoreStats = scoreStats
			self.asPlayerGameRecordFragmentFragment = playerGameRecordFragmentFragment
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
}
}
