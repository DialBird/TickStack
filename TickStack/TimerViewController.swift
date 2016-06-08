//
//  TimerStartViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    //UIパーツをキャッシュ
    @IBOutlet weak var taskNameTextLabel: UILabel!
    @IBOutlet weak var currentTimerLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    //前のページから渡ってくるタスクのインデックス
    var selectedTaskIndex: Int!
    
    //バックグラウンドに入った場合にその瞬間の時間が記録される
    private var lastMoment: NSDate?
    
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
        playPauseBtn.imageView?.image = UIImage(named: "Pause Filled-50")
        
        //ナビゲーションバーの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //MARK: - lifeSycle
    
    override func viewWillAppear(animated: Bool) {
        timerManager.timerRunning = true
        timerManager.timerOn()
        
        //バックグラウンドに入った場合の監視
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterBackground), name: "applicationWillResignActive", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterForeground), name: "applicationDidBecomeActive", object: nil)
        
        //カウンター表示。両方につけておかないと、変わるタイミングがずれてしまう
        timerManager.addObserver(self, forKeyPath: "currentTimeStringInTimerFormat", options: .New, context: nil)
        timerManager.addObserver(self, forKeyPath: "restTimeStringInTimerFormat", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        timerManager.timerRunning = false
        timerManager.timerOff()
        
        //監視解除
        NSNotificationCenter.defaultCenter().removeObserver(self)
        timerManager.removeObserver(self, forKeyPath: "currentTimeStringInTimerFormat")
        timerManager.removeObserver(self, forKeyPath: "restTimeStringInTimerFormat")
    }
    
    
    
    
    
    //MARK: IBAction
    
    @IBAction func tapUpPlayPauseBtn(sender: UIButton) {
        if timerManager.timerRunning{
            timerManager.timerRunning = false
            timerManager.timerOff()
            playPauseBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
            playPauseBtn.setImage(UIImage(named: "Play Filled-50"), forState: .Normal)
        }else{
            timerManager.timerRunning = true
            timerManager.timerOn()
            playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
            playPauseBtn.setImage(UIImage(named: "Pause Filled-50"), forState: .Normal)
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
    
    func enterBackground()->Void{
        if timerManager.timerRunning{
            timerManager.timerOff()
            lastMoment = NSDate()
        }
    }
    
    func enterForeground()->Void{
        if let lastMoment = lastMoment{
            let secondsSinceLastMoment: Double = NSDate().timeIntervalSinceDate(lastMoment)
            timerManager.addToTimer(secondsSinceLastMoment)
            timerManager.timerOn()
            self.lastMoment = nil
        }
    }
    
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



