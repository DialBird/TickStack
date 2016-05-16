//
//  DataSourceListViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/13.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class DataSourceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //次のページに送信するインデックス
    var selectedTaskIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //関連付け
        tableView.dataSource = self
        tableView.delegate = self
        
        //上の空白を埋めるように設定
        self.automaticallyAdjustsScrollViewInsets = false
        
        //NavigationBarの色を決定
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainGreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTable()
    }
    
    func updateTable(){
        tableView.reloadData()
    }
    
    //プロトコル------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDataSourceList.list.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dataSourceViewTaskCell",forIndexPath: indexPath)
        cell.textLabel?.text = taskDataSourceList.list[indexPath.row].taskName
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTaskIndex = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("toDisplayTaskDataSegue", sender: nil)
    }
    
    //ページ遷移
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDisplayTaskDataSegue"{
            let nextVC = segue.destinationViewController as! DisplayTaskDataViewController
            nextVC.selectedTaskIndex = selectedTaskIndex
        }
    }
}
