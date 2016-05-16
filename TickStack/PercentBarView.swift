//
//  PercentBarView.swift
//  Skimile
//
//  Created by Taniguchi Keisuke on 2016/05/06.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//
//もともとはパーセント表示を使いたくて作ったものだったが結局使わず


//import UIKit
//
//class PercentBarView: UIView {
//    
//    //塗るパーセントの色
//    private let DrawColor: UIColor = UIColor(colorLiteralRed: 255, green: 0, blue: 0, alpha: 1)
//    
//    //0~100までのパーセントが入る（整数）
//    private var _percent: CGFloat = 0
//    var percent: Int{
//        get{
//            return Int(self._percent)
//        }
//        set(val){
//            self._percent = CGFloat(val)
//            setNeedsDisplay()
//        }
//    }
//    
//    
//    
//    //描画処理
//    override func drawRect(rect: CGRect) {
//        let percentBarLength: CGFloat = bounds.width*_percent/100
//        let percentBar = UIBezierPath(rect: CGRectMake(bounds.width,0,-percentBarLength,bounds.height))
//        DrawColor.setFill()
//        percentBar.fill()
//    }
//}
