//
//  AppDelegate.swift
//  RomanDates
//
//  Created by Robert Clarke on 22/05/2016.
//
//

import UIKit
import Fabric
import Crashlytics

enum ShortcutItemType: String {
    case ConvertToday
    case ConvertYesterday
    case ConvertTomorrow
    case ConvertPasteboard
    
    init?(fullIdentifier: String) {
        guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
    
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Fabric.with([Crashlytics.self])
        
        AppConfiguration.sharedConfiguration.runHandlerOnFirstLaunch {
            // do nothing
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        guard AppConfiguration.sharedConfiguration.usePasteboard else {
            return
        }

        let changeCount = UIPasteboard.general.changeCount;

        //print("Change count is: ", changeCount);
        
        guard let _ = UIPasteboard.general.string else {
                //print("There isn't a string in the pasteboard")
                return
        }

        // let's just assume that if the count is different, then we can use it
        if changeCount != AppConfiguration.sharedConfiguration.pasteboardChangeCount {
            //print("Using pasteboard")
            AppConfiguration.sharedConfiguration.pasteboardChangeCount = changeCount
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NewPasteboard"), object: nil)
        } else {
            //print("Ignoring pasteboard")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                                                  completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleShortcut(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    fileprivate func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutItem = ShortcutItemType(fullIdentifier: shortcutType) else {
            return false
        }
        
        //var text = ""
        
        /*if shortcutItem == ShortcutItemType.ConvertPasteboard {
            if  let currentPasteboardContents = UIPasteboard.generalPasteboard().string,
                let _ = Int(currentPasteboardContents) {
                text = currentPasteboardContents
            }
        }*/
        
        if let window = self.window, let rvc = window.rootViewController,
            let mvc = rvc.childViewControllers.first as? MainViewController {
            // TODO: restore the date
            //mvc.restoreDate(text)
            mvc.handleShortcut(shortcutItem)
        }
        
        return true
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
            //let userInfo = userActivity.userInfo
            //print("Received a payload via handoff: \(userInfo)")
            
            if let window = self.window, let rvc = window.rootViewController {
                rvc.childViewControllers.first?.restoreUserActivityState(userActivity)
            }
            
            return true
    }
    
}
