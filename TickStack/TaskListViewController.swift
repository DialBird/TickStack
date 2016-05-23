//
//  FirstViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
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
    
    //モデルの格納
    let taskCellDataManager = TaskCellDataManager.sharedInstance
    let taskDataSourceManager = TaskDataSourceManager.sharedInstance
    let dayChangeManager = DayChangeManager.sharedInstance
    
    
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
    
    
    
    
    
    //MARK: - lifeSycle
    
    override func viewWillAppear(animated: Bool) {
        
        //監視対象の追加
        //taskCellDataListとtaskDataSourceListは基本同時に変更されるので、どちらか片方だけ監視していればいい
        taskCellDataManager.addObserver(self, forKeyPath: "taskCellDataList", options: .New, context: nil)
        
        //本日の日付の表示
        let calendarParts: (year: Int, month: Int, day: Int) = convertNSDateIntoCalenderParts(NSDate())
        let year: Int = calendarParts.year
        let month: Int = calendarParts.month
        let day: Int = calendarParts.day
        dateTellerTextLabel.text = "\(year)/\(month)/\(day)の状況"
        
        //もしも前に登録したLastDayオブジェクトがなければ初期化したものを保存する
        dayChangeManager.checkStoredDataExists()
        
        //日にちが変わっていたらdayChangedをtrueにする
        if dayChangeManager.checkDayChange(){
            dayChanged = true
        }else{
            dayChanged = false
        }
        
        //日付の再登録
        dayChangeManager.saveNowMoment(NSDate())
        
        //テーブルビューの更新
        updateTable()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        taskCellDataManager.removeObserver(self, forKeyPath: "taskCellDataList")
    }
    
    
    
    
    
    //MARK: - Observer
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "taskCellDataList"{
            updateTable()
        }
    }
    
    //テーブルをアップロードする
    func updateTable()->Void{
        tableView.setEditing(false, animated: true)
        isInEditMode = false
        
        //もし日にちが変わっていたら発動
        if dayChanged{
            taskCellDataManager.clearTaskCellDataList()
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - DZNEmptyDataSet
    
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
    
    
    
    
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCellDataManager.taskCellDataList.list.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell",forIndexPath: indexPath) as! TaskCell
        let taskCellData = taskCellDataManager.taskCellDataList.list[indexPath.row]
        cell.setCell(taskCellData)
        return cell
    }
    
    //tableViewタップ時のアクション
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //タップしたセルのindexを次のページに渡す
        selectedTaskIndex = indexPath.row
        
        //もしこのサイズが4sのものだったら、そのサイズに合わせたviewControllerへ移動する
        if thisIs4s{
            performSegueWithIdentifier("toTimerFor4sSegue", sender: nil)
        }else{
            performSegueWithIdentifier("toTimerViewSegue", sender: nil)
        }
        
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
                
                self.taskCellDataManager.deleteElement(indexPath.row)
                self.taskDataSourceManager.deleteElement(indexPath.row)
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
        taskCellDataManager.changeOrder(sourceIndexPath.row, destIndex: destinationIndexPath.row)
        taskDataSourceManager.changeOrder(sourceIndexPath.row, destIndex: destinationIndexPath.row)
    }
    
    
    
    
    
    //MARK: - Segue
    
    //セグエ呼び出し時に情報を次の画面に送る
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTimerViewSegue"{
            let nav = segue.destinationViewController as! UINavigationController
            let nextVC = nav.topViewController as! TimerViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
        if segue.identifier == "toTimerFor4sSegue"{
            let nav = segue.destinationViewController as! UINavigationController
            let nextVC = nav.topViewController as! TimerViewControllerFor4s
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
        if segue.identifier == "toEditTaskSegue"{
            let nextVC = segue.destinationViewController as! EditTaskViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
    }
    
    
    
    
    
    //MARK: - IBAction
    
    //UnWindSegueで起動する関数
    //タイマー画面で時間を保存しつつ帰って来る
    @IBAction func backToTaskListView(segue: UIStoryboardSegue){}
    
    //編集ボタンを押した時
    @IBAction func tapEditButton(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        tableView.setEditing(isInEditMode, animated: true)
    }
}



