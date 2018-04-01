//
//  AppDelegate.swift
//  coreDataCacao1987
//
//  Created by Rudi Krämer on 29.03.18.
//  Copyright © 2018 Rudi Krämer. All rights reserved.
//

import UIKit
import CoreData
import CloudCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let delegateHandler = CloudCoreDelegateHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        CloudCore
        // Register for push notifications about changes
        application.registerForRemoteNotifications()
        
        // Enable CloudCore syncing
        CloudCore.delegate = delegateHandler
        CloudCore.enable(persistentContainer: persistenceService.persistentContainer)
        return true
    }
    
    // Notification from CloudKit about changes in remote database
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Check if it CloudKit's and CloudCore notification
        if CloudCore.isCloudCoreNotification(withUserInfo: userInfo) {
            // Fetch changed data from iCloud
            print("gotChangeNotification")
            CloudCore.fetchAndSave(using: userInfo, to: persistenceService.persistentContainer, error: {
                print("fetchAndSave from didReceiveRemoteNotification error: \($0)")
            }, completion: {
                (fetchResult) in completionHandler(fetchResult.uiBackgroundFetchResult)
                DispatchQueue.main.async {
                    persistenceService.context.reset()
                    
//                    Refresh Core Data in ViewController
                    if let rootViewController = self.window?.rootViewController as? ViewController {
                        rootViewController.getCoreData()
                    }
                    
                }
            })
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        persistenceService.saveContext()
        // Save tokens on exit used to differential sync
        CloudCore.tokens.saveToUserDefaults()

    }


}

