// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct SmallWidgetRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Game the record represents.
		public var game: Game
		/// All time record for the player.
		public var overallRecord: OverallRecord
		/// Records against other players.
		public var records: [Records]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(game: Game, overallRecord: OverallRecord, records: [Records]) {
			self.game = game
			self.overallRecord = overallRecord
			self.records = records
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
			public var asWidgetGameFragmentFragment: MyLeaderboardAPI.WidgetGameFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asWidgetGameFragmentFragment = "fragment:asWidgetGameFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asWidgetGameFragmentFragment = try MyLeaderboardAPI.WidgetGameFragment(from: decoder)
					} catch let originalError {
						do {
							self.asWidgetGameFragmentFragment = try container.decode(MyLeaderboardAPI.WidgetGameFragment.self, forKey: .asWidgetGameFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(widgetGameFragmentFragment: MyLeaderboardAPI.WidgetGameFragment) {
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
			public var asRecordFragmentFragment: MyLeaderboardAPI.RecordFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asRecordFragmentFragment = try MyLeaderboardAPI.RecordFragment(from: decoder)
					} catch let originalError {
						do {
							self.asRecordFragmentFragment = try container.decode(MyLeaderboardAPI.RecordFragment.self, forKey: .asRecordFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(recordFragmentFragment: MyLeaderboardAPI.RecordFragment) {
				self.asRecordFragmentFragment = recordFragmentFragment
				self.__typename = "Record"
		}
	}
			public struct Records: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player the record is against.
			public var opponent: Opponent
			/// Record against the opponent.
			public var record: Record
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(opponent: Opponent, record: Record) {
				self.opponent = opponent
				self.record = record
				self.__typename = "PlayerVSRecord"
		}
			// MARK: - Nested Types
				public struct Opponent: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID {
					get {
						return asOpponentFragmentFragment.id
					}
					set {
						asOpponentFragmentFragment.id = newValue
					}
				}
				/// Avatar of the player.
				public var avatar: String? {
					get {
						return asOpponentFragmentFragment.avatar
					}
					set {
						asOpponentFragmentFragment.avatar = newValue
					}
				}
				/// Display name of the player.
				public var displayName: String {
					get {
						return asOpponentFragmentFragment.displayName
					}
					set {
						asOpponentFragmentFragment.displayName = newValue
					}
				}
				public var asOpponentFragmentFragment: MyLeaderboardAPI.OpponentFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asOpponentFragmentFragment = "fragment:asOpponentFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asOpponentFragmentFragment = try MyLeaderboardAPI.OpponentFragment(from: decoder)
						} catch let originalError {
							do {
								self.asOpponentFragmentFragment = try container.decode(MyLeaderboardAPI.OpponentFragment.self, forKey: .asOpponentFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(opponentFragmentFragment: MyLeaderboardAPI.OpponentFragment) {
					self.asOpponentFragmentFragment = opponentFragmentFragment
					self.__typename = "BasicPlayer"
			}
		}
				public struct Record: GraphApiResponse, Equatable {
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
				public var asRecordFragmentFragment: MyLeaderboardAPI.RecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecordFragmentFragment = try MyLeaderboardAPI.RecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecordFragmentFragment = try container.decode(MyLeaderboardAPI.RecordFragment.self, forKey: .asRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recordFragmentFragment: MyLeaderboardAPI.RecordFragment) {
					self.asRecordFragmentFragment = recordFragmentFragment
					self.__typename = "Record"
			}
		}
	}
}
}
