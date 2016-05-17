//
//  EditTaskViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/13.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //UIキャッシュ
    @IBOutlet weak var editTaskNameTextField: UITextField!
    @IBOutlet weak var editTaskTimeTextField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    //前のページから渡ってくるインデックス番号
    var selectedTaskIndex: Int!
    
    //上のインデックス番号からtaskData,taskDataSourceを取得
    var taskData = TaskCellData()
    var taskDataSource = TaskDataSource()
    
    //pickerリスト
    var timeList: [Int] = [0,5,10,15,20,25,30,40,50,60,70,80,90]
    
    //表示している時間
    var selectedMinute: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //前のページから渡ってきたindexからtaskを特定し、必要な情報を手にいれる
        taskData = taskCellDataList.list[selectedTaskIndex]
        taskDataSource = taskDataSourceList.list[selectedTaskIndex]
        selectedMinute = taskData.taskGoalMinute
        
        //pickerにつけるツールバー
        let PickerToolBar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.width,40))
        PickerToolBar.barStyle = .Default
        let PickerDoneBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(EditTaskViewController.PickDone))
        PickerToolBar.items = [PickerDoneBtn]
        
        let timePicker = UIPickerView()
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.tag = 1
        editTaskTimeTextField.inputView = timePicker
        editTaskTimeTextField.inputAccessoryView = PickerToolBar
        
        editTaskNameTextField.text = taskData.taskName
        editTaskTimeTextField.text = "\(selectedMinute)"
        
        //ボタン修飾
        editBtn.layer.borderWidth = 2
        editBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        editBtn.layer.cornerRadius = editBtn.bounds.height/2
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //プロトコル------------------------------------------------------
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number: Int!
        if pickerView.tag == 1{
            number = timeList.count
        }
        return number
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        var title: String!
        if pickerView.tag == 1{
            title = "\(timeList[row])"
        }
        return title
    }
    
    //完了したら引っ込める
    func PickDone(){
        editTaskTimeTextField.resignFirstResponder()
    }
    
    //選択した数字をtextに反映する
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            selectedMinute = timeList[row]
            editTaskTimeTextField.text = "\(selectedMinute)"
        }
    }
    
    //ページ遷移------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromEditTaskSegue"{
            
            //編集を加える
            try! realm.write({
                //taskCellDataに変更
                taskData.taskName = editTaskNameTextField.text!
                taskData.taskGoalMinute = selectedMinute
                //taskDataSourceに変更
                taskDataSource.taskName = editTaskNameTextField.text!
            })
        }
    }

    
    //ボタンイベント------------------------------------------------------
    @IBAction func tapDownEditBtn(sender: UIButton) {
        editBtn.backgroundColor = UIColor.getStrongGreen()
    }
    @IBAction func tapUpEditBtn(sender: UIButton) {
        editBtn.backgroundColor = UIColor.clearColor()
        if editTaskNameTextField.text?.characters.count == 0{
            displayAlert(0)
            return
        }else if editTaskTimeTextField.text?.characters.count == 0{
            displayAlert(1)
            return
        }else if selectedMinute == 0{
            displayAlert(2)
            return
        }
        var isNewTask: Bool = true
        
        for content in taskCellDataList.list.enumerate(){
            if content.index == selectedTaskIndex{continue}
            if content.element.taskName == editTaskNameTextField.text!{
                displayAlert(3)
                isNewTask = false
            }
        }
        if isNewTask{
            performSegueWithIdentifier("backToTaskListFromEditTaskSegue", sender: nil)
        }
    }
    
    
    
    //アラートを出す関数------------------------------------------------------
    func displayAlert(num: Int){
        var subTitle: String!
        if num == 0{
            subTitle = "タスク名が空欄です"
        }else if num == 1{
            subTitle = "目標時間が空欄です"
        }else if num == 2{
            subTitle = "目標時間が0になっています"
        }else if num == 3{
            subTitle = "そのタスクはもう存在しています"
        }
        let alertController = UIAlertController(title: "入力が済んでいません", message: subTitle, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
