// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct CreateBoardMutation: GraphApiQuery, ResponseAssociable, Equatable {
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

		public typealias Response = CreateBoardResponse

		public let queryString: String = """
		fragment NewBoardFragment on Board { __typename id boardName } mutation CreateBoard($boardName: String!) { __typename createBoard(boardName: $boardName) { __typename ... NewBoardFragment } }
		"""
	}
}


extension MyLeaderboardApi.CreateBoardMutation {
  public static let operationSelections: GraphSelections.Operation? = nil
}
