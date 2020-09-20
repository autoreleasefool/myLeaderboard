// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct StandingsFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Player vs player records, and score statistics for the game.
		public var standings: Standings

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(standings: Standings) {
			self.standings = standings
			self.__typename = "Game"
	}

		// MARK: - Nested Types
			public struct Standings: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player vs player records.
			public var records: [Records]
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
		public init(records: [Records]) {
				self.records = records
				self.__typename = "GameStandings"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Player the record represents
				public var player: MyLeaderboardApi.StandingsPlayerRecordFragment.Player {
					get {
						return asStandingsPlayerRecordFragmentFragment.player
					}
					set {
						asStandingsPlayerRecordFragmentFragment.player = newValue
					}
				}
				/// Record of the player.
				public var record: MyLeaderboardApi.StandingsPlayerRecordFragment.Record {
					get {
						return asStandingsPlayerRecordFragmentFragment.record
					}
					set {
						asStandingsPlayerRecordFragmentFragment.record = newValue
					}
				}
				public var asStandingsPlayerRecordFragmentFragment: MyLeaderboardApi.StandingsPlayerRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asStandingsPlayerRecordFragmentFragment = "fragment:asStandingsPlayerRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asStandingsPlayerRecordFragmentFragment = try MyLeaderboardApi.StandingsPlayerRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asStandingsPlayerRecordFragmentFragment = try container.decode(MyLeaderboardApi.StandingsPlayerRecordFragment.self, forKey: .asStandingsPlayerRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(standingsPlayerRecordFragmentFragment: MyLeaderboardApi.StandingsPlayerRecordFragment) {
					self.asStandingsPlayerRecordFragmentFragment = standingsPlayerRecordFragmentFragment
					self.__typename = "PlayerRecord"
			}
		}
	}
}
}
