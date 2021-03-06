//
//  DataSourceListViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/13.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DataSourceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //次のページに送信するインデックス
    var selectedTaskIndex: Int!
    
    //モデルを格納する
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewとの関連付け
        tableView.dataSource = self
        tableView.delegate = self
        
        //DZNを使うための関連付け
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        //上の空白を埋めるように設定
        self.automaticallyAdjustsScrollViewInsets = false
        
        //NavigationBarの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //MARK: - lifeSycle
    
    override func viewWillAppear(animated: Bool) {
        updateTable()
    }
    
    func updateTable(){
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - tableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDataSourceManager.taskDataSourceList.list.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dataSourceViewTaskCell",forIndexPath: indexPath)
        cell.textLabel?.text = taskDataSourceManager.taskDataSourceList.list[indexPath.row].taskName
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTaskIndex = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if thisIs4s{
            performSegueWithIdentifier("toDisplayTaskDataFor4sSegue", sender: nil)
        }else{
            performSegueWithIdentifier("toDisplayTaskDataSegue", sender: nil)
        }
    }
    
    
    
    
    
    //MARK: - DZNEmptyDataSet
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "タスクが登録されていません"
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(15)]
        return NSAttributedString(string: text, attributes: attr)
    }
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = "タスクタイマーメニューから追加してください"
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
        return NSAttributedString(string: text, attributes: attr)
    }
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    
    
    
    
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDisplayTaskDataSegue"{
            let nextVC = segue.destinationViewController as! DisplayTaskDataViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
        if segue.identifier == "toDisplayTaskDataFor4sSegue"{
            let nextVC = segue.destinationViewController as! DisplayTaskDataViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
    }
    
    
    
    
    
    //MARK: - IBAction
    @IBAction func backToDataSourceListView(segue: UIStoryboardSegue){}
    
}
