//
//  Card.swift
//  Set
//
//  Created by Konsta Kutvonen on 16/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import Foundation
import UIKit

struct Card: Hashable {
    private static var cardCounter = 0
    let type: Symbol
    let value: Int
    let color: CardColor
    let shading: Shading
    let identifier = Card.getIdentifier()
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static let colors = [CardColor.purple, CardColor.blue, CardColor.orange]
    private static let symbols = [Symbol.circle, Symbol.square, Symbol.triangle]
    private static let shadings = [Shading.empty, Shading.solid, Shading.striped]
    
    static func createCards() -> [Card] {
        var cards = [Card]()
        for color in Card.colors {
            for type in Card.symbols {
                for value in 1...3 {
                    for shading in Card.shadings {
                        cards += [Card(type: type, value: value, color: color, shading: shading)]
                    }
                }
            }
        }
        
        assert(cards.count == 81, "Invalid created card count")
        return cards
    }
    
    private static func getIdentifier() -> Int {
        cardCounter += 1
        return cardCounter
    }
}
