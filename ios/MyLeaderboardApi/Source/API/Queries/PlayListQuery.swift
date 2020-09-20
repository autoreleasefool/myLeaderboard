// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct PlayListQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let first: Int
			public let offset: Int
			public let game: GraphID?
			public let players: [GraphID]?

		// MARK: - Initializer
		public init(first: Int, offset: Int, game: GraphID? = nil, players: [GraphID]? = nil) {
				self.first = first
				self.offset = offset
				self.game = game
				self.players = players
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case first
				case offset
				case game
				case players
		}

		public typealias Response = PlayListResponse

		public let queryString: String = """
		fragment PlayListItem on Play { __typename id playedOn scores game { __typename image name } players { __typename displayName ... OpponentFragment } winners { __typename id } } fragment OpponentFragment on BasicPlayer { __typename id avatar displayName } query PlayList($first: Int!, $offset: Int!, $game: ID, $players: [ID!]) { __typename plays(first: $first, offset: $offset, game: $game, players: $players, reverse: true) { __typename ... PlayListItem } }
		"""
	}
}


extension MyLeaderboardApi.PlayListQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
