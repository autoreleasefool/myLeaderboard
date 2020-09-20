// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct GameListQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let first: Int
			public let offset: Int

		// MARK: - Initializer
		public init(first: Int, offset: Int) {
				self.first = first
				self.offset = offset
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case first
				case offset
		}

		public typealias Response = GameListResponse

		public let queryString: String = """
		fragment GameListItem on Game { __typename id name image hasScores } query GameList($first: Int!, $offset: Int!) { __typename games(first: $first, offset: $offset) { __typename ... GameListItem } }
		"""
	}
}


extension MyLeaderboardApi.GameListQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
