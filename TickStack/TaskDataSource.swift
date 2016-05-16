//
//  TaskDataSource.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/09.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//


import Foundation
import RealmSwift

class TaskDataSource: Object{
    //task名
    dynamic var taskName: String!
    //開始した日
    dynamic var firstDay: NSDate!
    //ためた総時間(秒)
    dynamic var stockedTime: Int = 0
    //達成できた日数
    dynamic var numOfSuccess: Int = 0
    //経過した日数
    dynamic var numOfPassedDate: Int = 0
}

class TaskDataSourceList: Object{
    let list = List<TaskDataSource>()
}