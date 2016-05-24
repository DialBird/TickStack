//
//  AppDelegate.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

//サイズを格納
let screenSize: CGSize = UIScreen.mainScreen().nativeBounds.size
let screenStr: String = "width: \(screenSize.width) height: \(screenSize.height)"
var thisIs4s: Bool = false


//色のエクステンション
extension UIColor{
    class func getMainBlack()->UIColor{
        return UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    }
    class func getMainGreen()->UIColor{
        return UIColor(colorLiteralRed: 129/255, green: 214/255, blue: 116/255, alpha: 1)
    }
    class func getStrongGreen()->UIColor{
        return UIColor(colorLiteralRed: 62/255, green: 186/255, blue: 43/255, alpha: 1)
    }
    class func getStrongPink()->UIColor{
        return UIColor(colorLiteralRed: 180/255, green: 60/255, blue: 136/255, alpha: 1)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //realmをリセットする関数
        //リセットする場合には以下の関数群をオンにする
        //        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        //        let realmURLs = [
        //            realmURL,
        //            realmURL.URLByAppendingPathExtension("lock"),
        //            realmURL.URLByAppendingPathExtension("log_a"),
        //            realmURL.URLByAppendingPathExtension("log_b"),
        //            realmURL.URLByAppendingPathExtension("note")
        //        ]
        //        let manager = NSFileManager.defaultManager()
        //        for URL in realmURLs {
        //            do {
        //                try manager.removeItemAtURL(URL)
        //            } catch {
        //                // handle error
        //            }
        //        }
        //        try! realm.write({
        //            realm.deleteAll()
        //        })
        
        
        //サイズを判定------------------------------------------------------
        //3.5インチだった場合にはレイアウトを変更する
        if (screenSize.width == 640 && screenSize.height == 960){
            thisIs4s = true
        }
        
        
        //もしすでにtaskCellDataList,taskDataSourceListが入っていたらそれを使う
        TaskCellDataManager.sharedInstance.checkStoredDataExists()
        TaskDataSourceManager.sharedInstance.checkStoredDataExists()
        
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification,let userInfo = notification.userInfo{
            application.applicationIconBadgeNumber = 0
            application.cancelLocalNotification(notification)
        }
        //復帰に関係なくバッジが0じゃなければ0にする
        if application.applicationIconBadgeNumber != 0{
            application.applicationIconBadgeNumber = 0
        }
        
        
        //デモ用------------------------------------------------------
        //        try! realm.write({
        //            let task1 = TaskCellData()
        //            task1.taskName = "英語"
        //            task1.taskGoalMinute = 30
        //            task1.todaySecondStock = 11
        //
        //            let task2 = TaskCellData()
        //            task2.taskName = "読書"
        //            task2.taskGoalMinute = 10
        //            task2.todaySecondStock = 5
        //
        //            let task3 = TaskCellData()
        //            task3.taskName = "散歩"
        //            task3.taskGoalMinute = 10
        //            task3.todaySecondStock = 600
        //            taskCellDataList.list.append(task1)
        //            taskCellDataList.list.append(task2)
        //            taskCellDataList.list.append(task3)
        //
        //            let demo = TaskDataSource()
        //            demo.firstDay = NSDate()
        //            demo.taskName = "散歩"
        //            demo.numOfPassedDate = 110
        //            demo.numOfSuccess = 93
        //            demo.stockedTime = 120324
        //            taskDataSourceList.list.append(demo)
        //        })
        
        //スリープモードに入らないようにする
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillResignActive", object: nil)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        application.cancelAllLocalNotifications()
        let notification = UILocalNotification()
        notification.alertAction = "アプリを開く"
        notification.alertBody = "やあけいすけ"
        notification.fireDate = NSDate(timeIntervalSinceNow: 3)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 999999999
        notification.userInfo = ["notifyID": "keisuke"]
//        application.scheduleLocalNotification(notification)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        if application.applicationIconBadgeNumber != 0{
            application.applicationIconBadgeNumber = 0
            print("application\(application.applicationIconBadgeNumber)")
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidBecomeActive", object: nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState != .Active{
            //バッジを０にする
            application.applicationIconBadgeNumber = 0
            //通知領域から削除する
            application.cancelLocalNotification(notification)
        }else{
             //active時に通知が来たときはそのままバッジを0に戻す
            if application.applicationIconBadgeNumber != 0{
                application.applicationIconBadgeNumber = 0
                application.cancelLocalNotification(notification)
            }
        }
    }
}




