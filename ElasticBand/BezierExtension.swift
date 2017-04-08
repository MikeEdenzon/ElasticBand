//
//  BezierExtension.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 10/12/16.
//  Copyright © 2016 Michael Edenzon. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    func interpolate(points: [CGPoint], alpha: CGFloat = 1.0/3.0) {
        
        guard !points.isEmpty else { return }
        self.removeAllPoints()
        
        self.move(to: points[0])
        
        let n = points.count - 1
        
        for index in 0..<n {
            
            var currentPoint = points[index]
            var nextIndex = (index + 1) % points.count
            var prevIndex = index == 0 ? points.count - 1 : index - 1
            var previousPoint = points[prevIndex]
            var nextPoint = points[nextIndex]
            let endPoint = nextPoint
            var dx: CGFloat
            var dy: CGFloat
            
            if index > 0 {
                
                dx = (nextPoint.x - previousPoint.x) * (3/4)
                dy = (nextPoint.y - previousPoint.y) * (3/4)
                
            } else {
                
                dx = (nextPoint.x - currentPoint.x) * (3/4)
                dy = (nextPoint.y - currentPoint.y) * (3/4)
                
            }
            
            let controlPoint1 = CGPoint(x: currentPoint.x + dx * alpha, y: currentPoint.y + dy * alpha)
            currentPoint = points[nextIndex]
            nextIndex = (nextIndex + 1) % points.count
            prevIndex = index
            previousPoint = points[prevIndex]
            nextPoint = points[nextIndex]
            
            if index < n - 1 {
                
                dx = (nextPoint.x - previousPoint.x) * (3/4)
                dy = (nextPoint.y - previousPoint.y) * (3/4)
                
            } else {
                
                dx = (currentPoint.x - previousPoint.x) * (3/4)
                dy = (currentPoint.y - previousPoint.y) * (3/4)
                
            }
            
            let controlPoint2 = CGPoint(x: currentPoint.x - dx * alpha, y: currentPoint.y - dy * alpha)
            
            self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
    }
    
    static func interpolatedWith(points: [CGPoint], alpha: CGFloat = 1.0/3.0) -> UIBezierPath {
        
        guard !points.isEmpty else { return UIBezierPath() }
        
        let path = UIBezierPath()
        
        path.move(to: points[0])
        
        let n = points.count - 1
        
        for index in 0..<n {
            
            var currentPoint = points[index]
            var nextIndex = (index + 1) % points.count
            var prevIndex = index == 0 ? points.count - 1 : index - 1
            var previousPoint = points[prevIndex]
            var nextPoint = points[nextIndex]
            let endPoint = nextPoint
            var dx: CGFloat
            var dy: CGFloat
            
            if index > 0 {
                
                dx = (nextPoint.x - previousPoint.x) * (3/4)
                dy = (nextPoint.y - previousPoint.y) * (3/4)
                
            } else {
                
                dx = (nextPoint.x - currentPoint.x) * (3/4)
                dy = (nextPoint.y - currentPoint.y) * (3/4)
                
            }
            
            let controlPoint1 = CGPoint(x: currentPoint.x + dx * alpha, y: currentPoint.y + dy * alpha)
            currentPoint = points[nextIndex]
            nextIndex = (nextIndex + 1) % points.count
            prevIndex = index
            previousPoint = points[prevIndex]
            nextPoint = points[nextIndex]
            
            if index < n - 1 {
                
                dx = (nextPoint.x - previousPoint.x) * (3/4)
                dy = (nextPoint.y - previousPoint.y) * (3/4)
                
            } else {
                
                dx = (currentPoint.x - previousPoint.x) * (3/4)
                dy = (currentPoint.y - previousPoint.y) * (3/4)
                
            }
            
            let controlPoint2 = CGPoint(x: currentPoint.x - dx * alpha, y: currentPoint.y - dy * alpha)
            
            path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        
        return path
    }
}






