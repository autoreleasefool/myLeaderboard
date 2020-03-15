// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
	struct TodayViewQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let player: GraphID

		// MARK: - Initializer
		public init(player: GraphID) {
				self.player = player
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

		private enum CodingKeys: CodingKey {
				case player
		}

		public typealias Response = TodayViewResponse

		public let queryString: String = """
		fragment TodayViewRecordFragment on PlayerGameRecord { __typename game { __typename ... TodayViewGameFragment } overallRecord { __typename ... RecordFragment } records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment TodayViewGameFragment on BasicGame { __typename id image } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } fragment OpponentFragment on BasicPlayer { __typename id avatar displayName } query TodayView($player: ID!) { __typename player(id: $player) { __typename records(first: 2) { __typename ... TodayViewRecordFragment } } }
		"""
	}
}


extension MyLeaderboardAPI.TodayViewQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
