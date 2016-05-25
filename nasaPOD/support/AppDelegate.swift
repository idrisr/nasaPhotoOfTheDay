//
//  AppDelegate.swift
//  nasaPOD
//
//  Created by id on 5/22/16.
//  Copyright © 2016 id. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var saveDateDelegate: SaveDateDelegate?

    func applicationDidEnterBackground(application: UIApplication) { }
    func applicationWillEnterForeground(application: UIApplication) { }

    func applicationWillTerminate(application: UIApplication) {
        self.saveDateDelegate?.saveDate()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }
}