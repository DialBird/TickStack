//
//  TaskCellDataManager.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class TaskCellDataManager: NSObject {
    
    class var sharedInstance: TaskCellDataManager {
        struct Singleton {
            static let instance: TaskCellDataManager = TaskCellDataManager()
        }
        return Singleton.instance
    }
    
    //realmインスタンス作成
    let realm = try! Realm()
    
    //スレッドで共有するtaskCellDataのリスト
    dynamic var taskCellDataList = TaskCellDataList()
    
    //Mark: - method
    
    //もしも前に保存してあったタスクリストデータがあればそれを利用する
    func checkStoredDataExists(){
        if let stockedData = realm.objects(TaskCellDataList).first{
            taskCellDataList = stockedData
        }else{
            try! realm.write({
                realm.add(taskCellDataList)
            })
        }
    }
    
    //taskCellDataListに追加する
    func add(newTaskName: String, newTaskGoalMinute: Int){
        try! realm.write({
            let newTaskCellData = TaskCellData()
            newTaskCellData.taskName = newTaskName
            newTaskCellData.taskGoalMinute = newTaskGoalMinute
            taskCellDataList.list.append(newTaskCellData)
        })
    }
    
    //taskCellDataListを並べ替える
    func changeOrder(sourceIndex: Int, destIndex: Int){
        
        try! realm.write({
            let target: TaskCellData = taskCellDataList.list[sourceIndex]
            taskCellDataList.list.removeAtIndex(sourceIndex)
            taskCellDataList.list.insert(target, atIndex: destIndex)
        })
    }
    
    //taskCellDataListを編集する
    func edit(index: Int, newTaskName: String, newTaskGoalMinute: Int){
        try! realm.write({
            let targetTask = taskCellDataList.list[index]
            targetTask.taskName = newTaskName
            targetTask.taskGoalMinute = newTaskGoalMinute
        })
    }
    
    //taskCellDataListから削除する
    func deleteElement(index: Int){
        try! realm.write({
            taskCellDataList.list.removeAtIndex(index)
        })
        NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil)
    }
    
    //taskCellDataListをリセットする（日にちが変わった時に発動）
    func clearTaskCellDataList(){
        let taskDataSourceManager = TaskDataSourceManager.sharedInstance
        taskCellDataList.list.enumerate().forEach{(index: Int, taskCellData: TaskCellData) in
            
            //このタスクに対応するtaskDataSourceを取り出す
            let taskDataSource: TaskDataSource = taskDataSourceManager.taskDataSourceList.list[index]
            
            //もし１日のタスクを達成できた場合は、対応するtaskDataSource情報の達成日数に１を追加する
            if taskCellData.isCompleted(){
                try! realm.write({
                    taskDataSource.numOfSuccess += 1
                })
            }
            
            //もし時間を少しでもためていたら、捧げた日数に１を追加する
            if taskCellData.todaySecondStock > 0{
                try! realm.write({
                    taskDataSource.numOfPassedDate += 1
                })
            }
            
            //TaskCellDataに溜まった秒数をリセットする
            try! realm.write({
                taskCellData.todaySecondStock = 0
            })
        }
    }
    
    //指定されたタスクに時間を貯める
    func stockTimeToSpecificTask(index: Int, stockSeconds: Int){
        try! realm.write({
            //変更を読み込ませるためには、直接dynamicないの変数に記載する必要があり？
            taskCellDataList.list[index].todaySecondStock += stockSeconds
        })
    }
    
}