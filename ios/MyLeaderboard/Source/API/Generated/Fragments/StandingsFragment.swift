// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct StandingsFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Name of the game.
		public var name: String
		/// Image for the game.
		public var image: String?
		/// Player vs player records, and score statistics for the game.
		public var standings: Standings

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, name: String, image: String?, standings: Standings) {
			self.id = id
			self.name = name
			self.image = image
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
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(records: [Records]) {
				self.records = records
				self.__typename = "GameStandings"
		}
			// MARK: - Nested Types
				public struct Records: GraphApiResponse, Equatable {
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
					/// All time record for the player.
					public var overallRecord: MyLeaderboardAPI.PlayerGameRecordFragment.OverallRecord {
						get {
							return asPlayerGameRecordFragmentFragment.overallRecord
						}
						set {
							asPlayerGameRecordFragmentFragment.overallRecord = newValue
						}
					}
					/// Records against other players.
					public var records: [MyLeaderboardAPI.PlayerGameRecordFragment.Records] {
						get {
							return asPlayerGameRecordFragmentFragment.records
						}
						set {
							asPlayerGameRecordFragmentFragment.records = newValue
						}
					}
					public var asPlayerGameRecordFragmentFragment: MyLeaderboardAPI.PlayerGameRecordFragment
				// MARK: - Helpers
				public let __typename: String
				public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
				public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
					private enum CodingKeys: String, CodingKey {
						case __typename
							case asPlayerGameRecordFragmentFragment = "fragment:asPlayerGameRecordFragmentFragment"
					}
					public init(from decoder: Decoder) throws {
						let container = try decoder.container(keyedBy: CodingKeys.self)
						self.__typename = try container.decode(String.self, forKey: .__typename)
							do {
								self.asPlayerGameRecordFragmentFragment = try MyLeaderboardAPI.PlayerGameRecordFragment(from: decoder)
							} catch let originalError {
								do {
									self.asPlayerGameRecordFragmentFragment = try container.decode(MyLeaderboardAPI.PlayerGameRecordFragment.self, forKey: .asPlayerGameRecordFragmentFragment)
								} catch {
										throw originalError
								}
							}
					}
				public init(playerGameRecordFragmentFragment: MyLeaderboardAPI.PlayerGameRecordFragment) {
						self.asPlayerGameRecordFragmentFragment = playerGameRecordFragmentFragment
						self.__typename = "PlayerGameRecord"
				}
			}
		}
	}
}
}
