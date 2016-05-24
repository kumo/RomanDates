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
        guard let shortIdentifier = fullIdentifier.componentsSeparatedByString(".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
    
    var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Fabric.with([Crashlytics.self])
        
        AppConfiguration.sharedConfiguration.runHandlerOnFirstLaunch {
            // do nothing
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        guard AppConfiguration.sharedConfiguration.usePasteboard else {
            return
        }
        
        guard let _ = UIPasteboard.generalPasteboard().string else {
                //print("There isn't a number of anything in pasteboard")
                return
        }
        
        //print("There is a number in the pasteboard: \(currentPasteboardContents)")
        NSNotificationCenter.defaultCenter().postNotificationName("NewPasteboard", object: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
                                                  completionHandler: (Bool) -> Void) {
        
        completionHandler(handleShortcut(shortcutItem))
    }
    
    @available(iOS 9.0, *)
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutItem = ShortcutItemType(fullIdentifier: shortcutType) else {
            return false
        }
        
        var text = ""
        
        if shortcutItem == ShortcutItemType.ConvertPasteboard {
            if  let currentPasteboardContents = UIPasteboard.generalPasteboard().string,
                let _ = Int(currentPasteboardContents) {
                text = currentPasteboardContents
            }
        }
        
        if let window = self.window, rvc = window.rootViewController,
            mvc = rvc.childViewControllers.first as? MainViewController {
            // TODO: restore the date
            //mvc.restoreDate(text)
        }
        
        return true
    }
    
    @available(iOS 8.0, *)
    func application(application: UIApplication,
                     continueUserActivity userActivity: NSUserActivity,
                                          restorationHandler: (([AnyObject]?) -> Void))
        -> Bool {
            //let userInfo = userActivity.userInfo
            //print("Received a payload via handoff: \(userInfo)")
            
            if let window = self.window, rvc = window.rootViewController {
                rvc.childViewControllers.first?.restoreUserActivityState(userActivity)
            }
            
            return true
    }
    
}
