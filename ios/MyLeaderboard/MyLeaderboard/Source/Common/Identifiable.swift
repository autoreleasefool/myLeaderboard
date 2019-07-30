//
//  Identifiable.swift
//  MyLeaderboard
//
//  Created by Morteza Ahmadi on 2019-07-30.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//
import Foundation

typealias ID = Int
protocol Identifiable {
	var id: ID { get }
}
