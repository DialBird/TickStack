//
//  TaskDataSourceManager.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class TaskDataSourceManager: NSObject {
    
    class var sharedInstance: TaskDataSourceManager {
        struct Singleton {
            static let instance: TaskDataSourceManager = TaskDataSourceManager()
        }
        return Singleton.instance
    }
    
    //realmインスタンス作成
    let realm = try! Realm()
    
    //スレッドで共有するtaskDataSourceのリスト
    dynamic var taskDataSourceList = TaskDataSourceList()
    
    //Mark: - method
    
    //もしも前に保存してあったタスクリストデータがあればそれを利用する
    func checkStoredDataExists(){
        if let stockedTaskDataSourceList = realm.objects(TaskDataSourceList).first{
            taskDataSourceList = stockedTaskDataSourceList
        }else{
            try! realm.write({
                realm.add(taskDataSourceList)
            })
        }
    }
    
    //taskDataSourceListに追加する
    func add(newTaskName: String, firstDate: NSDate){
        try! realm.write({
            let newTaskDataSource = TaskDataSource()
            newTaskDataSource.taskName = newTaskName
            newTaskDataSource.firstDay = firstDate
            taskDataSourceList.list.append(newTaskDataSource)
        })
    }
    
    //taskDataSourceListを並べ替える
    func changeOrder(sourceIndex: Int, destIndex: Int){
        
        try! realm.write({
            let target: TaskDataSource = taskDataSourceList.list[sourceIndex]
            try! realm.write({
                taskDataSourceList.list.removeAtIndex(sourceIndex)
                taskDataSourceList.list.insert(target, atIndex: destIndex)
            })
        })
    }
    
    //taskDataSourceListを編集する
    func edit(index: Int, newTaskName: String){
        try! realm.write({
            let targetTask = taskDataSourceList.list[index]
            targetTask.taskName = newTaskName
        })
    }
    
    //taskDataSourceListから削除する
    func deleteElement(index: Int){
        try! realm.write({
            taskDataSourceList.list.removeAtIndex(index)
        })
    }
    
    //指定されたタスクに時間を貯める
    func stockTimeToSpecificTask(index: Int, stockSeconds: Int){
        try! realm.write({
            taskDataSourceList.list[index].stockedTime += stockSeconds
        })
    }
}
