//
//  EditTaskViewController.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/13.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //UIキャッシュ
    @IBOutlet weak var editTaskNameTextField: UITextField!
    @IBOutlet weak var editTaskTimeTextField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    //前のページから渡ってくるインデックス番号
    var selectedTaskIndex: Int!
    
    //pickerリスト
    var timeList: [Int] = [0,5,10,15,20,25,30,40,50,60,70,80,90]
    
    //Modelを格納
    var taskCellDataManager = TaskCellDataManager.sharedInstance
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートを登録(引っ込める処理を入れるため)
        editTaskNameTextField.delegate = self
        
        //前のページから渡ってきたindexからtaskを特定し、必要な情報を手にいれる
        let taskCellData: TaskCellData = taskCellDataManager.taskCellDataList.list[selectedTaskIndex]
        let currentTaskName = taskCellData.taskName
        let currentTaskGoalMinute = taskCellData.taskGoalMinute
        
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
        
        editTaskNameTextField.text = currentTaskName
        editTaskTimeTextField.text = "\(currentTaskGoalMinute)"
        
        //ボタン修飾
        editBtn.layer.borderWidth = 2
        editBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        editBtn.layer.cornerRadius = editBtn.bounds.height/2
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    //MARK: - textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        editTaskNameTextField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    //MARK: - PickerView
    
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
            editTaskTimeTextField.text = "\(timeList[row])"
        }
    }
    
    
    
    
    
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromEditTaskSegue"{
            
            //編集を加える
            let newTaskName: String = editTaskNameTextField.text!
            let newTaskGoalMinute: Int = Int(editTaskTimeTextField.text!)!
            taskCellDataManager.edit(selectedTaskIndex, newTaskName: newTaskName, newTaskGoalMinute: newTaskGoalMinute)
            taskDataSourceManager.edit(selectedTaskIndex, newTaskName: newTaskName)
        }
    }
    
    
    
    
    
    
    //MARK: - IBAction
    
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
        }else if Int(editTaskTimeTextField.text!)! == 0{
            displayAlert(2)
            return
        }
        var isNewTask: Bool = true
        
        for content in taskCellDataManager.taskCellDataList.list.enumerate(){
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
