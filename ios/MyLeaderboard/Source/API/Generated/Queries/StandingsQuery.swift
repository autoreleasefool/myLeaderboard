// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct StandingsQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let first: Int
			public let offset: Int

		// MARK: - Initializer
		public init(first: Int, offset: Int) {
				self.first = first
				self.offset = offset
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case first
				case offset
		}

		public typealias Response = StandingsResponse

		public let queryString: String = """
		fragment StandingsGameFragment on Game { __typename id name image } fragment StandingsFragment on Game { __typename standings { __typename records { __typename ... StandingsPlayerRecordFragment } } } fragment StandingsPlayerRecordFragment on PlayerRecord { __typename player { __typename ... OpponentFragment } record { __typename ... StandingsPlayerGameRecordFragment } } fragment OpponentFragment on BasicPlayer { __typename id avatar displayName } fragment StandingsPlayerGameRecordFragment on PlayerGameRecord { __typename lastPlayed overallRecord { __typename ... RecordFragment } records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } query Standings($first: Int!, $offset: Int!) { __typename games(first: $first, offset: $offset) { __typename ... StandingsGameFragment ... StandingsFragment } }
		"""
	}
}


extension MyLeaderboardAPI.StandingsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
