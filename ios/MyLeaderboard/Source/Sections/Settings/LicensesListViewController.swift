//
//  LicensesListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-23.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

class LicensesListViewController: FTDViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Licenses"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish))

		var rows: [CellConfigType] = []
		LicensesListViewController.licenses.forEach { license in
			let licenseName = license.key
			let license = license.value

			rows.append(LabelCell(
				key: "License-\(licenseName)",
				style: CellStyle(backgroundColor: .primaryLight),
				state: LabelState(text: .attributed(NSAttributedString(string: licenseName, textColor: .text)), size: Metrics.Text.title),
				cellUpdater: LabelState.updateView
			))

			rows.append(LabelCell(
				key: "LicenseContents-\(licenseName)",
				state: LabelState(text: .attributed(NSAttributedString(string: license, textColor: .text)), truncationStyle: .multiline, size: Metrics.Text.body),
				cellUpdater: LabelState.updateView
			))
		}

		let section = TableSection(key: "Contributors", rows: rows)
		tableData.renderAndDiff([section])
	}

	@objc private func finish() {
		dismiss(animated: true)
	}

	private static let licenses: [String: String] = [
		"FunctionalTableData": """
		MIT License

		Copyright (c) 2017 Shopify

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
		""",
		"Loaf": """
		MIT License

		Copyright (c) 2019 Mat Schmid

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
		"""
	]
}
