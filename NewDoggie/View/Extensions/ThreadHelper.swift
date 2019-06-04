//
//  ThreadHelper.swift
//  NewDoggie
//
//  Created by Eli Warner on 6/4/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public enum QueueType {
        case Main
        case Background
        case LowPriority
        case HighPriority
        
        var queue: DispatchQueue {
            switch self {
            case .Main:
                return DispatchQueue.main
            case .Background:
                return DispatchQueue(label: "com.app.queue",
                                     qos: .background,
                                     target: nil)
            case .LowPriority:
                return DispatchQueue.global(qos: .userInitiated)
            case .HighPriority:
                return DispatchQueue.global(qos: .userInitiated)
            }
        }
    }
    
    func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
        queueType.queue.async(execute: closure)
    }

}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
