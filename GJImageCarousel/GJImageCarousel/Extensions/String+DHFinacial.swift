//
//  String+DHFinacial.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/26.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

public extension String {
    
    // 返回字符串在当前字体下的宽度
    func width(font:UIFont) -> CGFloat {
        return (self as NSString).size(attributes: [NSFontAttributeName:font]).width
    }
    
    // 返回字符串在当前字体和Size下的高度
    func height(font:UIFont, size: CGSize) -> CGFloat {
        
        let attributes = [NSFontAttributeName:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        //获取字符串的frame,size限制了字符串最大的宽度和高度
        let rect: CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size.height + 20
    }
}
