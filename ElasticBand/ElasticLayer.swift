//
//  ElasticLayer.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 4/4/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class ElasticLayer: CAShapeLayer {
    
    private var _bezierPath = UIBezierPath()
    private var _leftAnchorPoint = CGPoint()
    private var _rightAnchorPoint = CGPoint()
    
    var points: [CGPoint]!
    var active = false
    
    var leftAnchor: CGPoint {
        get {
            return _leftAnchorPoint
        }
    }
    
    var rightAnchor: CGPoint {
        get {
            return _rightAnchorPoint
        }
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: leftAnchor.x + (rightAnchor.x/2), y: leftAnchor.y)
        }
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init()
        self.frame = frame
        self.strokeColor = color.withAlphaComponent(0.5).cgColor
        self.fillColor = nil
        self.lineWidth = 5
        self.lineJoin = kCALineJoinRound
        self.lineCap = kCALineCapRound
        self.path = _bezierPath.cgPath
    }
    
    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return abs(p2.x - p1.x) + abs(p2.y - p1.y)
    }
    
    private func elasticPoint(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        
        let sx = copysign(1, dx)
        let sy = copysign(1, dy)
        
        let d = distance(from: p1, to: p2)
        let ld = log(d) + (d/3)
        
        let px = ((abs(dx) / d) * ld) * sx
        let py = ((abs(dy) / d) * ld) * sy
        
        return CGPoint(x: p1.x + px, y: p1.y + py)
    }
    
    private func responsePoint(from previousPoint: CGPoint) -> CGPoint {
        
        let dx = previousPoint.x - center.x
        let dy = previousPoint.y - center.y
        
        let sx = copysign(1, dx) * -1
        let sy = copysign(1, dy) * -1
        
        let d = distance(from: previousPoint, to: center)
        
        let mx = ((d * abs(dx/d)) * sx) / 4
        let my = ((d * abs(dy/d)) * sy) / 2
        
        return CGPoint(x: center.x + mx, y: center.y + my)
    }
    
    private func advancedRebound(releasePoint: CGPoint) {
        let animation = CAKeyframeAnimation(keyPath: "path")
        var paths = [CGPath]()
        var previousPoint = releasePoint
        for _ in 0..<5 {
            let point = responsePoint(from: previousPoint)
            
            //paths.append(UIBezierPath.interpolatedWith(points: [leftAnchor,point,rightAnchor]).cgPath)
            paths.append(UIBezierPath.interpolatedWith(points: [leftAnchor,point,rightAnchor]).cgPath)
            
            previousPoint = point
        }
        paths.append(UIBezierPath.interpolatedWith(points: [leftAnchor,center,rightAnchor]).cgPath)
        animation.values = paths
        animation.calculationMode = kCAAnimationLinear
        animation.isRemovedOnCompletion = true
        animation.duration = 0.5
        add(animation, forKey: "path")
    }
    
    func setAnchorPoints(left: CGPoint, right: CGPoint) {
        _leftAnchorPoint = left
        _rightAnchorPoint = right
        
        points = [leftAnchor,center,rightAnchor]
        
        //_bezierPath.interpolate(points: points)
        _bezierPath.interpolateQuadCurve(from: points)
    }
    
    func cross(between p1: CGPoint, and p2: CGPoint) {
        if ((p1.y <= center.y) && (p2.y >= center.y)) || ((p1.y >= center.y) && (p2.y <= center.y)) {
            active = true
        }
    }
    
    func bend(to point: CGPoint) {
        points[1] = elasticPoint(from: center, to: point)
        
        //_bezierPath.interpolate(points: points)
        _bezierPath.interpolateQuadCurve(from: points)
        
        path = _bezierPath.cgPath
    }
    
    func snapback(from point: CGPoint) {
        if active {
            active = false
            advancedRebound(releasePoint: point)
            points[1] = center
            
            //_bezierPath.interpolate(points: points)
            _bezierPath.interpolateQuadCurve(from: points)
            
            path = _bezierPath.cgPath
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
























