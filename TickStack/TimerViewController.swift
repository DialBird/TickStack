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
    
    //このタイマーを開始する前の時点での残り時間（update関数を発動するたびにこの値を必要とするから）
    var originalRestSecond: Int!
    
    //タイマーの軌道に必要な変数
    var timer = NSTimer()
    var timerRunning: Bool = false
    var counter: Double = 0
    let timerInterval: Double = 0.1
    
    //バックグラウンドに入った場合にその瞬間の時間が記録される
    var lastMoment: NSDate?
    
    //Modelを格納
    var taskCellDataManager = TaskCellDataManager.sharedInstance
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskCellData: TaskCellData = taskCellDataManager.taskCellDataList.list[selectedTaskIndex]
        
        //前のページから来た情報を使ってページを初期化
        //task名を記載
        taskNameTextLabel.text = taskCellData.taskName
        
        //残り時間の表示
        originalRestSecond = taskCellData.getRestSecond()
        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(originalRestSecond)
        restTimeLabel.text = convertTimeIntoString(restTime.hour, minute: restTime.minute, second: restTime.second)
        
        //ボタンの修飾
        playPauseBtn.layer.cornerRadius = playPauseBtn.bounds.width/2
        playPauseBtn.layer.borderWidth = 2
        playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
        playPauseBtn.imageView?.image = UIImage(named: "Pause Filled-50")
        
        finishBtn.layer.borderWidth = 2
        finishBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        finishBtn.layer.cornerRadius = finishBtn.bounds.height/2
        
        //ナビゲーションバーの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //画面のライフサイクル関係------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        timerOn()
        
        //バックグラウンドに入ったか、バックグラウンドから戻ったかの通知を受け取る(タイマーはバックグラウンドでも勝手に動いてくれる？)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterBackground), name: "applicationWillResignActive", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterForeground), name: "applicationDidBecomeActive", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        timerOff()
        
        //通知オブサーバーを削除
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //タイマー発動中にバックグラウンドに入った場合の処理------------------------------------------------------
    func enterBackground()->Void{
        if timerRunning{
            timerOff()
            lastMoment = NSDate()
        }
    }
    
    func enterForeground()->Void{
        if let lastMoment = lastMoment{
            let secondsSinceLastMoment: Double = NSDate().timeIntervalSinceDate(lastMoment)
            counter += secondsSinceLastMoment
            timerOn()
            self.lastMoment = nil
        }
    }
    
    
    //タイマーをオン、オフする関数------------------------------------------------------
    func timerOn()->Void{
        timerRunning = true
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(TimerViewController.update), userInfo: nil, repeats: true)
    }
    func timerOff()->Void{
        timerRunning = false
        timer.invalidate()
    }
    
    //タイマーで更新される関数------------------------------------------------------
    func update(){
        
        //カウンターにインターバル分追加
        counter += timerInterval
        let nowSecond: Int = Int(counter)
        
        //現在の残り時間を計算
        let newRestSecond: Int = originalRestSecond - nowSecond
        
        //経過時間
        let passTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(nowSecond)
        currentTimerLabel.text = convertTimeIntoString(passTime.hour, minute: passTime.minute, second: passTime.second)
        
        //残り時間
        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(newRestSecond)
        restTimeLabel.text = convertTimeIntoString(restTime.hour, minute:restTime.minute, second:restTime.second)
    }
    
    
    //ボタンイベント------------------------------------------------------
    @IBAction func tapDownPlayPauseBtn(sender: UIButton) {}
    @IBAction func tapUpPlayPauseBtn(sender: UIButton) {
        if timerRunning{
            timerOff()
            playPauseBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
            playPauseBtn.setImage(UIImage(named: "Play Filled-50"), forState: .Normal)
        }else{
            timerOn()
            playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
            playPauseBtn.setImage(UIImage(named: "Pause Filled-50"), forState: .Normal)
        }
    }
    
    
    @IBAction func tapDownFinishBtn(sender: UIButton) {
        finishBtn.backgroundColor = UIColor.getMainGreen()
    }
    @IBAction func tapUpFinishBtn(sender: UIButton) {
        finishBtn.backgroundColor = UIColor.clearColor()
    }
    
    //画面遷移------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromTimerSegue"{
            //時間を更新する
            taskCellDataManager.stockTimeToSpecificTask(selectedTaskIndex, stockSeconds: Int(counter))
            taskDataSourceManager.stockTimeToSpecificTask(selectedTaskIndex, stockSeconds: Int(counter))
        }
    }
}



