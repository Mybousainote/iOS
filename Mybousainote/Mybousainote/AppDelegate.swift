//
//  AppDelegate.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var DBManager: DatabaseManager!
    var LManager: LocationManager!
//    var DIManager: DisasterInformationManager!
    var global: Global!
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        initializeAnalytics()
        createGlobalClass()
        
        //ロギング開始
//        AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
//        AFNetworkActivityLogger.sharedLogger().startLogging()
        
        //GoogleMaps API 認証
        GMSServices.provideAPIKey(Config().googleAPIKey);
        
        //最初の起動画面
        let firstView: UIViewController! = getFirstViewController()
        window?.rootViewController = firstView
        
        //Background fetch
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
    
    func getFirstViewController() -> UIViewController {
        let ud = NSUserDefaults.standardUserDefaults()
        
        //初期値を設定
        let defaults: [String: NSObject] = ["FIRST_LAUNCH": true]
        ud.registerDefaults(defaults)
        
        
        var firstSb: UIStoryboard!
        
        //初回起動かどうかの判定
        if ud.boolForKey("FIRST_LAUNCH") {
            print("初回起動判定：true")
            firstSb = UIStoryboard(name: "Tutorial", bundle: nil)
        }
        else {
            print("初回起動判定：false")
            firstSb = UIStoryboard(name: "Top", bundle: nil)
        }
        return firstSb.instantiateInitialViewController()!
    }
    
    func initializeAnalytics() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
    }
    
    func createGlobalClass() {
        LManager = LocationManager.init()
        DBManager = DatabaseManager.init()
//        DIManager = DisasterInformationManager.init()
        global = Global()
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // ここに処理内容
        print("Background fetch foo")
//        LManager.locationManager.startUpdatingLocation()
        LManager.locationManager.startMonitoringSignificantLocationChanges()
//        DBManager.refreshCityFrequency()
//        DBManager.deleteOldDataFromLocationTable()
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    //バックグラウンド
    func applicationDidEnterBackground(application: UIApplication) {
        print("background!")
    }
    
    //フォアグラウンド
    func applicationWillEnterForeground(application: UIApplication) {
        print("foreground!")
        DBManager.addCityName()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

