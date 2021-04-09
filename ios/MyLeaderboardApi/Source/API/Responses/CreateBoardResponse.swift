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
					return asBoardDetailsFragmentFragment.id
				}
				set {
					asBoardDetailsFragmentFragment.id = newValue
				}
			}
			/// Name of the board.
			public var boardName: String {
				get {
					return asBoardDetailsFragmentFragment.boardName
				}
				set {
					asBoardDetailsFragmentFragment.boardName = newValue
				}
			}
			public var asBoardDetailsFragmentFragment: MyLeaderboardApi.BoardDetailsFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case asBoardDetailsFragmentFragment = "fragment:asBoardDetailsFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					do {
						self.asBoardDetailsFragmentFragment = try MyLeaderboardApi.BoardDetailsFragment(from: decoder)
					} catch let originalError {
						do {
							self.asBoardDetailsFragmentFragment = try container.decode(MyLeaderboardApi.BoardDetailsFragment.self, forKey: .asBoardDetailsFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(boardDetailsFragmentFragment: MyLeaderboardApi.BoardDetailsFragment) {
				self.asBoardDetailsFragmentFragment = boardDetailsFragmentFragment
				self.__typename = "Board"
		}
	}
}
}
