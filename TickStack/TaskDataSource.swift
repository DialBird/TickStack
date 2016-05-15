//
//  TaskDataSource.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/09.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

//実装すべき処理
/*
 1, このタスクを登録した日、ためた時間、成功した日数を保存しておく

 */

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
    
    //始めた日からから何日かを返す関数
    func getHowManyDaysHavePassed()->Int{
        return 0
    }
}

class TaskDataSourceList: Object{
    let list = List<TaskDataSource>()
}