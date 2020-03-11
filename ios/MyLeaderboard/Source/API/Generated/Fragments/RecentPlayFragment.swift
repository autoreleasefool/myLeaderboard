// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct RecentPlayFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Date and time the play was recorded.
		public var playedOn: Date
		/// Scores for the game. Order is in respect to `players`.
		public var scores: [Int]?
		/// Game that was played.
		public var game: Game
		/// Players that played in the game.
		public var players: [Players]
		/// Winners of the game.
		public var winners: [Winners]

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: String, CodingKey {
			case __typename
				case id
				case playedOn
				case scores
				case game
				case players
				case winners
		}

		public init(from decoder: Decoder) throws {
			let customScalarResolver = MyLeaderboardAPI.customScalarResolver
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.__typename = try container.decode(String.self, forKey: .__typename)
				self.id = try container.decode(GraphID.self, forKey: .id)
				self.playedOn = try customScalarResolver.decode(Date.self, rawValueType: String.self, forKey: .playedOn, container: container) { (value) -> Date in
return try customScalarResolver.decoderForDateTime(value, container.codingPath)
}
				self.scores = try container.decodeIfPresent([Int].self, forKey: .scores)
				self.game = try container.decode(Game.self, forKey: .game)
				self.players = try container.decode([Players].self, forKey: .players)
				self.winners = try container.decode([Winners].self, forKey: .winners)
		}

		public func encode(to encoder: Encoder) throws {
			let customScalarResolver = MyLeaderboardAPI.customScalarResolver
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(__typename, forKey: .__typename)

		try container.encode(id, forKey: .id)

		try customScalarResolver.encode(playedOn, rawValueType: String.self, forKey: .playedOn, container: &container) { [codingPath = container.codingPath] (value) -> String in
			return try customScalarResolver.encoderForDateTime(value, codingPath)
		}

		try container.encode(scores, forKey: .scores)

		try container.encode(game, forKey: .game)

		try container.encode(players, forKey: .players)

		try container.encode(winners, forKey: .winners)
		}

	public init(id: GraphID, playedOn: Date, scores: [Int]?, game: Game, players: [Players], winners: [Winners]) {
			self.id = id
			self.playedOn = playedOn
			self.scores = scores
			self.game = game
			self.players = players
			self.winners = winners
			self.__typename = "Play"
	}

		// MARK: - Nested Types
			public struct Game: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Image for the game.
			public var image: String?
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(image: String?) {
				self.image = image
				self.__typename = "BasicGame"
		}
	}
			public struct Players: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID
			/// Avatar of the player.
			public var avatar: String?
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(id: GraphID, avatar: String?) {
				self.id = id
				self.avatar = avatar
				self.__typename = "BasicPlayer"
		}
	}
			public struct Winners: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
		public init(id: GraphID) {
				self.id = id
				self.__typename = "BasicPlayer"
		}
	}
}
}
