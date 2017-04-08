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
    
    var elastic: ElasticLayer!
    var anchorPoint: CGPoint!
    var activePoint: CGPoint!
    var releasePoint: CGPoint!
    var path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        elastic = ElasticLayer(frame: self.frame, color: UIColor.blue)
        let offset = self.frame.width / 10
        elastic.setAnchorPoints(left: CGPoint(x: offset, y: center.y), right: CGPoint(x: self.frame.width - offset, y: center.y))
        elastic.bend(to: center)
        self.layer.addSublayer(elastic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previousTouch = touch.precisePreviousLocation(in: self)
            let currentTouch = touch.preciseLocation(in: self)
            elastic.cross(between: previousTouch, and: currentTouch)
            if elastic.active {
                elastic.bend(to: currentTouch)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previousTouch = touch.precisePreviousLocation(in: self)
            let currentTouch = touch.preciseLocation(in: self)
            elastic.cross(between: previousTouch, and: currentTouch)
            if elastic.active {
                elastic.bend(to: currentTouch)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        elastic.snapback(from: (touches.first?.preciseLocation(in: self))!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

