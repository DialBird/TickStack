//
//  ButtonTest.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/15.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class ButtonTest: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btn1.backgroundColor = UIColor.redColor()
        btn1.layer.cornerRadius = btn1.bounds.height/2
        btn1.layer.masksToBounds = true
//        btn1.layer.shadowOffset = CGSizeMake(0,5)
//        btn1.layer.shadowColor = UIColor.grayColor().CGColor
        btn1.layer.shadowRadius = 1
        btn1.layer.shadowOpacity = 1
        btn1.layer.borderColor = UIColor.redColor().CGColor
        btn1.layer.borderWidth = 2
        btn1.enabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        guard let text = textField.text else {return true}
        btn1.enabled = true
        return true
    }
    
    
    @IBAction func tapDownButton(sender: UIButton) {
        sender.backgroundColor = UIColor.redColor()
    }
    @IBAction func tapUpButton(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
    }
    
}
