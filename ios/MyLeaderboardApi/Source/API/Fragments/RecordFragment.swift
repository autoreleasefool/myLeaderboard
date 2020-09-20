// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct RecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Number of wins.
		public var wins: Int
		/// Number of losses.
		public var losses: Int
		/// Number of ties.
		public var ties: Int
		/// True if this represents the best record relative to similar records (of the player or the game).
		public var isBest: Bool?
		/// True if this represents the worst record relative to similar records (of the player or the game).
		public var isWorst: Bool?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(wins: Int, losses: Int, ties: Int, isBest: Bool?, isWorst: Bool?) {
			self.wins = wins
			self.losses = losses
			self.ties = ties
			self.isBest = isBest
			self.isWorst = isWorst
			self.__typename = "Record"
	}

}
}
