//
//  ViewState.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

protocol ViewState: Equatable {
	associatedtype View: UIView
	associatedtype State: Equatable

	static func updateView(_ view: View, state: State?)
}
