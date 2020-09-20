// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct StandingsPlayerGameRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Date and time the player last played the game.
		public var lastPlayed: Date?
		/// All time record for the player.
		public var overallRecord: OverallRecord
		/// Records against other players.
		public var records: [Records]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: String, CodingKey {
			case __typename
				case lastPlayed
				case overallRecord
				case records
		}

		public init(from decoder: Decoder) throws {
			let customScalarResolver = MyLeaderboardApi.customScalarResolver
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.__typename = try container.decode(String.self, forKey: .__typename)
				self.lastPlayed = try customScalarResolver.decode(Date?.self, rawValueType: String.self, forKey: .lastPlayed, container: container) { (value) -> Date in
return try customScalarResolver.decoderForDateTime(value, container.codingPath)
}
				self.overallRecord = try container.decode(OverallRecord.self, forKey: .overallRecord)
				self.records = try container.decode([Records].self, forKey: .records)
		}

		public func encode(to encoder: Encoder) throws {
			let customScalarResolver = MyLeaderboardApi.customScalarResolver
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(__typename, forKey: .__typename)

		try customScalarResolver.encode(lastPlayed, rawValueType: String.self, forKey: .lastPlayed, container: &container) { [codingPath = container.codingPath] (value) -> String in
			return try customScalarResolver.encoderForDateTime(value, codingPath)
		}

		try container.encode(overallRecord, forKey: .overallRecord)

		try container.encode(records, forKey: .records)
		}

	public init(lastPlayed: Date?, overallRecord: OverallRecord, records: [Records]) {
			self.lastPlayed = lastPlayed
			self.overallRecord = overallRecord
			self.records = records
			self.__typename = "PlayerGameRecord"
	}

		// MARK: - Nested Types
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
			public struct Records: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player the record is against.
			public var opponent: Opponent
			/// Record against the opponent.
			public var record: Record
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
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
				public var asOpponentFragmentFragment: MyLeaderboardApi.OpponentFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asOpponentFragmentFragment = "fragment:asOpponentFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asOpponentFragmentFragment = try MyLeaderboardApi.OpponentFragment(from: decoder)
						} catch let originalError {
							do {
								self.asOpponentFragmentFragment = try container.decode(MyLeaderboardApi.OpponentFragment.self, forKey: .asOpponentFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(opponentFragmentFragment: MyLeaderboardApi.OpponentFragment) {
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
}
