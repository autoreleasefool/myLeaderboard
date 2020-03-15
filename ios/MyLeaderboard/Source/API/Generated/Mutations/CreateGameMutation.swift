// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct CreateGameMutation: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let name: String
			public let hasScores: Bool

		// MARK: - Initializer
		public init(name: String, hasScores: Bool) {
				self.name = name
				self.hasScores = hasScores
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case name
				case hasScores
		}

		public typealias Response = CreateGameResponse

		public let queryString: String = """
		fragment NewGameFragment on Game { __typename id name } mutation CreateGame($name: String!, $hasScores: Boolean!) { __typename createGame(name: $name, hasScores: $hasScores) { __typename ... NewGameFragment } }
		"""
	}
}


extension MyLeaderboardAPI.CreateGameMutation {
  public static let operationSelections: GraphSelections.Operation? = nil
}
