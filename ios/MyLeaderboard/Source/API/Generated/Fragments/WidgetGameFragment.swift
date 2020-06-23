// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct WidgetGameFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Image for the game.
		public var image: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, image: String?) {
			self.id = id
			self.image = image
			self.__typename = "BasicGame"
	}

}
}
