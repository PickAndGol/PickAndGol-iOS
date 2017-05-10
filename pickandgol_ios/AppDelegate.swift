//
//  AppDelegate.swift
//  pickandgol_ios
//
//  Created by Antonio Benavente del Moral on 23/2/17.
//  Copyright © 2017 pickandgol. All rights reserved.
//

import UIKit
import AWSS3
import RealmSwift


//import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    // Delete in production
    
    
    
    
    let notificactionManagerWithFireBase = NoficationManagerWithFireBase()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        _ = CurrentPositionUser.sharedInstance
        FIRApp.configure()
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        connectToFcm()
        deleteRealmFile()
        //notificactionManagerWithFireBase.registerNotification(application)
        //FIRApp.configure()
        //notificactionManagerWithFireBase.observingNotification()
        
       
        return true
    }
    
    /*func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken) \(String(describing: FIRInstanceID.instanceID().token()))" )
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    private func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if (application.isRegisteredForRemoteNotifications) {
            notificactionManagerWithFireBase.registerNotification(application)
        }
    }
    
    [START connect_on_active]
    func applicationDidBecomeActive(_ application: UIApplication) {
        notificactionManagerWithFireBase.connectToFcm()
    }
    // [END connect_on_active]
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        //FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]*/
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Register the device token with a webservice
        print("Token \(deviceToken)")
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Process Token \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error \(error)")
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func deleteRealmFile(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
            }
        }

    }
    
}

