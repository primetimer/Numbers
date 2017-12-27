//
//  AppDelegate.swift
//  Numbers
//
//  Created by Stephan Jancar on 03.12.17.
//  Copyright © 2017 Stephan Jancar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var nav : UINavigationController?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		let mainvc = MainViewController()
		//self.window = UIWindow(frame: UIScreen.main.bounds)
		nav = UINavigationController(rootViewController: mainvc)
		//let mainView = MainViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
	
		nav!.viewControllers = [mainvc]
		
		self.window!.rootViewController = nav
		self.window?.makeKeyAndVisible()
		
		#if false
			let d = DyckWord(n: 4)
			for i in 0...10 {
				let x = d.CreateRandom()
				print(d.bitString(x: x))
			}
		#endif
		#if false
			let d = DyckWord(n: 4)
			d.compute()
			print(d)
			//1:00001111,
			//2:00010111,
			//3:00011011,
			//4:00011101,
			//5: 00100111,
			//6: 00101011,
			//7: 00101101,00110011, 00110101, 01000111, 01001011, 01001101, 01010011, 01010101
		#endif

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

