// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct NewPlayFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(id: GraphID) {
			self.id = id
			self.__typename = "Play"
	}

}
}
