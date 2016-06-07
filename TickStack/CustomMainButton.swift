//
//  CustomMainButton.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/23.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

import UIKit

class CustomMainButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 2
        layer.borderColor = UIColor.getStrongGreen().CGColor
        layer.cornerRadius = bounds.height/2
        addTarget(self, action: #selector(CustomMainButton.tappedDown), forControlEvents: .TouchDown)
        addTarget(self, action: #selector(CustomMainButton.tappedUp), forControlEvents: .TouchUpInside)
        addTarget(self, action: #selector(CustomMainButton.tappedUp), forControlEvents: .TouchDragExit)
    }
    
    //MARK: - method
    
    func changeTitle(newTitle: String, forState: UIControlState){
        setTitle(newTitle, forState: forState)
    }
    
    func tappedDown(){
        backgroundColor = UIColor.getMainGreen()
    }
    
    func tappedUp(){
        backgroundColor = UIColor.clearColor()
    }
}
