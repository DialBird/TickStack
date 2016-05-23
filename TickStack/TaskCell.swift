//
//  test.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//


import UIKit

class TaskCell: UITableViewCell {
    
    //キャッシュ
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskRestTimeLabel: UILabel!
    @IBOutlet weak var clearIconImageView: UIImageView!
    
    //modelの格納
    var timerManager = TimerManager.sharedInstance
    
    
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
            let time:(hour: Int, minute: Int, second: Int) = timerManager.convertSecondIntoTime(taskData.getRestSecond())
            taskRestTimeLabel.text = "残り　\(timerManager.convertTimeIntoString(time.hour, minute: time.minute, second: time.second))"
            clearIconImageView.alpha = 0
        }
    }
}
