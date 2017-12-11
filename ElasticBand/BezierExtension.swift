//
//  BezierExtension.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 10/12/16.
//  Copyright © 2016 Michael Edenzon. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    func interpolateQuadCurve(from points: [CGPoint]) {
        
        guard points.count > 1 else { return }
        
        self.removeAllPoints()
        self.move(to: points[0])
        self.addQuadCurve(to: points[2], controlPoint: points[1])
    }
    
    static func interpolatedQuadCurve(from points: [CGPoint]) -> UIBezierPath {
        
        guard !points.isEmpty else { return UIBezierPath() }
        
        let path = UIBezierPath()
        
        path.move(to: points[0])
        path.addQuadCurve(to: points[2], controlPoint: points[1])
        
        return path
    }
}
