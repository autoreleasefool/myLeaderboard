// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct MediumWidgetQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let player: GraphID

		// MARK: - Initializer
		public init(player: GraphID) {
				self.player = player
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case player
		}

		public typealias Response = MediumWidgetResponse

		public let queryString: String = """
		fragment MediumWidgetRecordFragment on PlayerGameRecord { __typename ... SmallWidgetRecordFragment records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment SmallWidgetRecordFragment on PlayerGameRecord { __typename game { __typename ... WidgetGameFragment } overallRecord { __typename ... RecordFragment } } fragment WidgetGameFragment on BasicGame { __typename id image name } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } fragment OpponentFragment on BasicPlayer { __typename id avatar displayName } query MediumWidget($player: ID!) { __typename player(id: $player) { __typename records(first: 2) { __typename ... MediumWidgetRecordFragment } } }
		"""
	}
}


extension MyLeaderboardApi.MediumWidgetQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
