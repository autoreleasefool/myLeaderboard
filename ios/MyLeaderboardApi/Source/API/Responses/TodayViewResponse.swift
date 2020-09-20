// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct TodayViewResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Find a single player.
		public var player: Player?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

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
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
		public init(records: [Records]) {
				self.records = records
				self.__typename = "Player"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Game the record represents.
				public var game: MyLeaderboardApi.TodayViewRecordFragment.Game {
					get {
						return asTodayViewRecordFragmentFragment.game
					}
					set {
						asTodayViewRecordFragmentFragment.game = newValue
					}
				}
				/// All time record for the player.
				public var overallRecord: MyLeaderboardApi.TodayViewRecordFragment.OverallRecord {
					get {
						return asTodayViewRecordFragmentFragment.overallRecord
					}
					set {
						asTodayViewRecordFragmentFragment.overallRecord = newValue
					}
				}
				/// Records against other players.
				public var records: [MyLeaderboardApi.TodayViewRecordFragment.Records] {
					get {
						return asTodayViewRecordFragmentFragment.records
					}
					set {
						asTodayViewRecordFragmentFragment.records = newValue
					}
				}
				public var asTodayViewRecordFragmentFragment: MyLeaderboardApi.TodayViewRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asTodayViewRecordFragmentFragment = "fragment:asTodayViewRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asTodayViewRecordFragmentFragment = try MyLeaderboardApi.TodayViewRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asTodayViewRecordFragmentFragment = try container.decode(MyLeaderboardApi.TodayViewRecordFragment.self, forKey: .asTodayViewRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(todayViewRecordFragmentFragment: MyLeaderboardApi.TodayViewRecordFragment) {
					self.asTodayViewRecordFragmentFragment = todayViewRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
