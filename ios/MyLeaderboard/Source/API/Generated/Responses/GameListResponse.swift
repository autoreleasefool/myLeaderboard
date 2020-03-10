// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct GameListResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		public var games: [Games?]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(games: [Games?]) {
			self.games = games
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Games: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			public var id: GraphID {
				get {
					return asGameListItemFragment.id
				}
				set {
					asGameListItemFragment.id = newValue
				}
			}
			public var name: String {
				get {
					return asGameListItemFragment.name
				}
				set {
					asGameListItemFragment.name = newValue
				}
			}
			public var image: String? {
				get {
					return asGameListItemFragment.image
				}
				set {
					asGameListItemFragment.image = newValue
				}
			}
			public var hasScores: Bool {
				get {
					return asGameListItemFragment.hasScores
				}
				set {
					asGameListItemFragment.hasScores = newValue
				}
			}
			public var asGameListItemFragment: MyLeaderboardAPI.GameListItem
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asGameListItemFragment = "fragment:asGameListItemFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asGameListItemFragment = try MyLeaderboardAPI.GameListItem(from: decoder)
					} catch let originalError {
						do {
							self.asGameListItemFragment = try container.decode(MyLeaderboardAPI.GameListItem.self, forKey: .asGameListItemFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(gameListItemFragment: MyLeaderboardAPI.GameListItem) {
				self.asGameListItemFragment = gameListItemFragment
				self.__typename = "Game"
		}
	}
}
}
