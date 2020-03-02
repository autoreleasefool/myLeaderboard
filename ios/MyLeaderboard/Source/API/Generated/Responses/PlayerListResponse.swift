// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerListResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		public var players: [Players?]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(players: [Players?]) {
			self.players = players
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Players: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			public var id: GraphID {
				get {
					return asPlayerListItemFragment.id
				}
				set {
					asPlayerListItemFragment.id = newValue
				}
			}
			public var displayName: String {
				get {
					return asPlayerListItemFragment.displayName
				}
				set {
					asPlayerListItemFragment.displayName = newValue
				}
			}
			public var username: String {
				get {
					return asPlayerListItemFragment.username
				}
				set {
					asPlayerListItemFragment.username = newValue
				}
			}
			public var avatar: String? {
				get {
					return asPlayerListItemFragment.avatar
				}
				set {
					asPlayerListItemFragment.avatar = newValue
				}
			}
			public var asPlayerListItemFragment: MyLeaderboardAPI.PlayerListItem
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asPlayerListItemFragment = "fragment:asPlayerListItemFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asPlayerListItemFragment = try MyLeaderboardAPI.PlayerListItem(from: decoder)
					} catch let originalError {
						do {
							self.asPlayerListItemFragment = try container.decode(MyLeaderboardAPI.PlayerListItem.self, forKey: .asPlayerListItemFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(playerListItemFragment: MyLeaderboardAPI.PlayerListItem) {
				self.asPlayerListItemFragment = playerListItemFragment
				self.__typename = "Player"
		}
	}
}
}
