// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct StandingsGameFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Name of the game.
		public var name: String
		/// Image for the game.
		public var image: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(id: GraphID, name: String, image: String?) {
			self.id = id
			self.name = name
			self.image = image
			self.__typename = "Game"
	}

}
}
