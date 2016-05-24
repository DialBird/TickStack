//
//  TimerManager.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class TimerManager: NSObject {
    
    class var sharedInstance: TimerManager {
        struct Singleton {
            static let instance: TimerManager = TimerManager()
        }
        return Singleton.instance
    }
    
    private var timer = NSTimer()
    private var counter: Double = 0
    private var _timerRunning: Bool = false
    let timerInterval: Double = 0.1
    
    //最初の時点での残り時間を記録（update関数で毎回使うため）
    private var originalRestSecond: Int!
    
    dynamic var currentTimeStringInTimerFormat: String!
    dynamic var restTimeStringInTimerFormat: String!
    
    
    
    
    
    //MARK: - getter setter
    var timerRunning: Bool{
        get{
            return _timerRunning
        }
        set(val){
            _timerRunning = val
        }
    }
    
    
    
    
    
    //MARK: - method
    
    //タイマー開始時点での残り時間を保存しておく
    func setOriginalRestSecond(originalRestSecond: Int){
        self.originalRestSecond = originalRestSecond
    }
    
    //タイマーリセット
    func resetCounter(){
        counter = 0
    }
    
    //タイマーに秒数を追加する（バックグラウンドに入った時用）
    func addToTimer(second: Double){
        counter += second
    }
    
    func timerOn()->Void{
        //タイマー開始
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(TimerManager.update), userInfo: nil, repeats: true)
    }
    func timerOff()->Void{
        timer.invalidate()
    }
    
    //タイマーで更新される関数
    func update(){
        //カウンターにインターバル分追加
        counter += timerInterval
        let nowSecond: Int = Int(counter)
        
        //現在の残り時間を計算
        let newRestSecond: Int = originalRestSecond - nowSecond
        
        //経過時間
        let passTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(nowSecond)
        currentTimeStringInTimerFormat = convertTimeIntoString(passTime.hour, minute: passTime.minute, second: passTime.second)
        
        //残り時間
        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(newRestSecond)
        restTimeStringInTimerFormat = convertTimeIntoString(restTime.hour, minute:restTime.minute, second:restTime.second)
    }
    
    //溜まった時間を秒にして返す
    func getStockedSeconds()->Int{
        return Int(counter)
    }
    
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
}
