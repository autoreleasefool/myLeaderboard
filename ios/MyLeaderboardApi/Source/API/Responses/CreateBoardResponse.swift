// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct CreateBoardResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Create a new board.
		public var createBoard: CreateBoard?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

	public init(createBoard: CreateBoard?) {
			self.createBoard = createBoard
			self.__typename = "Mutation"
	}

		// MARK: - Nested Types
			public struct CreateBoard: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Unique ID.
			public var id: GraphID {
				get {
					return asNewBoardFragmentFragment.id
				}
				set {
					asNewBoardFragmentFragment.id = newValue
				}
			}
			/// Name of the board.
			public var boardName: String {
				get {
					return asNewBoardFragmentFragment.boardName
				}
				set {
					asNewBoardFragmentFragment.boardName = newValue
				}
			}
			public var asNewBoardFragmentFragment: MyLeaderboardApi.NewBoardFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asNewBoardFragmentFragment = "fragment:asNewBoardFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asNewBoardFragmentFragment = try MyLeaderboardApi.NewBoardFragment(from: decoder)
					} catch let originalError {
						do {
							self.asNewBoardFragmentFragment = try container.decode(MyLeaderboardApi.NewBoardFragment.self, forKey: .asNewBoardFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(newBoardFragmentFragment: MyLeaderboardApi.NewBoardFragment) {
				self.asNewBoardFragmentFragment = newBoardFragmentFragment
				self.__typename = "Board"
		}
	}
}
}
