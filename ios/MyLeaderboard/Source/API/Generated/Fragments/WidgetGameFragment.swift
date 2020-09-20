// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct WidgetGameFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Image for the game.
		public var image: String?
		/// Name of the game.
		public var name: String

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, image: String?, name: String) {
			self.id = id
			self.image = image
			self.name = name
			self.__typename = "BasicGame"
	}

}
}
