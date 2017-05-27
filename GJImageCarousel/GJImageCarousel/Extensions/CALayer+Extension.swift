//
//  CALayer+Extension.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/27.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    class func straightLine(sPoint: CGPoint, ePoint: CGPoint, cPoint: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        let layer = CAShapeLayer()
        
        path.move(to: sPoint)
        path.addQuadCurve(to: ePoint, controlPoint: cPoint)
        
        layer.path = path.cgPath
        layer.lineWidth = 0.1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }
}
