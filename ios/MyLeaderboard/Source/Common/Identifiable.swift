//
//  Identifiable.swift
//  MyLeaderboard
//
//  Created by Morteza Ahmadi on 2019-07-30.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//
import Foundation

// swiftlint:disable:next type_name
typealias ID = Int

protocol Identifiable {
	@available(*, deprecated, message: "Use graphID instead")
	// swiftlint:disable:next identifier_name
	var id: ID { get }
}

protocol GraphQLIdentifiable {
	var graphID: GraphID { get }
}
