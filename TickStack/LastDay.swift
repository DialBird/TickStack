//
//  Today.swift
//  TickStack
//
//  Created by Taniguchi Keisuke on 2016/05/15.
//  Copyright © 2016年 Taniguchi Keisuke. All rights reserved.
//

//日にちを保存しておいて、次に開いたときに日にちが進んだかどうかを判定

import Foundation
import RealmSwift

class LastDay: Object{
    dynamic var date: NSDate!
}