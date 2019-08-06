//
//  LabelState.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

typealias LabelCell = HostCell<UILabel, LabelState, LayoutMarginsTableItemLayout>

struct LabelState: ViewState {
	let text: ControlText
	let size: CGFloat

	init(text: ControlText, size: CGFloat = Metrics.Text.body) {
		self.text = text
		self.size = size
	}

	static func updateView(_ view: UILabel, state: LabelState?) {
		guard let state = state else {
			view.setControlText(nil)
			return
		}

		view.setControlText(state.text)
		view.font = view.font.withSize(state.size)
	}
}
