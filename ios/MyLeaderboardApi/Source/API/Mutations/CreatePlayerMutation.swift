// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct CreatePlayerMutation: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let displayName: String
			public let username: String
			public let board: GraphID

		// MARK: - Initializer
		public init(displayName: String, username: String, board: GraphID) {
				self.displayName = displayName
				self.username = username
				self.board = board
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case displayName
				case username
				case board
		}

		public typealias Response = CreatePlayerResponse

		public let queryString: String = """
		fragment NewPlayerFragment on Player { __typename id displayName } mutation CreatePlayer($displayName: String!, $username: String!, $board: ID!) { __typename createPlayer(displayName: $displayName, username: $username, board: $board) { __typename ... NewPlayerFragment } }
		"""
	}
}


extension MyLeaderboardApi.CreatePlayerMutation {
  public static let operationSelections: GraphSelections.Operation? = nil
}
