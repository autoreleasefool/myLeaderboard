//
//  CombinedView.swift
//  Shopify
//
//  Created by Geoffrey Foster on 2017-01-18.
//  Copyright © 2017 Shopify. All rights reserved.
//

import UIKit
import FunctionalTableData

public typealias CombinedCell<View1: UIView, State1: Equatable, View2: UIView, State2: Equatable, Layout: TableItemLayout> = HostCell<CombinedView<View1, View2>, CombinedState<State1, State2>, Layout>

public class CombinedView<View1: UIView, View2: UIView>: UIView {
	public let view1 = View1()
	public let view2 = View2()
	public let stackView: UIStackView

	public override init(frame: CGRect) {
		stackView = UIStackView(frame: frame)
		super.init(frame: frame)
		stackView.addArrangedSubview(view1)
		stackView.addArrangedSubview(view2)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
			])
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

public struct CombinedState<S1: Equatable, S2: Equatable>: Equatable {
	public let state1: S1
	public let state2: S2
	public init(state1: S1, state2: S2) {
		self.state1 = state1
		self.state2 = state2
	}

	public static func ==(lhs: CombinedState, rhs: CombinedState) -> Bool {
		return lhs.state1 == rhs.state1 && lhs.state2 == rhs.state2
	}
}

extension CombinedState: Encodable where S1: Encodable, S2: Encodable {
	enum CodingKeys: CodingKey {
		case state1
		case state2
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(state1, forKey: .state1)
		try container.encode(state2, forKey: .state2)
	}
}
