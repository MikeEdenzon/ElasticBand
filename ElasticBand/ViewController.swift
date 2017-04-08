//
//  ViewController.swift
//  ElasticBand
//
//  Created by Michael Edenzon on 10/12/16.
//  Copyright © 2016 Michael Edenzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(InteractiveView(frame: view.frame))
    }
    
    override var shouldAutorotate: Bool {
        
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}



