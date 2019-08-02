//
//  CombinedView.swift
//  Shopify
//
//  Created by Geoffrey Foster on 2017-01-18.
//  Copyright © 2017 Shopify. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias CombinedCell<View1: UIView, State1: Equatable, View2: UIView, State2: Equatable, Layout: TableItemLayout> = HostCell<CombinedView<View1, View2>, CombinedState<State1, State2>, Layout>

class CombinedView<View1: UIView, View2: UIView>: UIView {
	let view1 = View1()
	let view2 = View2()
	let stackView: UIStackView

	override init(frame: CGRect) {
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

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct CombinedState<S1: Equatable, S2: Equatable>: Equatable {
	let state1: S1
	let state2: S2
	init(state1: S1, state2: S2) {
		self.state1 = state1
		self.state2 = state2
	}

	static func == (lhs: CombinedState, rhs: CombinedState) -> Bool {
		return lhs.state1 == rhs.state1 && lhs.state2 == rhs.state2
	}
}

extension CombinedState: ViewState where S1: ViewState, S2: ViewState {
	static func updateView(_ view: CombinedView<S1.View, S2.View>, state: CombinedState<S1.State, S2.State>?) {
		S1.updateView(view.view1, state: state?.state1)
		S2.updateView(view.view2, state: state?.state2)
	}
}
