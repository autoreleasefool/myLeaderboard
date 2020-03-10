// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct PlayerDetailsQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let id: GraphID

		// MARK: - Initializer
		public init(id: GraphID) {
				self.id = id
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case id
		}

		public typealias Response = PlayerDetailsResponse

		public let queryString: String = """
		fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } fragment RecentPlayFragment on Play { __typename id playedOn scores game { __typename image } players { __typename id avatar } winners { __typename id } } query PlayerDetails($id: ID!) { __typename player(id: $id) { __typename id displayName username avatar records(first: -1) { __typename game { __typename id image name } overallRecord { __typename ... RecordFragment } scoreStats { __typename best worst average } records { __typename opponent { __typename id avatar } record { __typename ... RecordFragment } } } recentPlays(first: 3) { __typename ... RecentPlayFragment } } }
		"""
	}
}


extension MyLeaderboardAPI.PlayerDetailsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
