//
//  BasePickerBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import FunctionalTableData

struct PickerItem {
	let id: ID
	let view: CellConfigType
}

struct BasePickerBuilder {
	static func sections(items: [PickerItem], selectedItems: Set<ID>) -> [TableSection] {
		return []
	}
}
