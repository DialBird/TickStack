//
//  CreateOrEditTaskViewController.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

//このViewControllerのモード
enum CreateOrEditTaskViewControllerMode{
    case Create
    case Edit
}

class CreateOrEditTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //UIキャッシュ
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var createBtn: CustomMainButton!
    
    //現在の画面を、「新規作成モード」と「編集モード」とできりかえる
    var nowMode: CreateOrEditTaskViewControllerMode!
    
    //編集モードの場合は、選択したタスクのindexが入ってくるが、新規作成モードではnilになる
    var selectedTaskIndex: Int?
    
    //pickerリスト（分）
    var timeList: [Int] = [0,5,10,15,20,25,30,40,50,60,70,80,90]
    
    //Modelを格納
    var taskCellDataManager = TaskCellDataManager.sharedInstance
    var taskDataSourceManager = TaskDataSourceManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デリゲートを登録(引っ込める処理を入れるため)
        newTaskNameTextField.delegate = self
        
        //index番号が入っていた場合は「編集モード」になる
        if let selectedTaskIndex = selectedTaskIndex{
            nowMode = .Edit
            
            //タイトル変更
            title = "タスク編集"
            createBtn.changeTitle("編集", forState: .Normal)
            
            //前のページから渡ってきたindexからtaskを特定し、必要な情報を手にいれて、textfieldに記載する
            let taskCellData: TaskCellData = taskCellDataManager.taskCellDataList.list[selectedTaskIndex]
            let currentTaskName = taskCellData.taskName
            let currentTaskGoalMinute = taskCellData.taskGoalMinute
            newTaskNameTextField.text = currentTaskName
            timeTextField.text = "\(currentTaskGoalMinute)"
            
        }else{
            nowMode = .Create
            
            //タイトル変更
            title = "新規タスク作成"
            createBtn.changeTitle("作成", forState: .Normal)
        }
        
        
        //pickerにつけるツールバー
        let PickerToolBar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.width,40))
        PickerToolBar.barStyle = .Default
        let PickerDoneBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(CreateOrEditTaskViewController.PickDone))
        PickerToolBar.items = [PickerDoneBtn]
        
        //pickerをtextFieldへ追加
        let timePicker = UIPickerView()
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.tag = 1
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = PickerToolBar
    }
    
    
    
    
    
    //MARK: - Picker
    
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
    
    //表示文字列を返す
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
        }
    }
    
    
    
    
    
    //MARK: - textField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newTaskNameTextField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToTaskListFromCreateTaskSegue"{
            let newTaskName: String = newTaskNameTextField.text!
            let newTaskGoalMinute: Int = Int(timeTextField.text!)!
            if nowMode == .Edit{
                taskCellDataManager.edit(selectedTaskIndex!, newTaskName: newTaskName, newTaskGoalMinute: newTaskGoalMinute)
            }else{
                taskCellDataManager.add(newTaskName, newTaskGoalMinute: newTaskGoalMinute)
                taskDataSourceManager.add(newTaskName, firstDate: NSDate())
            }
        }
    }
    
    
    
    
    
    //MARK: - IBAction
    
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
        }
        
        //名前がかぶっていたらエラーを返す
        var isNewTask: Bool = true
        for taskCellData in taskCellDataManager.taskCellDataList.list.enumerate(){
            //もしEditモードであれば、現在のindex番号はスキップするように
            if nowMode == .Edit && taskCellData.index == selectedTaskIndex{continue}
            if taskCellData.element.taskName == newTaskNameTextField.text!{
                displayAlert(3)
                isNewTask = false
            }
        }
        if isNewTask{
            performSegueWithIdentifier("backToTaskListFromCreateTaskSegue", sender: nil)
        }
    }
    
    
    
    
    
    //MARK: - Alert
    
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
