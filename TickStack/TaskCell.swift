//
//  test.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//


import UIKit
import RealmSwift

class TaskCell: UITableViewCell {
    
    //キャッシュ
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskRestTimeLabel: UILabel!
    @IBOutlet weak var clearIconImageView: UIImageView!
    
    
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
        
        //目標達成したタスクとしていないタスクで表示を変える
        if taskData.isCompleted(){
            taskRestTimeLabel.text = "本日の目標達成！"
            clearIconImageView.alpha = 1
        }else{
            let time:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(taskData.getRestSecond())
            taskRestTimeLabel.text = "残り　\(convertTimeIntoString(time.hour, minute: time.minute, second: time.second))"
            clearIconImageView.alpha = 0
        }
    }
    
    
    //日にちが変わった時に起動------------------------------------------------------
    func clearCell(taskData: TaskCellData){
        
        let taskIndex: Int = taskCellDataList.list.indexOf(taskData)!
        let taskDataSource: TaskDataSource = taskDataSourceList.list[taskIndex]
        
        //もし達成できた場合は、対応するtaskDataSource情報を呼び出して達成日数に１を追加する
        if taskData.isCompleted(){
            try! realm.write({
                taskDataSource.numOfSuccess += 1
            })
        }
        
        //もし当日時間を少しでもためていたら、捧げた日数に１を追加する
        if taskData.todaySecondStock > 0{
            try! realm.write({
                taskDataSource.numOfPassedDate += 1
            })
        }
        
        //TaskCellDataに溜まった秒数をリセットする
        try! realm.write({
            taskData.todaySecondStock = 0
        })
        
    }
    
}
