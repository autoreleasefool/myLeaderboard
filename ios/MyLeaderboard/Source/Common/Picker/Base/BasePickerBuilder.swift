//
//  BasePickerBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

struct PickerItem<State: ViewState> {
	let graphID: GraphID
	let state: State.State
}

protocol BasePickerActionable: AnyObject {
	func didSelectItem(_ item: GraphID, selected: Bool)
}

enum BasePickerBuilder {
	static func sections<State: ViewState>(
		items: [PickerItem<State>],
		selectedItems: Set<GraphID>,
		actionable: BasePickerActionable
	) -> [TableSection] {
		let rows = items.map {
			cell(for: $0, selected: selectedItems.contains($0.graphID), actionable: actionable)
		}

		return [TableSection(key: "Picker", rows: rows)]
	}

	static func cell<State: ViewState>(
		for item: PickerItem<State>,
		selected: Bool,
		actionable: BasePickerActionable
	) -> CellConfigType {
		let checkedState = ImageState(
			image: selected ? UIImage(named: "Check") : UIImage(named: "Unchecked"),
			tintColor: selected ? .success : .error,
			width: Metrics.Image.small
		)

		return CombinedCell<UIImageView, ImageState, State.View, State.State, LayoutMarginsTableItemLayout>(
			key: item.graphID.rawValue,
			style: CellStyle(highlight: true),
			actions: CellActions(selectionAction: { [weak actionable] _ in
				actionable?.didSelectItem(item.graphID, selected: !selected)
				return .deselected
			}),
			state: CombinedState(state1: checkedState, state2: item.state),
			cellUpdater: { view, state in
				guard let state = state else {
					view.view1.setContentHuggingPriority(.defaultLow, for: .horizontal)
					view.view1.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
					view.stackView.spacing = 0
					return
				}

				view.view1.setContentCompressionResistancePriority(.required, for: .horizontal)
				view.view1.setContentHuggingPriority(.required, for: .horizontal)
				view.stackView.spacing = Metrics.Spacing.standard

				ImageState.updateView(view.view1, state: state.state1)
				State.updateView(view.view2, state: state.state2)
			}
		)
	}
}
