//
//  TimerStartViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//
//ここで実装すべき処理
/*
 １、タイマーを起動し、ポーズ、リスタート、取り消して戻る、登録のボタンを作る
 ２、このtaskの名前から、realmを呼び出し、taskDataSourceを取得する
 ３、このtaskの名前から、特定のtaskCellDataを呼び出し、taskCellDataに秒を格納する
 ４、これら二つのオブジェクトに対し、ボタンを押した時に更新する
 */

import UIKit
import RealmSwift

class TimerViewController: UIViewController {

    //UIパーツをキャッシュ
    @IBOutlet weak var currentTimerLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    
    //前のページから渡ってくるタスクのインデックス
    var selectedTaskIndex: Int!
    
    //タスクデータを上のインデックスから取得して格納する
    var taskData: TaskCellData!
    
    //タイマーの軌道に必要な変数
    var timer = NSTimer()
    var timerRunning: Bool = false
    var counter: Float = 0
    
    //バックグラウンドに入った場合にその瞬間の時間が記録される
    var lastMoment: NSDate?

    
    //最初に実行する関数------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
//        taskData = taskCellDataList.list[selectedTaskIndex]
        
        //前のページから来た情報を使ってページを初期化
        //task名を記載
//        self.title = taskData.taskName
        
        
        //残り時間の表示
//        let restSecond: Int = taskData.getRestSecond()
//        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(restSecond)
//        restTimeLabel.text = convertTimeIntoString(restTime.hour, minute: restTime.minute, second: restTime.second)
        
        //ボタンの修飾
        finishBtn.layer.borderWidth = 2
        finishBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        finishBtn.layer.cornerRadius = finishBtn.bounds.height/2
        
        testBtn.layer.borderWidth = 2
        testBtn.layer.borderColor = UIColor.getStrongPink().CGColor
        testBtn.layer.cornerRadius = testBtn.bounds.width/2
        testBtn.imageView?.image = UIImage(named: "pauseBtn")
        
        //バックグラウンドに入ったか、バックグラウンドから戻ったかの通知を受け取る(タイマーはバックグラウンドでも勝手に動いてくれる？)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterBackground), name: "applicationWillResignActive", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.enterForeground), name: "applicationDidBecomeActive", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    override func viewWillAppear(animated: Bool) {
//        //タイマーを開始
//        timerRunning = true
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TimerViewController.update), userInfo: nil, repeats: true)
//    }
//    override func viewWillDisappear(animated: Bool) {
//        //タイマーを停止
//        timerRunning = false
//        timer.invalidate()
//    }
//    
//    func enterBackground()->Void{
//        print("enter")
//        if timerRunning{
//            lastMoment = NSDate()
//        }
//    }
//    
//    func enterForeground()->Void{
//        if let lastMoment = lastMoment{
//            print(NSDate().timeIntervalSinceDate(lastMoment))
//            self.lastMoment = nil
//        }
//    }
//    
//    //タイマーで更新される関数------------------------------------------------------
//    func update(){
//        counter += 0.1
//        let nowSecond: Int = Int(counter)
//       
//        let newRestSecond: Int = taskData.getRestSecond() - nowSecond
//
//        //経過時間
//        let passTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(nowSecond)
//        currentTimerLabel.text = convertTimeIntoString(passTime.hour, minute: passTime.minute, second: passTime.second)
//        
//        //残り時間
//        let restTime:(hour: Int, minute: Int, second: Int) = convertSecondIntoTime(newRestSecond)
//        restTimeLabel.text = convertTimeIntoString(restTime.hour, minute:restTime.minute, second:restTime.second)
//    }
//    
//    
//    //ボタンイベント------------------------------------------------------
//    @IBAction func tapDownFinishBtn(sender: UIButton) {
//        finishBtn.backgroundColor = UIColor.getMainGreen()
//    }
//    @IBAction func tapUpFinishBtn(sender: UIButton) {
//        finishBtn.backgroundColor = UIColor.clearColor()
//        if timerRunning{
//            timerRunning = false
//            timer.invalidate()
//            playPauseBtn.setImage(UIImage(named: "playButton"), forState: .Normal)
//        }else{
//            timerRunning = true
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TimerViewController.update), userInfo: nil, repeats: true)
//            playPauseBtn.setImage(UIImage(named: "pauseButton"), forState: .Normal)
//        }
//    }
//    
//    //画面遷移------------------------------------------------------
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "backToTaskListFromTimerSegue"{
//            //時間を更新する
//            try! realm.write({
//                //変更を読み込ませるためには、直接dynamicないの変数に記載する必要があり？
//                taskData.todaySecondStock += Int(counter)
//                
//                //データソースの方にも追加
//                let taskDataSource = taskDataSourceList.list[selectedTaskIndex]
//                taskDataSource.stockedTime += Int(counter)
//            })
//        }
//    }
}



