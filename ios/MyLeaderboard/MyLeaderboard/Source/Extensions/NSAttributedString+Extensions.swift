//
//  NSAttributedString+Extensions.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
	convenience init(string: String, textColor: UIColor) {
		var attributes: [NSAttributedString.Key: AnyObject] = [:]
		attributes[.foregroundColor] = textColor
		self.init(string: string, attributes: attributes)
	}
}
