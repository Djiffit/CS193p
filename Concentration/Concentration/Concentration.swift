//
//  Concentration.swift
//  Concentration
//
//  Created by Konsta Kutvonen on 15/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    var flippedIndex: Int?
    var isWon = false
    
    func flipCard(withIndex index: Int) {
        if index < cards.count, flippedIndex != index {
            let flipCard = cards[index]
            if !flipCard.isMatched {
                if flippedIndex != nil {
                    let prevCard = cards[flippedIndex!]
                    if prevCard.identifier == flipCard.identifier {
                        cards[index].isMatched = true
                        cards[flippedIndex!].isMatched = true
                    } else {
                        cards[index].isFaceUp = true
                    }
                    flippedIndex = nil
                } else {
                    for cardIndex in cards.indices {
                        cards[cardIndex].isFaceUp = false
                    }
                    cards[index].isFaceUp = true
                    flippedIndex = index
                }
            }
        }
        
        if !cards.contains { !$0.isMatched } {
            isWon = true
        }
    }
    
    init(numberOfPairs: Int) {
        for _ in 1...numberOfPairs {
            let card = Card()
            cards += [card, card]
        }
        
        for index in 0..<cards.count {
            let rand = Int(arc4random_uniform(UInt32(cards.count)))
            let placeholder = cards[index]
            cards[index] = cards[rand]
            cards[rand] = placeholder
        }
    }
}
