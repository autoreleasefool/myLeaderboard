// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct SmallWidgetQuery: GraphApiQuery, ResponseAssociable, Equatable {
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

		public typealias Response = SmallWidgetResponse

		public let queryString: String = """
		fragment SmallWidgetRecordFragment on PlayerGameRecord { __typename game { __typename ... WidgetGameFragment } overallRecord { __typename ... RecordFragment } } fragment WidgetGameFragment on BasicGame { __typename id image name } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } query SmallWidget($player: ID!) { __typename player(id: $player) { __typename records(first: 2) { __typename ... SmallWidgetRecordFragment } } }
		"""
	}
}


extension MyLeaderboardApi.SmallWidgetQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
