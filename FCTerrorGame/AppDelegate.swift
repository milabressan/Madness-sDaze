//
//  AppDelegate.swift
//  FCTerrorGame
//
//  Created by Paulo Ricardo Ramos da Rosa on 8/3/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


//      func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
//        //registering for sending user various kinds of notifications
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound|UIUserNotificationType.Alert|UIUserNotificationType.Badge, categories: nil)
//            // Override point for customization after application launch.
//            return true
//    }
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
            
            /* First ask the user if we are allowed to perform local notifications */
            
            return true
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
        
        
    }
    
    func registerNotification(){
        let settings = UIUserNotificationSettings(forTypes: .Alert,categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        let notification = UILocalNotification()
        
        /* Time and timezone settings */
        
        notification.fireDate = NSDate(timeIntervalSinceNow: 14*24*60*60)
        notification.timeZone = NSCalendar.currentCalendar().timeZone
        
        
        let language = NSLocale.preferredLanguages()[0]
        if(language == "pt-BR"){
            notification.alertBody = "Estamos LOUCOS de saudades de você! Venha jogar!"
            
        }
        else{
            notification.alertBody = "We are INSANELY missing you! Come out to play!"
            
        }
        notification.hasAction = true
        notification.alertAction = "Madness's Daze"

        
        /* Badge settings */
        notification.applicationIconBadgeNumber++
        
        /* Schedule the notification */
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().scheduleLocalNotification(notification)


    }
    
    func sharedInstance() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

