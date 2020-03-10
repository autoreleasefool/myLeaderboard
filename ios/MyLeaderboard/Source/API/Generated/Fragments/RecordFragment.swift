// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct RecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		public var wins: Int32
		public var losses: Int32
		public var ties: Int32
		public var isBest: Bool?
		public var isWorst: Bool?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(wins: Int32, losses: Int32, ties: Int32, isBest: Bool?, isWorst: Bool?) {
			self.wins = wins
			self.losses = losses
			self.ties = ties
			self.isBest = isBest
			self.isWorst = isWorst
			self.__typename = "Record"
	}

}
}
