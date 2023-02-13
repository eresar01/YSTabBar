//
//  YSViewStyle.swift
//  YSTabBar
//
//  Created by Yerem Sargsyan on 13.02.23.
//

import UIKit
import Foundation

public enum YSViewStyle {
    case hole
    case convex
    
    func viewStyle(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIBezierPath {
        switch self {
        case .hole:
            return holeStyle(width: width, height: height, radius: radius)
        default:
            return convexStyle(width: width, height: height, radius: radius)
        }
    }
    
   private func holeStyle(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width / 2 + (2 * radius), y: 0))
        path.addCurve(to: CGPoint(x: width / 2 , y: radius),
                      controlPoint1: CGPoint(x: width / 2 + radius, y: 0),
                      controlPoint2: CGPoint(x: width / 2 + radius, y: radius))
        path.addLine(to: CGPoint(x: width / 2 , y: radius))
        path.addCurve(to: CGPoint(x: width / 2 - (2 * radius), y: 0),
                      controlPoint1: CGPoint(x: width / 2 - radius, y: radius),
                      controlPoint2: CGPoint(x: width / 2 - radius, y: 0))
        path.addLine(to: CGPoint(x: width / 2 - (2 * radius), y: 0))
        path.close()
        path.lineWidth = 1
        return path
    }
    
    private func convexStyle(width: CGFloat, height: CGFloat, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let convexMaxPoint: CGFloat = radius + (radius / 12)
        let minPoint = radius / 3
        
        path.move(to: CGPoint(x: 0, y: convexMaxPoint))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: convexMaxPoint))
        path.addLine(to: CGPoint(x: width / 2 + (2 * radius), y: convexMaxPoint))
        path.addCurve(to: CGPoint(x: width / 2 , y: minPoint),
                      controlPoint1: CGPoint(x: width / 2 + radius, y: convexMaxPoint),
                      controlPoint2: CGPoint(x: width / 2 + radius, y: minPoint))
        path.addLine(to: CGPoint(x: width / 2 , y: minPoint))
        path.addCurve(to: CGPoint(x: width / 2 - (2 * radius), y: convexMaxPoint),
                      controlPoint1: CGPoint(x: width / 2 - radius, y: minPoint),
                      controlPoint2: CGPoint(x: width / 2 - radius, y: convexMaxPoint))
        path.addLine(to: CGPoint(x: width / 2 - (2 * radius), y: convexMaxPoint))
        path.close()
        path.lineWidth = 1
        
        return path
    }
}

