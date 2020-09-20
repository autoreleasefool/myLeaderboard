//
//  PlayRecordedViewController.swift
//  MyLeaderboardAppClip
//
//  Created by Joseph Roque on 2020-06-24.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import UIKit

class PlayRecordedViewController: UIViewController {
	override func viewDidLoad() {
		view.backgroundColor = .primaryDark

		let label = UILabel()
		label.text = "Play recorded! Add another?"
		label.textColor = .text

		let button = UIButton()
		button.setTitle("Add another", for: .normal)
		button.addTarget(self, action: #selector(addAnother), for: .touchUpInside)

		let verticalStackView = UIStackView(arrangedSubviews: [label, button])
		verticalStackView.addArrangedSubview(label)
		verticalStackView.addArrangedSubview(button)
		verticalStackView.axis = .vertical
		verticalStackView.alignment = .center
		verticalStackView.spacing = Metrics.Spacing.standard

		let horizontalStackView = UIStackView(arrangedSubviews: [verticalStackView])
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		horizontalStackView.axis = .horizontal
		horizontalStackView.alignment = .center
		view.addSubview(horizontalStackView)

		NSLayoutConstraint.activate([
			horizontalStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
			horizontalStackView.heightAnchor.constraint(equalTo: view.heightAnchor),
		])
	}

	@objc private func addAnother() {
		self.navigationController?.popToRootViewController(animated: true)
	}
}
