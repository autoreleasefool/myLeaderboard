//
//  AppDelegate.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		Theme.apply()

		let window = UIWindow(frame: UIScreen.main.bounds)
		let rootViewController = UIViewController() // RootTabBarController()
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = Theme.interfaceStyle
		self.window = window

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) { }
	func applicationDidEnterBackground(_ application: UIApplication) { }
	func applicationWillEnterForeground(_ application: UIApplication) { }
	func applicationDidBecomeActive(_ application: UIApplication) { }
	func applicationWillTerminate(_ application: UIApplication) { }

	func application(
		_ app: UIApplication,
		open url: URL,
		options: [UIApplication.OpenURLOptionsKey: Any] = [:]
	) -> Bool {
		guard let route = Route(from: url),
			let routeHandler = window?.rootViewController as? RouteHandler else { return false }

		routeHandler.openRoute(route)
		return true
	}
}
