// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct MediumWidgetResponse: GraphApiResponse, Equatable {
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
				/// Records against other players.
				public var records: [MyLeaderboardApi.MediumWidgetRecordFragment.Records] {
					get {
						return asMediumWidgetRecordFragmentFragment.records
					}
					set {
						asMediumWidgetRecordFragmentFragment.records = newValue
					}
				}
				public var asMediumWidgetRecordFragmentFragment: MyLeaderboardApi.MediumWidgetRecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asMediumWidgetRecordFragmentFragment = "fragment:asMediumWidgetRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asMediumWidgetRecordFragmentFragment = try MyLeaderboardApi.MediumWidgetRecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asMediumWidgetRecordFragmentFragment = try container.decode(MyLeaderboardApi.MediumWidgetRecordFragment.self, forKey: .asMediumWidgetRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(mediumWidgetRecordFragmentFragment: MyLeaderboardApi.MediumWidgetRecordFragment) {
					self.asMediumWidgetRecordFragmentFragment = mediumWidgetRecordFragmentFragment
					self.__typename = "PlayerGameRecord"
			}
		}
	}
}
}
