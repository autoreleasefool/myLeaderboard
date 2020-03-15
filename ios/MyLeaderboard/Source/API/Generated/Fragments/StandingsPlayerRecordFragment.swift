// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct StandingsPlayerRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Player the record represents
		public var player: Player
		/// Record of the player.
		public var record: Record

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(player: Player, record: Record) {
			self.player = player
			self.record = record
			self.__typename = "PlayerRecord"
	}

		// MARK: - Nested Types
			public struct Player: GraphApiResponse, Equatable {
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
			/// Date and time the player last played the game.
			public var lastPlayed: Date? {
				get {
					return asStandingsPlayerGameRecordFragmentFragment.lastPlayed
				}
				set {
					asStandingsPlayerGameRecordFragmentFragment.lastPlayed = newValue
				}
			}
			/// All time record for the player.
			public var overallRecord: MyLeaderboardAPI.StandingsPlayerGameRecordFragment.OverallRecord {
				get {
					return asStandingsPlayerGameRecordFragmentFragment.overallRecord
				}
				set {
					asStandingsPlayerGameRecordFragmentFragment.overallRecord = newValue
				}
			}
			/// Records against other players.
			public var records: [MyLeaderboardAPI.StandingsPlayerGameRecordFragment.Records] {
				get {
					return asStandingsPlayerGameRecordFragmentFragment.records
				}
				set {
					asStandingsPlayerGameRecordFragmentFragment.records = newValue
				}
			}
			public var asStandingsPlayerGameRecordFragmentFragment: MyLeaderboardAPI.StandingsPlayerGameRecordFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asStandingsPlayerGameRecordFragmentFragment = "fragment:asStandingsPlayerGameRecordFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asStandingsPlayerGameRecordFragmentFragment = try MyLeaderboardAPI.StandingsPlayerGameRecordFragment(from: decoder)
					} catch let originalError {
						do {
							self.asStandingsPlayerGameRecordFragmentFragment = try container.decode(MyLeaderboardAPI.StandingsPlayerGameRecordFragment.self, forKey: .asStandingsPlayerGameRecordFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(standingsPlayerGameRecordFragmentFragment: MyLeaderboardAPI.StandingsPlayerGameRecordFragment) {
				self.asStandingsPlayerGameRecordFragmentFragment = standingsPlayerGameRecordFragmentFragment
				self.__typename = "PlayerGameRecord"
		}
	}
}
}
