// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct SingleGameListItemQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let id: GraphID

		// MARK: - Initializer
		public init(id: GraphID) {
				self.id = id
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case id
		}

		public typealias Response = SingleGameListItemResponse

		public let queryString: String = """
		fragment GameListItem on Game { __typename id name image hasScores } query SingleGameListItem($id: ID!) { __typename game(id: $id) { __typename ... GameListItem } }
		"""
	}
}


extension MyLeaderboardApi.SingleGameListItemQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
