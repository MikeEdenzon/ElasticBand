//
//  InteractiveView.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 4/4/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class InteractiveView: UIView {
    
    var elasticLayers: [ElasticLayer] = []
    var anchorPoint: CGPoint!
    var activePoint: CGPoint!
    var releasePoint: CGPoint!
    var path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let inset = frame.width / 10
        let y1 = center.y - 50
        let y2 = center.y
        let y3 = center.y + 50
        
        addElasticLayer(from: anchorPoints(inset: inset, y: y1), color: UIColor.blue)
        addElasticLayer(from: anchorPoints(inset: inset, y: y2), color: UIColor.blue)
        addElasticLayer(from: anchorPoints(inset: inset, y: y3), color: UIColor.blue)
    }
    
    private func midpoint(between p1: CGPoint, and p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    private func anchorPoints(inset: CGFloat, y: CGFloat) -> [CGPoint] {
        return [CGPoint(x: inset, y: y), CGPoint(x: frame.width - inset, y: y)]
    }
    
    func addElasticLayer(from points: [CGPoint], color: UIColor) {
        addElasticLayer(from: points[0], to: points[1], color: color)
    }
    
    // Builds and adds elastic layer to view & array.
    func addElasticLayer(from left: CGPoint, to right: CGPoint, color: UIColor) {
        let elasticLayer = ElasticLayer(frame: self.frame, color: color)
        elasticLayer.setAnchorPoints(left: left, right: right)
        elasticLayer.bend(to: midpoint(between: left, and: right))
        elasticLayers.append(elasticLayer)
        self.layer.addSublayer(elasticLayer)
    }
    
    // Bends multiple elastic bands.
    func bend(touches: Set<UITouch>) {
        for touch in touches {
            let previousTouch = touch.precisePreviousLocation(in: self)
            let currentTouch = touch.preciseLocation(in: self)
            for elasticLayer in elasticLayers {
                elasticLayer.cross(between: previousTouch, and: currentTouch)
                if elasticLayer.active {
                    elasticLayer.bend(to: currentTouch)
                }
            }
        }
    }
    
    // Snaps multiple elastic bands.
    func snap(touches: Set<UITouch>) {
        for elasticLayer in elasticLayers {
            elasticLayer.snap(from: (touches.first?.preciseLocation(in: self))!)
        }
    }
    
    
    // bend
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { bend(touches: touches) }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { bend(touches: touches) }
    
    // snap
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { snap(touches: touches) }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { snap(touches: touches) }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
