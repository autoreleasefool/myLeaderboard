// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct GameListItem: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Name of the game.
		public var name: String
		/// Image for the game.
		public var image: String?
		/// Indicates if the game includes score keeping.
		public var hasScores: Bool

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, name: String, image: String?, hasScores: Bool) {
			self.id = id
			self.name = name
			self.image = image
			self.hasScores = hasScores
			self.__typename = "Game"
	}

}
}
