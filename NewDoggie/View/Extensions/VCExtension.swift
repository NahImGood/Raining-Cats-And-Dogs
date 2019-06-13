//
//  VCExtension.swift
//  NewDoggie
//
//  Created by Eli Warner on 6/12/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

public class DraggableViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))
    }
    
    //MARK - Pull down to dismiss
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.0, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}

