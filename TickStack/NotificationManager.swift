//
//  NotificationManager.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

//class NotificationManager: NSObject {
//
//    func setNotification(
//        fireDate fireDate: NSDate? = nil,
//            timeZone: NSTimeZone? = nil,
//            repeatInterval: NSCalendarUnit = NSCalendarUnit.init(rawValue: 0),
//            repeatCalendar: NSCalendar? = nil,
//            alertAction: String? = nil,
//            alertBody: String? = nil,
//            alertTitle: String? = nil,
//            hasAction: Bool = true,
//            applicationIconBadgeNumber: Int = 0,
//            soundName: String? = nil,
//            userInfo: NSDictionary? = nil){
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//        
//        let localNotification = UILocalNotification.init()
//        localNotification.fireDate = fireDate
//        localNotification.timeZone = timeZone
//        localNotification.repeatInterval = repeatInterval
//        localNotification.repeatCalendar = repeatCalendar
//        localNotification.alertAction = alertAction
//        localNotification.alertBody = alertBody
//        localNotification.alertTitle = alertTitle
//        localNotification.hasAction = hasAction
//        localNotification.applicationIconBadgeNumber = applicationIconBadgeNumber
//        localNotification.soundName = soundName
//        if let info = userInfo {
//            localNotification.userInfo = info as [NSObject : AnyObject]
//        }
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//    }
//}
