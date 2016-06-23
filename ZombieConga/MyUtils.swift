//
//  MyUtils.swift
//  ZombieConga
//
//  Created by JackMa on 16/6/23.
//  Copyright © 2016年 JackMa. All rights reserved.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x, y: left.y+right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x*right.x, y: left.y*right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}

func * (point: CGPoint, scale: CGFloat) -> CGPoint {
    return CGPoint(x: point.x*scale, y: point.y*scale)
}

func *= (inout point: CGPoint, scale: CGFloat) {
    point = point * scale
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x/right.x, y: left.y/right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scale: CGFloat) -> CGPoint {
    return CGPoint(x: point.x/scale, y: point.y/scale)
}

func /= (inout point: CGPoint, scale: CGFloat) {
    point = point / scale
}

#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x:CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y), Float(x)))
    }
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x+y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    var angel: CGFloat {
        return atan2(y, x)
    }
    
}