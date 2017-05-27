//
//  PrefixHeader.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/17.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

func DLog<T>(messge:T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)  {
    #if DEBUG
        let logStr: String = (fileName as NSString).pathComponents.last!
        print("类：\(logStr) \n方法：\(methodName) \n行：\(lineNumber) \n数据：\(messge)")
    #endif
}

let ScreenBounds = UIScreen.main.bounds
let ScreenWidth = ScreenBounds.size.width
let ScreenHeight = ScreenBounds.size.height

