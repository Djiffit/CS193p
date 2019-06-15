//
//  Card.swift
//  Concentration
//
//  Created by Konsta Kutvonen on 15/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import Foundation


struct Card {
    var isMatched = false
    var isFaceUp = false
    let identifier: Int
    
    static var idCounter = 0
    
    static func getIdentifier() -> Int {
        idCounter += 1
        return idCounter
    }

    init() {
        identifier = Card.getIdentifier()
    }
}
