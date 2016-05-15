//
//  FirstViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/02.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//
//ここで実装すべき処理
/*
 １、最初に現在保存されているtaskCellDatasを呼び出して、中身の配列をテーブル上に順に表示
 ２、もしも表示する際に、既に100%になっているタスクがあった場合は、クリアマークを付けてあげる
 ３、日にちが変わった時に、taskCellDatasの中身をリセットする。
 ４、日にちが変わった時に、taskCellDatasの条件が達成されていれば、taskDataSourceを呼び出して、達成した日にち数を１日足してやる
 ここでは保存データの書き込みは日にちが変わった時のみ
 ５、タイマーが押されたらタスク名をタイマー画面に送る
 */

import UIKit
import RealmSwift

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //UIのキャッシュ
    @IBOutlet weak var tableView: UITableView!
    
    //今日の日にちを代入しておく
    var today: NSDate!
    
    //選択したタスク名を、startTimerViewに送るために格納する
    var selectedTaskIndex: Int!
    
    //現在編集モードかを指定
    var isInEditMode: Bool = false
    
    //最初の処理------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //realmをリセットする関数
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.URLByAppendingPathExtension("lock"),
            realmURL.URLByAppendingPathExtension("log_a"),
            realmURL.URLByAppendingPathExtension("log_b"),
            realmURL.URLByAppendingPathExtension("note")
        ]
        let manager = NSFileManager.defaultManager()
        for URL in realmURLs {
            do {
                try manager.removeItemAtURL(URL)
            } catch {
                // handle error
            }
        }
        try! realm.write({
            realm.deleteAll()
        })
        
        //関連付け
        tableView.dataSource = self
        tableView.delegate = self
        
        //上の空白を埋めるように設定
        self.automaticallyAdjustsScrollViewInsets = false
        for _ in 1..<5{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //繰り返し実行する関数------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        updateTable()
    }
    
    func updateTable(){
//        print(realm.objects(TaskCellDataList))
//        print(realm.objects(TaskDataSourceList))
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
    
    //スワイプした時のアクション設定
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
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
        let edit = UITableViewRowAction(style: .Normal, title: "edit"){(action,indexPath)->Void in
            self.selectedTaskIndex = indexPath.row
//            self.performSegueWithIdentifier("toTaskEditSegue", sender: nil)
            self.performSegueWithIdentifier("toEditTaskSegue", sender: nil)
        }
        return [delete,edit]
    }
    //削除処理
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
            let nextVC = segue.destinationViewController as! TimerViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
        if segue.identifier == "toEditTaskSegue"{
            let nextVC = segue.destinationViewController as! EditTaskViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
    }
    
    //タイマー画面で時間を保存しつつ帰って来る
    //viewWillAppearで処理は記載済み
    @IBAction func backToTaskListView(segue: UIStoryboardSegue){}
    
    @IBAction func tapEditButton(sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        tableView.setEditing(isInEditMode, animated: true)
    }
}


