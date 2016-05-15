//
//  ButtonTest.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/15.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class ButtonTest: UIViewController {
    
    @IBOutlet weak var btn1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn1.imageView?.backgroundColor = UIColor.redColor()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
