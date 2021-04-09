// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct BoardDetailsQuery: GraphApiQuery, ResponseAssociable, Equatable {
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

		public typealias Response = BoardDetailsResponse

		public let queryString: String = """
		fragment BoardDetailsFragment on Board { __typename id boardName } query BoardDetails($id: ID!) { __typename board(id: $id) { __typename ... BoardDetailsFragment } }
		"""
	}
}


extension MyLeaderboardApi.BoardDetailsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
