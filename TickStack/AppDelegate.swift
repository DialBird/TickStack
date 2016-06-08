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

//使っているデバイスが4sならばtrue
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
        
        
        //スリープモードに入らないようにする
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillResignActive", object: nil)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("applicationDidBecomeActive", object: nil)
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    }
}




