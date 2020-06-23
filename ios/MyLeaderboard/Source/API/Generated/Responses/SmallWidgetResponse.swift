// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct SmallWidgetResponse: GraphApiResponse, Equatable {
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
				public var game: MyLeaderboardAPI.SmallWidgetRecordFragment.Game {
					get {
						return asSmallWidgetRecordFragmentFragment.game
					}
					set {
						asSmallWidgetRecordFragmentFragment.game = newValue
					}
				}
				/// All time record for the player.
				public var overallRecord: MyLeaderboardAPI.SmallWidgetRecordFragment.OverallRecord {
					get {
						return asSmallWidgetRecordFragmentFragment.overallRecord
					}
					set {
						asSmallWidgetRecordFragmentFragment.overallRecord = newValue
					}
				}
				/// Records against other players.
				public var records: [MyLeaderboardAPI.SmallWidgetRecordFragment.Records] {
					get {
						return asSmallWidgetRecordFragmentFragment.records
					}
					set {
						asSmallWidgetRecordFragmentFragment.records = newValue
					}
				}
				public var asSmallWidgetRecordFragmentFragment: MyLeaderboardAPI.SmallWidgetRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asSmallWidgetRecordFragmentFragment = "fragment:asSmallWidgetRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asSmallWidgetRecordFragmentFragment = try MyLeaderboardAPI.SmallWidgetRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asSmallWidgetRecordFragmentFragment = try container.decode(MyLeaderboardAPI.SmallWidgetRecordFragment.self, forKey: .asSmallWidgetRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(smallWidgetRecordFragmentFragment: MyLeaderboardAPI.SmallWidgetRecordFragment) {
					self.asSmallWidgetRecordFragmentFragment = smallWidgetRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
