//
//  Ext_UIView.swift
//  Chess App
//
//  Created by Christos Petimezas on 17/7/21.
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
                        self.alpha = 1.0
                       }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1.0,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
                        self.alpha = 0.0
                       }, completion: completion)
    }
}
