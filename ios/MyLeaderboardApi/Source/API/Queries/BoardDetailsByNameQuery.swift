// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct BoardDetailsByNameQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let boardName: String

		// MARK: - Initializer
		public init(boardName: String) {
				self.boardName = boardName
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case boardName
		}

		public typealias Response = BoardDetailsByNameResponse

		public let queryString: String = """
		fragment BoardDetailsFragment on Board { __typename id boardName } query BoardDetailsByName($boardName: String!) { __typename findBoardByName(boardName: $boardName) { __typename ... BoardDetailsFragment } }
		"""
	}
}


extension MyLeaderboardApi.BoardDetailsByNameQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
