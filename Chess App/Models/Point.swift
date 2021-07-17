//
//  Point.swift
//  Chess App
//
//  Created by Christos Petimezas on 16/7/21.
//

import Foundation

struct Point: Equatable {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    /*
     Check if `(x, y)` is valid chessboard coordinates.
     Note that a knight cannot go out of the chessboard
     */
    func isValid(_ boardSize: Int) -> Bool {
        if (self.x < 0 || self.y < 0 || self.x >= boardSize || self.y >= boardSize) {
            return false
        }
        return true
    }
}
