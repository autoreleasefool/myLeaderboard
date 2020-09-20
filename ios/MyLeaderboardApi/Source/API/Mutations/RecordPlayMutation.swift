// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct RecordPlayMutation: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let players: [GraphID]
			public let winners: [GraphID]
			public let game: GraphID
			public let scores: [Int]?

		// MARK: - Initializer
		public init(players: [GraphID], winners: [GraphID], game: GraphID, scores: [Int]? = nil) {
				self.players = players
				self.winners = winners
				self.game = game
				self.scores = scores
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case players
				case winners
				case game
				case scores
		}

		public typealias Response = RecordPlayResponse

		public let queryString: String = """
		fragment NewPlayFragment on Play { __typename id } mutation RecordPlay($players: [ID!]!, $winners: [ID!]!, $game: ID!, $scores: [Int!]) { __typename recordPlay(players: $players, winners: $winners, game: $game, scores: $scores) { __typename ... NewPlayFragment } }
		"""
	}
}


extension MyLeaderboardApi.RecordPlayMutation {
  public static let operationSelections: GraphSelections.Operation? = nil
}
