//
//  SnapAnimation.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 4/6/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class SnapAnimation: CABasicAnimation {
    
    override init() {
        super.init()
    }
    
    init(in superlayer: CAShapeLayer, path elasticPath: UIBezierPath, order: Int) {
        super.init()
        self.keyPath = "path"
        self.duration = 0.5
        self.fromValue = superlayer.path
        self.toValue = elasticPath.cgPath
        self.timeOffset = self.duration * Double(order)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
