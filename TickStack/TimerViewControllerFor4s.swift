//
//  TimerStartViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class TimerViewControllerFor4s: UIViewController {
    
    //UIパーツをキャッシュ
    @IBOutlet weak var taskNameTextLabel: UILabel!
    @IBOutlet weak var currentTimerLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    //前のページから渡ってくるタスクのインデックス
    var selectedTaskIndex: Int!
    
    //タスクデータを上のインデックスから取得して格納する
    var taskData: TaskCellData!
    
    //タイマーの軌道に必要な変数
    var timer = NSTimer()
    var timerRunning: Bool = false
    var counter: Double = 0
    
    //バックグラウンドに入った場合にその瞬間の時間が記録される
    var lastMoment: NSDate?
    
    
    //最初に実行する関数------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        taskData = taskCellDataList.list[selectedTaskIndex]
        
        //前のページから来た情報を使ってページを初期化
        //task名を記載
        taskNameTextLabel.text = taskData.taskName
        
        //残り時間の表示
        let restSecond: Int = taskData.getRestSecond()
        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(restSecond)
        restTimeLabel.text = convertTimeIntoString(restTime.hour, minute: restTime.minute, second: restTime.second)
        
        //ボタンの修飾
        playPauseBtn.layer.cornerRadius = playPauseBtn.bounds.width/2
        playPauseBtn.layer.borderWidth = 2
        playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
        playPauseBtn.imageView?.image = UIImage(named: "Pause Filled-30")
        
        finishBtn.layer.borderWidth = 2
        finishBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        finishBtn.layer.cornerRadius = finishBtn.bounds.height/2
        
        //バックグラウンドに入ったか、バックグラウンドから戻ったかの通知を受け取る(タイマーはバックグラウンドでも勝手に動いてくれる？)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterBackground), name: "applicationWillResignActive", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterForeground), name: "applicationDidBecomeActive", object: nil)
        
        //ナビゲーションバーの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //画面のライフサイクル関係------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        timerOn()
    }
    override func viewWillDisappear(animated: Bool) {
        timerOff()
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
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TimerViewController.update), userInfo: nil, repeats: true)
    }
    func timerOff()->Void{
        timerRunning = false
        timer.invalidate()
    }
    
    //タイマーで更新される関数------------------------------------------------------
    func update(){
        counter += 0.1
        let nowSecond: Int = Int(counter)
        
        let newRestSecond: Int = taskData.getRestSecond() - nowSecond
        
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
            playPauseBtn.setImage(UIImage(named: "Play Filled-30"), forState: .Normal)
        }else{
            timerOn()
            playPauseBtn.layer.borderColor = UIColor.getStrongPink().CGColor
            playPauseBtn.setImage(UIImage(named: "Pause Filled-30"), forState: .Normal)
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
            try! realm.write({
                //変更を読み込ませるためには、直接dynamicないの変数に記載する必要があり？
                taskData.todaySecondStock += Int(counter)
                
                //データソースの方にも追加
                let taskDataSource = taskDataSourceList.list[selectedTaskIndex]
                taskDataSource.stockedTime += Int(counter)
            })
        }
    }
}




