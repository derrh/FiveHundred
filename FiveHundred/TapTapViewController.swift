//
//  TapTapViewController.swift
//  FiveHundred
//
//  Created by Derrick Hathaway on 9/17/15.
//  Copyright © 2015 Derrick Hathaway. All rights reserved.
//

import UIKit

class TapTapViewController: UIViewController {

    @IBOutlet weak var tap: UIImageView!
    
    @IBOutlet weak var down: UIImageView!
    @IBOutlet weak var right: UIImageView!
    @IBOutlet weak var up: UIImageView!
    @IBOutlet weak var left: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGesture(.UpArrow, action: "tapUp")
        addGesture(.DownArrow, action: "tapDown")
        addGesture(.LeftArrow, action: "tapLeft")
        addGesture(.RightArrow, action: "tapRight")
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        view.addGestureRecognizer(pan)
    }
    
    func pan(gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .Began:
            tap.hidden = false
            fallthrough
        case .Changed:
            tap.center = gr.locationInView(view)
            
        default:
            tap.hidden = true
        }
    }
    
    
    func addGesture(direction: UIPressType, action: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        tap.allowedPressTypes = [NSNumber(integer: direction.rawValue)]
        view.addGestureRecognizer(tap)
    }
    
    func tapUp() {
        tapView(up)
    }
    
    func tapDown() {
        tapView(down)
    }
    
    func tapRight() {
        tapView(right)
    }
    
    func tapLeft() {
        tapView(left)
    }
    
    func tapView(view: UIView) {
        UIView.animateWithDuration(0.15, animations: {
            view.transform = CGAffineTransformMakeScale(0.8, 0.8)
            }) { _ in
                UIView.animateWithDuration(0.15, animations: {
                    view.transform = CGAffineTransformIdentity
                    }, completion: nil)
        }
    }
}
