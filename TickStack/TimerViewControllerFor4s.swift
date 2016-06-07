//
//  TimerStartViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class TimerViewControllerFor4s: UIViewController {
    
    //UIパーツをキャッシュ
    @IBOutlet weak var taskNameTextLabel: UILabel!
    @IBOutlet weak var currentTimerLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    //前のページから渡ってくるタスクのインデックス
    var selectedTaskIndex: Int!
    
    //timerが動いているかどうか
    var timerRunning: Bool = false
    
    //Modelを格納
    var taskCellDataManager = TaskCellDataManager.sharedInstance
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    var timerManager = TimerManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskCellData: TaskCellData = taskCellDataManager.taskCellDataList.list[selectedTaskIndex]
        
        //前のページから来た情報を使ってページを初期化
        //task名を記載
        taskNameTextLabel.text = taskCellData.taskName
        
        //残り時間の表示
        timerManager.resetCounter()
        timerManager.setOriginalRestSecond(taskCellData.getRestSecond())
        
        //ボタンの修飾
        playPauseBtn.layer.cornerRadius = playPauseBtn.bounds.width/2
        playPauseBtn.layer.borderWidth = 2
        playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
        playPauseBtn.imageView?.image = UIImage(named: "Pause Filled-30")
        
        //ナビゲーションバーの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //MARK: - lifeSycle
    
    override func viewWillAppear(animated: Bool) {
        timerRunning = true
        timerManager.timerOn()
        
        //両方につけておかないと、変わるタイミングがずれてしまう
        timerManager.addObserver(self, forKeyPath: "currentTimeStringInTimerFormat", options: .New, context: nil)
        timerManager.addObserver(self, forKeyPath: "restTimeStringInTimerFormat", options: .New, context: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        timerRunning = false
        timerManager.timerOff()
        
        timerManager.removeObserver(self, forKeyPath: "currentTimeStringInTimerFormat")
        timerManager.removeObserver(self, forKeyPath: "restTimeStringInTimerFormat")
    }
    
    
    
    
    
    //MARK: IBAction
    
    @IBAction func tapUpPlayPauseBtn(sender: UIButton) {
        if timerRunning{
            timerRunning = false
            timerManager.timerOff()
            playPauseBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
            playPauseBtn.setImage(UIImage(named: "Play Filled-30"), forState: .Normal)
        }else{
            timerRunning = true
            timerManager.timerOn()
            playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
            playPauseBtn.setImage(UIImage(named: "Pause Filled-30"), forState: .Normal)
        }
    }
    
    
    
    
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromTimerSegue"{
            //タイマーを停止する
            timerManager.timerOff()
            
            //時間を更新する
            let stockSeconds: Int = timerManager.getStockedSeconds()
            taskCellDataManager.stockTimeToSpecificTask(selectedTaskIndex, stockSeconds: stockSeconds)
            taskDataSourceManager.stockTimeToSpecificTask(selectedTaskIndex, stockSeconds: stockSeconds)
        }
    }
    
    
    
    
    
    //MARK: - Observer
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentTimeStringInTimerFormat"{
            //経過時間を更新
            currentTimerLabel.text = timerManager.currentTimeStringInTimerFormat
        }
        if keyPath == "restTimeStringInTimerFormat"{
            //残り時間を更新
            restTimeLabel.text = timerManager.restTimeStringInTimerFormat
        }
    }
}

