// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct PlayerListQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let board: GraphID
			public let first: Int
			public let offset: Int

		// MARK: - Initializer
		public init(board: GraphID, first: Int, offset: Int) {
				self.board = board
				self.first = first
				self.offset = offset
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case board
				case first
				case offset
		}

		public typealias Response = PlayerListResponse

		public let queryString: String = """
		fragment PlayerListItem on Player { __typename id displayName username avatar } query PlayerList($board: ID!, $first: Int!, $offset: Int!) { __typename players(first: $first, offset: $offset, board: $board) { __typename ... PlayerListItem } }
		"""
	}
}


extension MyLeaderboardApi.PlayerListQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
