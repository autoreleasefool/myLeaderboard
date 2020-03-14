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
		fragment PlayerDetailsFragment on Player { __typename id displayName username avatar } fragment PlayerDetailsRecordFragment on PlayerGameRecord { __typename game { __typename id image name } scoreStats { __typename best worst average } ... PlayerGameRecordFragment } fragment PlayerGameRecordFragment on PlayerGameRecord { __typename overallRecord { __typename ... RecordFragment } records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } fragment OpponentFragment on BasicPlayer { __typename id avatar } fragment RecentPlayFragment on Play { __typename id playedOn scores game { __typename image } players { __typename id avatar } winners { __typename id } } query PlayerDetails($id: ID!) { __typename player(id: $id) { __typename ... PlayerDetailsFragment records(first: -1) { __typename ... PlayerDetailsRecordFragment } recentPlays(first: 3) { __typename ... RecentPlayFragment } } }
		"""
	}
}


extension MyLeaderboardAPI.PlayerDetailsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
