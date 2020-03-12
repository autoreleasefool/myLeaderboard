// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct GameDetailsFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Name of the game.
		public var name: String
		/// Indicates if the game includes score keeping.
		public var hasScores: Bool
		/// Image for the game.
		public var image: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, name: String, hasScores: Bool, image: String?) {
			self.id = id
			self.name = name
			self.hasScores = hasScores
			self.image = image
			self.__typename = "Game"
	}

}
}
