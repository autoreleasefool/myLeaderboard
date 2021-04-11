//
//  Debouncer.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2021-04-10.
//  Copyright © 2021 Joseph Roque. All rights reserved.
//

import Foundation

class Debouncer {
	private let debounceTime: TimeInterval

	private var callable: (() -> Void)?
	private var timer: Timer?
	private let timerLock = NSLock()

	init(debounceTime: TimeInterval) {
		self.debounceTime = debounceTime
	}

	func debounce(callable: @escaping () -> Void) {
		cancel()

		timerLock.lock()
		defer { timerLock.unlock() }

		self.callable = callable
		timer = Timer.scheduledTimer(
			timeInterval: debounceTime,
			target: self,
			selector: #selector(fired),
			userInfo: nil,
			repeats: false
		)
	}

	func cancel() {
		timerLock.lock()
		defer { timerLock.unlock() }

		timer?.invalidate()
		timer = nil
		callable = nil
	}

	@objc private func fired() {
		callable?()
	}
}
