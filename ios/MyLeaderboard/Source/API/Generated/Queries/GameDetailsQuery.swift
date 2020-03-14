// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct GameDetailsQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let id: GraphID
			public let ignoreBanished: Bool

		// MARK: - Initializer
		public init(id: GraphID, ignoreBanished: Bool) {
				self.id = id
				self.ignoreBanished = ignoreBanished
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case id
				case ignoreBanished
		}

		public typealias Response = GameDetailsResponse

		public let queryString: String = """
		fragment GameDetailsFragment on Game { __typename id name hasScores image } fragment GameDetailsStandingsFragment on GameStandings { __typename scoreStats { __typename best worst average } records { __typename player { __typename ... OpponentFragment } record { __typename ... PlayerGameRecordFragment } } } fragment OpponentFragment on BasicPlayer { __typename id avatar } fragment PlayerGameRecordFragment on PlayerGameRecord { __typename overallRecord { __typename ... RecordFragment } records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } fragment RecentPlayFragment on Play { __typename id playedOn scores game { __typename image } players { __typename id avatar } winners { __typename id } } query GameDetails($id: ID!, $ignoreBanished: Boolean!) { __typename game(id: $id) { __typename ... GameDetailsFragment standings(ignoreBanished: $ignoreBanished) { __typename ... GameDetailsStandingsFragment } recentPlays(first: 3) { __typename ... RecentPlayFragment } } }
		"""
	}
}


extension MyLeaderboardAPI.GameDetailsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
