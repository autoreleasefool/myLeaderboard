// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct SmallWidgetRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Game the record represents.
		public var game: Game
		/// All time record for the player.
		public var overallRecord: OverallRecord

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(game: Game, overallRecord: OverallRecord) {
			self.game = game
			self.overallRecord = overallRecord
			self.__typename = "PlayerGameRecord"
	}

		// MARK: - Nested Types
			public struct Game: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asWidgetGameFragmentFragment.id
				}
				set {
					asWidgetGameFragmentFragment.id = newValue
				}
			}
			/// Image for the game.
			public var image: String? {
				get {
					return asWidgetGameFragmentFragment.image
				}
				set {
					asWidgetGameFragmentFragment.image = newValue
				}
			}
			/// Name of the game.
			public var name: String {
				get {
					return asWidgetGameFragmentFragment.name
				}
				set {
					asWidgetGameFragmentFragment.name = newValue
				}
			}
			public var asWidgetGameFragmentFragment: MyLeaderboardApi.WidgetGameFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asWidgetGameFragmentFragment = "fragment:asWidgetGameFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asWidgetGameFragmentFragment = try MyLeaderboardApi.WidgetGameFragment(from: decoder)
					} catch let originalError {
						do {
							self.asWidgetGameFragmentFragment = try container.decode(MyLeaderboardApi.WidgetGameFragment.self, forKey: .asWidgetGameFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(widgetGameFragmentFragment: MyLeaderboardApi.WidgetGameFragment) {
				self.asWidgetGameFragmentFragment = widgetGameFragmentFragment
				self.__typename = "BasicGame"
		}
	}
			public struct OverallRecord: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Number of wins.
			public var wins: Int {
				get {
					return asRecordFragmentFragment.wins
				}
				set {
					asRecordFragmentFragment.wins = newValue
				}
			}
			/// Number of losses.
			public var losses: Int {
				get {
					return asRecordFragmentFragment.losses
				}
				set {
					asRecordFragmentFragment.losses = newValue
				}
			}
			/// Number of ties.
			public var ties: Int {
				get {
					return asRecordFragmentFragment.ties
				}
				set {
					asRecordFragmentFragment.ties = newValue
				}
			}
			/// True if this represents the best record relative to similar records (of the player or the game).
			public var isBest: Bool? {
				get {
					return asRecordFragmentFragment.isBest
				}
				set {
					asRecordFragmentFragment.isBest = newValue
				}
			}
			/// True if this represents the worst record relative to similar records (of the player or the game).
			public var isWorst: Bool? {
				get {
					return asRecordFragmentFragment.isWorst
				}
				set {
					asRecordFragmentFragment.isWorst = newValue
				}
			}
			public var asRecordFragmentFragment: MyLeaderboardApi.RecordFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asRecordFragmentFragment = try MyLeaderboardApi.RecordFragment(from: decoder)
					} catch let originalError {
						do {
							self.asRecordFragmentFragment = try container.decode(MyLeaderboardApi.RecordFragment.self, forKey: .asRecordFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(recordFragmentFragment: MyLeaderboardApi.RecordFragment) {
				self.asRecordFragmentFragment = recordFragmentFragment
				self.__typename = "Record"
		}
	}
}
}
