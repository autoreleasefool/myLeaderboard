// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct OpponentFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Avatar of the player.
		public var avatar: String?
		/// Display name of the player.
		public var displayName: String

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, avatar: String?, displayName: String) {
			self.id = id
			self.avatar = avatar
			self.displayName = displayName
			self.__typename = "BasicPlayer"
	}

}
}
