//
//  FirstViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    //UIのキャッシュ
    @IBOutlet weak var dateTellerTextLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //選択したタスク名を、startTimerViewに送るために格納する
    var selectedTaskIndex: Int!
    
    //現在編集モードかを指定されているか
    var isInEditMode: Bool = false
    
    //日付が変わったかどうか
    var dayChanged: Bool = false
    
    //最初の処理------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewの関連付け
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        //tableView上の空白を埋めるように設定
        self.automaticallyAdjustsScrollViewInsets = false
        
        //ナビゲーションバーの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "タスクが登録されていません"
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(15)]
        return NSAttributedString(string: text, attributes: attr)
    }
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "右上の追加ボタンから追加してください"
        let font: UIFont = UIFont.systemFontOfSize(12)
        return NSAttributedString(string: text, attributes: [NSFontAttributeName : font])
    }
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    
    //繰り返し実行する関数------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        let calendarParts: (year: Int, month: Int, day: Int) = convertNSDateIntoCalenderParts(NSDate())
        let year: Int = calendarParts.year
        let month: Int = calendarParts.month
        let day: Int = calendarParts.day
        dateTellerTextLabel.text = "\(year)/\(month)/\(day)の状況"
        
        //もしも前に登録したLastDayオブジェクトがなければ初期化したものを保存する
        if realm.objects(LastDay).first == nil{
            try! realm.write({
                let lastDay = LastDay()
                lastDay.date = NSDate()
                realm.add(lastDay)
            })
        }
        
        //日にちが変わっていたらdayChangedをtrueにする
        if checkDayChange(){
            dayChanged = true
        }else{
            dayChanged = false
        }
        
        //日付の再登録
        try! realm.write({
            realm.objects(LastDay).first?.date = NSDate()
        })
        
        //テーブルビューの更新
        updateTable()
    }
    
    //日付が変わったかを判定する
    func checkDayChange()->Bool{
        let lastDay: LastDay = realm.objects(LastDay).first!
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let sinceLastTimeGap: Double = NSDate().timeIntervalSinceDate(lastDay.date)
        if sinceLastTimeGap > 60*60*24 || cal!.component(.Day, fromDate: lastDay.date) != cal!.component(.Day, fromDate: NSDate()){
            return true
        }else{
            return false
        }
    }
    
    //テーブルをアップロードする
    func updateTable()->Void{
        tableView.setEditing(false, animated: true)
        isInEditMode = false
        tableView.reloadData()
    }
    
    
    //tableのプロトコル------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCellDataList.list.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell",forIndexPath: indexPath) as! TaskCell
        let taskCellData = taskCellDataList.list[indexPath.row]
        if dayChanged{
            cell.clearCell(taskCellDataList.list[indexPath.row])
        }
        cell.setCell(taskCellData)
        return cell
    }
    
    //tableViewタップ時のアクション
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //タップしたセルのindexを次のページに渡す
        selectedTaskIndex = indexPath.row
        
        //次のページへのセグエを呼び出す
        performSegueWithIdentifier("toTimerViewSegue", sender: nil)
        
        //選択色を落とす
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //スワイプした時のアクション設定（削除と編集）
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //削除
        let delete = UITableViewRowAction(style: .Destructive, title: "delete"){(action,indexPath)->Void in
            let alertController = UIAlertController(title: "タスク削除", message: "削除しますか？\n(ためた時間も消えてしまいます)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default){
                (action: UIAlertAction)-> Void in
                try! realm.write({
                    taskCellDataList.list.removeAtIndex(indexPath.row)
                    taskDataSourceList.list.removeAtIndex(indexPath.row)
                })
                self.updateTable()
            }
            alertController.addAction(okAction)
            alertController.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        //編集（編集ページへ飛ばす）
        let edit = UITableViewRowAction(style: .Normal, title: "edit"){(action,indexPath)->Void in
            self.selectedTaskIndex = indexPath.row
            self.performSegueWithIdentifier("toEditTaskSegue", sender: nil)
        }
        
        return [delete,edit]
    }
    
    //並べ替え処理
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let target: TaskCellData = taskCellDataList.list[sourceIndexPath.row]
        let targetTaskDataSource = taskDataSourceList.list[sourceIndexPath.row]
        try! realm.write({
            taskCellDataList.list.removeAtIndex(sourceIndexPath.row)
            taskCellDataList.list.insert(target, atIndex: destinationIndexPath.row)
            taskDataSourceList.list.removeAtIndex(sourceIndexPath.row)
            taskDataSourceList.list.insert(targetTaskDataSource, atIndex: destinationIndexPath.row)
            updateTable()
        })
    }
    
    
    //ページ遷移------------------------------------------------------
    //セグエ呼び出し時に情報を次の画面に送る
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTimerViewSegue"{
            let nav = segue.destinationViewController as! UINavigationController
            let nextVC = nav.topViewController as! TimerViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
        if segue.identifier == "toEditTaskSegue"{
            let nextVC = segue.destinationViewController as! EditTaskViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
    }
    
    
    //UnWindSegueで起動する関数
    //タイマー画面で時間を保存しつつ帰って来る
    //viewWillAppearで処理は記載済み
    @IBAction func backToTaskListView(segue: UIStoryboardSegue){}
    
    @IBAction func tapEditButton(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        tableView.setEditing(isInEditMode, animated: true)
    }
}


