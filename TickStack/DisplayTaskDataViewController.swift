//
//  DisplayTaskDataViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/13.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class DisplayTaskDataViewController: UIViewController {
    
    //前のページから渡ってくるインデックス
    var selectedTaskIndex: Int!
    
    //UIキャッシュ
    @IBOutlet weak var totalStockedTimeTextLavel: UILabel!
    @IBOutlet weak var firstDateTextLabel: UILabel!
    @IBOutlet weak var totalDevoteDateTextLabel: UILabel!
    @IBOutlet weak var totalSuccessDateTextLabel: UILabel!
    
    //モデルの格納
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    var dayChangeManager = DayChangeManager.sharedInstance
    var timerManager = TimerManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskDataSource = taskDataSourceManager.taskDataSourceList.list[selectedTaskIndex]
        
        //タイトルを変更
        self.title = "\(taskDataSource.taskName)のデータ"
        
        //そう累計時間
        let time = timerManager.convertSecondIntoTime(taskDataSource.stockedTime)
        totalStockedTimeTextLavel.text = "\(time.hour)時間\(time.minute)分\(time.second)秒"
        
        //開始日
        firstDateTextLabel.text = dayChangeManager.convertNSDateIntoCalenderString(taskDataSource.firstDay)
        
        //タスクに捧げた時間
        totalDevoteDateTextLabel.text = "\(taskDataSource.numOfPassedDate)日"
        
        //目標通り達成できた日数
        totalSuccessDateTextLabel.text = "\(taskDataSource.numOfSuccess)日"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}