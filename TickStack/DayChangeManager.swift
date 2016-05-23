//
//  DayChangeManager.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class DayChangeManager: NSObject {
    
    class var sharedInstance: DayChangeManager {
        struct Singleton {
            static let instance: DayChangeManager = DayChangeManager()
        }
        return Singleton.instance
    }
    
    let realm = try! Realm()
    
    
    //MARK: - method
    
    //もしも前に登録したLastDayオブジェクトがなければ初期化したものを保存する
    func checkStoredDataExists(){
        if realm.objects(LastDay).first == nil{
            try! realm.write({
                let lastDay = LastDay()
                lastDay.date = NSDate()
                realm.add(lastDay)
            })
        }
    }
    
    //日にちが変わっていたらtrueを返す
    func checkDayChange()->Bool{
        let lastDay: LastDay = realm.objects(LastDay).first!
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let sinceLastTimeGap: Double = NSDate().timeIntervalSinceDate(lastDay.date)
        if sinceLastTimeGap > 60*60*24 || cal!.component(.Day, fromDate: lastDay.date) != cal!.component(.Day, fromDate: NSDate()){
            return true
        }else{
            return false
        }
    }
    
    //日付の再登録
    func saveNowMoment(now: NSDate){
        try! realm.write({
            realm.objects(LastDay).first?.date = now
        })
    }
    
}