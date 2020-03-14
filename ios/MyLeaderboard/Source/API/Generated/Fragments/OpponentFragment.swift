// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct OpponentFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID
		/// Avatar of the player.
		public var avatar: String?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID, avatar: String?) {
			self.id = id
			self.avatar = avatar
			self.__typename = "BasicPlayer"
	}

}
}
