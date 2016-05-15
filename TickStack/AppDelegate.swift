//
//  AppDelegate.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

//realmオブジェクト生成
let realm = try! Realm()

//スレッドで共有するタスクリストデータ
var taskCellDataList = TaskCellDataList()
var taskDataSourceList = TaskDataSourceList()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //もしすでにtaskCellDataListが入っていたらそれを使う
//        if let stockedData = realm.objects(TaskCellDataList).first{
//            taskCellDataList = stockedData
//        }else{
//            try! realm.write({
//                realm.add(taskCellDataList)
//            })
//        }
//        
//        if let stockedTaskDataSourceList = realm.objects(TaskDataSourceList).first{
//            taskDataSourceList = stockedTaskDataSourceList
//        }else{
//            try! realm.write({
//                realm.add(taskDataSourceList)
//            })
//        }
        
        //realmをリセットする関数
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.URLByAppendingPathExtension("lock"),
            realmURL.URLByAppendingPathExtension("log_a"),
            realmURL.URLByAppendingPathExtension("log_b"),
            realmURL.URLByAppendingPathExtension("note")
        ]
        let manager = NSFileManager.defaultManager()
        for URL in realmURLs {
            do {
                try manager.removeItemAtURL(URL)
            } catch {
                // handle error
            }
        }
        try! realm.write({
            realm.deleteAll()
        })
        
        
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//共用関数------------------------------------------------------


//秒から時間と分へと換算する
func convertSecondIntoTime(second: Int) -> (hour: Int, minute: Int, second: Int){
    if second <= 0 {return (0,0,0)}
    let hour: Int = second/3600
    let minute: Int = (second - hour*3600)/60
    let second: Int = second - hour*3600 - minute*60
    return (hour,minute,second)
}

//時間をタイマー風のフォーマットにして返す
func convertTimeIntoString(hour: Int, minute: Int, second: Int)->String{
    return "\(String(format: "%02d",hour)):\(String(format: "%02d",minute)):\(String(format: "%02d",second))"
}

//NSDateを年月日に変更して文字列にする
func convertNSDateIntoCalender(date: NSDate)->String{
    let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    let year: Int = cal!.component(.Year, fromDate: date)
    let month: Int = cal!.component(.Month, fromDate: date)
    let day: Int = cal!.component(.Day, fromDate: date)
    return "\(year)年\(month)月\(day)日"
}

//NSDateから日数さを割り出す
func getDayGap(firstDate: NSDate, nowDate: NSDate)->Int{
    let span = nowDate.timeIntervalSinceDate(firstDate)
    return Int(span/60/60/24)
}


