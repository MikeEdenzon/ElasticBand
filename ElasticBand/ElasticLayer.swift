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
        let ld = log(d) + (d/1.3)
        
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
        let my = ((d * abs(dy/d)) * sy) / 1.6
        
        return CGPoint(x: center.x + mx, y: center.y + my)
    }
    
    private func rebound(from releasePoint: CGPoint) {
        let animation = CAKeyframeAnimation(keyPath: "path")
        var paths = [CGPath]()
        var previousPoint = releasePoint
        var count: Double = 0
        while abs(center.y - previousPoint.y) > 7 {
            let point = responsePoint(from: previousPoint)
            paths.append(UIBezierPath.interpolatedQuadCurve(from: [leftAnchor,point,rightAnchor]).cgPath)
            previousPoint = point
            count += 1
        }
        paths.append(UIBezierPath.interpolatedQuadCurve(from: [leftAnchor,center,rightAnchor]).cgPath)
        animation.values = paths
        animation.calculationMode = kCAAnimationLinear
        animation.isRemovedOnCompletion = true
        animation.duration = count / 12
        add(animation, forKey: "path")
    }
    
    /// Set left and right anchor points.
    ///
    /// - Parameters:
    ///   - left: Left anchor point.
    ///   - right: Right anchor point.
    func setAnchorPoints(left: CGPoint, right: CGPoint) {
        _leftAnchorPoint = left
        _rightAnchorPoint = right
        points = [leftAnchor,center,rightAnchor]
        _bezierPath.interpolateQuadCurve(from: points)
    }
    
    /// Check if an action (e.g. touches) crosses the band.
    ///
    /// - Parameters:
    ///   - between: Point 1.
    ///   - and: Point 2.
    func cross(between p1: CGPoint, and p2: CGPoint) {
        if ((p1.y <= center.y) && (p2.y >= center.y)) || ((p1.y >= center.y) && (p2.y <= center.y)) {
            active = true
        }
    }
    
    /// Generates elastic point from given point and bends band to it.
    ///
    /// - Parameters:
    ///   - to: Point to where elastic band should be bent.
    func bend(to point: CGPoint) {
        points[1] = elasticPoint(from: center, to: point)
        _bezierPath.interpolateQuadCurve(from: points)
        path = _bezierPath.cgPath
    }
    
    func initialBend() {
        points[1] = elasticPoint(from: center, to: center)
        _bezierPath.interpolateQuadCurve(from: points)
        path = _bezierPath.cgPath
    }
    
    /// Snaps elastic band from release point.
    ///
    /// - Parameters:
    ///   - from: Point where elastic band was released.
    func snap(from point: CGPoint) {
        if active {
            active = false
            rebound(from: point)
            points[1] = center
            _bezierPath.interpolateQuadCurve(from: points)
            path = _bezierPath.cgPath
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
