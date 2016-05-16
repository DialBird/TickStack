//
//  CreateNewTaskView.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/06.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

//ここで実装すべき処理
/*
 １、taskDataSourceインスタンスにtask名と登録した日にちを保存し、taskDataSourceArrayに格納する（辞書型）
 ２、taskCellDataにtask名と目標時間を登録し、taskCellDatasに格納する（配列）
 ３、これら二つの配列、辞書を端末に保存
 */

import UIKit
import RealmSwift


class CreateNewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //UIキャッシュ
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    
    //pickerリスト（分）
    var timeList: [Int] = [0,1,10,20,30,40,50,60,70,80,90]
    
    //表示している時間
    var selectedMinute: Int = 0
    
    
    //最初の処理------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートを登録(引っ込める処理を入れるため)
        newTaskNameTextField.delegate = self
        
        //pickerにつけるツールバー
        let PickerToolBar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.width,40))
        PickerToolBar.barStyle = .Default
        let PickerDoneBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(CreateNewTaskViewController.PickDone))
        PickerToolBar.items = [PickerDoneBtn]
        
        //pickerをtextFieldへ追加
        let timePicker = UIPickerView()
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.tag = 1
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = PickerToolBar
        timeTextField.text = "\(selectedMinute)"
        
        //ボタンを修飾
        createBtn.layer.borderWidth = 2
        createBtn.layer.borderColor = UIColor.getStrongGreen().CGColor
        createBtn.layer.cornerRadius = createBtn.bounds.height/2
    }
    
    
    //Pickerのプロトコル------------------------------------------------------
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
        timeTextField.resignFirstResponder()
    }
    
    //選択した数字をtextに反映する
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            timeTextField.text = "\(timeList[row])"
            selectedMinute = timeList[row]
        }
    }
    
    
    //textFieldプロトコル------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newTaskNameTextField.resignFirstResponder()
        return true
    }
    
    
    //ページ遷移------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromCreateTaskSegue"{
            
            //新しいTaskCellData
            let newTaskCellData = TaskCellData()
            newTaskCellData.taskName = newTaskNameTextField.text!
            newTaskCellData.taskGoalMinute = Int(timeTextField.text!)!
            //新しいtaskDataSource
            let newTaskDataSource = TaskDataSource()
            newTaskDataSource.taskName = newTaskNameTextField.text!
            newTaskDataSource.firstDay = NSDate()
            
            try! realm.write({
                taskCellDataList.list.append(newTaskCellData)
                taskDataSourceList.list.append(newTaskDataSource)
            })
        }
    }
    
    
    //ボタンイベント------------------------------------------------------
    @IBAction func tapDownCreateBtn(sender: UIButton) {
        createBtn.backgroundColor = UIColor.getMainGreen()
    }
    @IBAction func tapUpCreateBtn(sender: UIButton) {
        createBtn.backgroundColor = UIColor.clearColor()
        
        if newTaskNameTextField.text?.characters.count == 0{
            displayAlert(0)
            return
        }else if timeTextField.text?.characters.count == 0{
            displayAlert(1)
            return
        }else if timeTextField.text == "0"{
            displayAlert(2)
            return
        }else if Int(timeTextField.text!) == nil{
            displayAlert(3)
            return
        }
        var isNewTask: Bool = true
        taskCellDataList.list.forEach{(a)->Void in
            if a.taskName == newTaskNameTextField.text!{
                displayAlert(4)
                isNewTask = false
            }
        }
        if isNewTask{
            performSegueWithIdentifier("backToTaskListFromCreateTaskSegue", sender: nil)
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
            subTitle = "数字を入力してください"
        }else if num == 4{
            subTitle = "そのタスクはもう存在しています"
        }
        let alertController = UIAlertController(title: "入力が済んでいません", message: subTitle, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}






