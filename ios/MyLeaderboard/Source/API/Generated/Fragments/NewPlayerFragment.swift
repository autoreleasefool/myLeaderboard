// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct NewPlayerFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Display name of the player.
		public var displayName: String

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, displayName: String) {
			self.id = id
			self.displayName = displayName
			self.__typename = "Player"
	}

}
}
