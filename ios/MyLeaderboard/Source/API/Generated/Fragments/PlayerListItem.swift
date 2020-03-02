// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct PlayerListItem: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		public var id: GraphID
		public var displayName: String
		public var username: String
		public var avatar: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, displayName: String, username: String, avatar: String?) {
			self.id = id
			self.displayName = displayName
			self.username = username
			self.avatar = avatar
			self.__typename = "Player"
	}

}
}
