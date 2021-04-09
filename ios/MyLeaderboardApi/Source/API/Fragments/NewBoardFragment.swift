// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct NewBoardFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Name of the board.
		public var boardName: String

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(id: GraphID, boardName: String) {
			self.id = id
			self.boardName = boardName
			self.__typename = "Board"
	}

}
}
