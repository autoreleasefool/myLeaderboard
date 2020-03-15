// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct TodayViewResponse: GraphApiResponse, Equatable {
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
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(records: [Records]) {
				self.records = records
				self.__typename = "Player"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Game the record represents.
				public var game: MyLeaderboardAPI.TodayViewRecordFragment.Game {
					get {
						return asTodayViewRecordFragmentFragment.game
					}
					set {
						asTodayViewRecordFragmentFragment.game = newValue
					}
				}
				/// All time record for the player.
				public var overallRecord: MyLeaderboardAPI.TodayViewRecordFragment.OverallRecord {
					get {
						return asTodayViewRecordFragmentFragment.overallRecord
					}
					set {
						asTodayViewRecordFragmentFragment.overallRecord = newValue
					}
				}
				/// Records against other players.
				public var records: [MyLeaderboardAPI.TodayViewRecordFragment.Records] {
					get {
						return asTodayViewRecordFragmentFragment.records
					}
					set {
						asTodayViewRecordFragmentFragment.records = newValue
					}
				}
				public var asTodayViewRecordFragmentFragment: MyLeaderboardAPI.TodayViewRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asTodayViewRecordFragmentFragment = "fragment:asTodayViewRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asTodayViewRecordFragmentFragment = try MyLeaderboardAPI.TodayViewRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asTodayViewRecordFragmentFragment = try container.decode(MyLeaderboardAPI.TodayViewRecordFragment.self, forKey: .asTodayViewRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(todayViewRecordFragmentFragment: MyLeaderboardAPI.TodayViewRecordFragment) {
					self.asTodayViewRecordFragmentFragment = todayViewRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
