//
//  test.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//
//実装すべき処理
/*
 １、渡されたデータをcellの情報に格納する
 ２、日にちが変わった際、渡されたデータを確認し、達成できていればTaskDataSourceの達成できた日に1を追加する
 ３、2の工程が終わった後、データをリセットする（時間関係）
 */

import UIKit
import RealmSwift

class TaskCell: UITableViewCell {
    
    //キャッシュ
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskRestTimeLabel: UILabel!
    
    //最初からあった関数------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //渡されたデータをセットする------------------------------------------------------
    func setCell(taskData: TaskCellData){
        //タスク名を表示
        taskNameLabel.text = taskData.taskName
        //タスクの残り時間を表示
        let time:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(taskData.getRestTime())
        taskRestTimeLabel.text = convertTimeIntoString(time.hour, minute: time.minute, second: time.second)
    }
    
    //日にちが変わった時に起動------------------------------------------------------
    func changeDate(taskData: TaskCellData){
        
        //realmインスタンス
        let realm = try! Realm()
        
        //もし達成できた場合は、対応するtaskDataSource情報を呼び出して達成日数に１を追加する
        if taskData.isCompleted(){
            let target: TaskDataSource = realm.objects(TaskDataSource).filter("taskName == '\(taskData.taskName)'").first!
            try! realm.write({
                target.numOfSuccess += 1
            })
        }
        
        //TaskCellDataに溜まった秒数をリセットする
        taskData.todayTimeStock = 0
    }
    
}
