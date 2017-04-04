//
//  ViewController.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 10/12/16.
//  Copyright © 2016 Michael Edenzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let layer1 = CAShapeLayer()
    let path1 = UIBezierPath()
    var firstTouch: CGPoint!
    var midpoint: CGPoint!
    var pathPoints: [CGPoint]!
    
    var endpoint1: CGPoint! {
        get {
            return CGPoint(x: view.frame.width/2, y: -10)
        }
    }
    
    var endpoint2: CGPoint! {
        get {
            return CGPoint(x: view.frame.width/2, y: view.frame.height + 10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        midpoint = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        
        pathPoints = [endpoint1,midpoint,endpoint2]
        
        layer1.frame = view.frame
        layer1.fillColor = nil
        layer1.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer1.lineCap = kCALineCapRound
        layer1.lineJoin = kCALineJoinRound
        layer1.lineWidth = 6
        
        path1.interpolate(points: pathPoints)
        layer1.path = path1.cgPath
        path1.removeAllPoints()
        
        view.layer.addSublayer(layer1)
    }
    
    func distance(from p1: CGPoint, to p2: CGPoint) ->CGFloat {
        return abs(p2.x - p1.x) + abs(p2.y - p1.y)
    }
    
    private func elasticPoint(from p1: CGPoint, to p2: CGPoint) ->CGPoint {
        
        let dx: CGFloat = p2.x - p1.x
        let dy: CGFloat = p2.y - p1.y
        
        let sx = copysign(1, dx)
        let sy = copysign(1, dy)
        
        let d = distance(from: p1, to: p2)
        let ld = log(d) + (d/3)
        
        let px = ((abs(dx) / d) * ld) * sx
        let py = ((abs(dy) / d) * ld) * sy
        
        return CGPoint(x: p1.x + px, y: p1.y + py)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first
            
            else { return }
        
        let touchPoint = touch.preciseLocation(in: view)
        firstTouch = touchPoint
        
        pathPoints[1] = elasticPoint(from: midpoint, to: touchPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (firstTouch.x > 180) && (firstTouch.x < 234),
            let touch = touches.first
            
            else { return }
        
        let touchPoint = touch.preciseLocation(in: view)
        
        pathPoints[1] = elasticPoint(from: midpoint, to: touchPoint)
        
        path1.interpolate(points: pathPoints)
        layer1.path = path1.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pathPoints[1] = midpoint
        
        path1.interpolate(points: pathPoints)
        layer1.path = path1.cgPath
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pathPoints[1] = midpoint
        
        path1.interpolate(points: pathPoints)
        layer1.path = path1.cgPath
    }
    
    override var shouldAutorotate: Bool {
        
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}

