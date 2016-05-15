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
    dynamic var taskGoalMinute = 0
    
    //目標ゴール時刻を秒に換算して返す
    func getTaskGoalSecond()->Int{
        return taskGoalMinute*60
    }
    
    //現在溜まっている今日１日の時間
    dynamic var todayTimeStock: Int = 0
    
    //目標達成までの残り時間を返す
    func getRestTime()->Int{
        let restTime: Int = max(getTaskGoalSecond() - todayTimeStock, 0)
        return restTime
    }
    
    //現在の達成率を返す
//    func getPercent() -> Int{
//        let percent: Float = Float(todayTimeStock)*100/Float(getTaskGoalSecond())
//        return Int(percent)
//    }
    
    //今日の目標を達成したかを返す
    func isCompleted()->Bool{
        if getTaskGoalSecond() <= todayTimeStock{
            return true
        }else{
            return false
        }
    }
    
    //秒数を
//    func convertSecondIntoTime(second: Int) -> (hour: Int, minute: Int, second: Int){
//        if second <= 0 {return (0,0,0)}
//        let hour: Int = second/3600
//        let minute: Int = (second - hour*3600)/60
//        let second: Int = second - hour*3600 - minute*60
//        return (hour,minute,second)
//    }
}


//まとめておくリスト------------------------------------------------------

class TaskCellDataList: Object{
    let list = List<TaskCellData>()
}





