// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct PlayerListItem: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Display name of the player.
		public var displayName: String
		/// GitHub username of the player.
		public var username: String
		/// Avatar of the player.
		public var avatar: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(id: GraphID, displayName: String, username: String, avatar: String?) {
			self.id = id
			self.displayName = displayName
			self.username = username
			self.avatar = avatar
			self.__typename = "Player"
	}

}
}
