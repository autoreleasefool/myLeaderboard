// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct CreatePlayerMutation: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let displayName: String
			public let username: String

		// MARK: - Initializer
		public init(displayName: String, username: String) {
				self.displayName = displayName
				self.username = username
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case displayName
				case username
		}

		public typealias Response = CreatePlayerResponse

		public let queryString: String = """
		fragment NewPlayerFragment on Player { __typename id displayName } mutation CreatePlayer($displayName: String!, $username: String!) { __typename createPlayer(displayName: $displayName, username: $username) { __typename ... NewPlayerFragment } }
		"""
	}
}


extension MyLeaderboardAPI.CreatePlayerMutation {
  public static let operationSelections: GraphSelections.Operation? = nil
}
