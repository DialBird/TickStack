//
//  TaskCellData.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import Foundation
import RealmSwift

//タスク情報を格納するクラス
class TaskCellData: Object{
    
    //タスクの名前
    dynamic var taskName: String = ""
    
    //タスクの目標ゴール時間
    dynamic var taskGoalMinute: Int = 0
    
    //目標ゴール時刻を秒に換算して返す
    func getTaskGoalSecond()->Int{
        if taskGoalMinute == 1 {return 10}
        return taskGoalMinute*60
    }
    
    //現在溜まっている今日１日の時間
    dynamic var todaySecondStock: Int = 0
    
    //目標達成までの残り時間を返す
    func getRestSecond()->Int{
        let restTime: Int = max(getTaskGoalSecond() - todaySecondStock, 0)
        return restTime
    }
    
    //現在の達成率を返す
//    func getPercent() -> Int{
//        let percent: Float = Float(todayTimeStock)*100/Float(getTaskGoalSecond())
//        return Int(percent)
//    }
    
    //今日の目標を達成したかを返す
    func isCompleted()->Bool{
        if getTaskGoalSecond() <= todaySecondStock{
            return true
        }else{
            return false
        }
    }
}


//まとめておくリスト------------------------------------------------------

class TaskCellDataList: Object{
    let list = List<TaskCellData>()
}





