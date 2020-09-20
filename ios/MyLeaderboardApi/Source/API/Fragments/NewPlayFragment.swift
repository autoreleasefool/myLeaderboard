// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct NewPlayFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Unique ID.
		public var id: GraphID

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(id: GraphID) {
			self.id = id
			self.__typename = "Play"
	}

}
}
