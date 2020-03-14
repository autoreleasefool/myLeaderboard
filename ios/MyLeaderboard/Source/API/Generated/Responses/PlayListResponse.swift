// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayListResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Get a list of plays, ordered by ID ascending. Default page size is 25. Filter by game or player
		public var plays: [Plays]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(plays: [Plays]) {
			self.plays = plays
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Plays: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asPlayListItemFragment.id
				}
				set {
					asPlayListItemFragment.id = newValue
				}
			}
			/// Date and time the play was recorded.
			public var playedOn: Date {
				get {
					return asPlayListItemFragment.playedOn
				}
				set {
					asPlayListItemFragment.playedOn = newValue
				}
			}
			/// Scores for the game. Order is in respect to `players`.
			public var scores: [Int]? {
				get {
					return asPlayListItemFragment.scores
				}
				set {
					asPlayListItemFragment.scores = newValue
				}
			}
			/// Game that was played.
			public var game: MyLeaderboardAPI.PlayListItem.Game {
				get {
					return asPlayListItemFragment.game
				}
				set {
					asPlayListItemFragment.game = newValue
				}
			}
			/// Players that played in the game.
			public var players: [MyLeaderboardAPI.PlayListItem.Players] {
				get {
					return asPlayListItemFragment.players
				}
				set {
					asPlayListItemFragment.players = newValue
				}
			}
			/// Winners of the game.
			public var winners: [MyLeaderboardAPI.PlayListItem.Winners] {
				get {
					return asPlayListItemFragment.winners
				}
				set {
					asPlayListItemFragment.winners = newValue
				}
			}
			public var asPlayListItemFragment: MyLeaderboardAPI.PlayListItem
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asPlayListItemFragment = "fragment:asPlayListItemFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asPlayListItemFragment = try MyLeaderboardAPI.PlayListItem(from: decoder)
					} catch let originalError {
						do {
							self.asPlayListItemFragment = try container.decode(MyLeaderboardAPI.PlayListItem.self, forKey: .asPlayListItemFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(playListItemFragment: MyLeaderboardAPI.PlayListItem) {
				self.asPlayListItemFragment = playListItemFragment
				self.__typename = "Play"
		}
	}
}
}
