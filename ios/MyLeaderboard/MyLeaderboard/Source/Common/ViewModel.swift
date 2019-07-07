//
//  ViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

protocol ViewModel {
	associatedtype Action: BaseAction
	associatedtype ViewAction: BaseViewAction

	func postViewAction(_ viewAction: ViewAction)
	var handleAction: (_ action: Action) -> Void { get set }
}
