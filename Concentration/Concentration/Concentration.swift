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
    var seenCards = Set<Int>()
    var flippedIndex: Int?
    var isWon = false
    var flips = 0
    var score = 0
    var timer = 0
    var started = false
    
    
    func calculateScore(for index: Int, withResult match: Bool) {
        let change = match ? 100 : -50
        
        if seenCards.contains(index) {
            score += change
        } else {
            seenCards.insert(index)
            if match {
                score += 100
            }
        }
    }
    
    func incrementTimer() {
        if started {
            timer += 1
            score -= 10
        }
    }
    
    func flipCard(withIndex index: Int) {
        if !started {
            started = true
        }
        
        if index < cards.count, flippedIndex != index {
            flips += 1
            let flipCard = cards[index]
            if !flipCard.isMatched {
                if flippedIndex != nil {
                    let prevCard = cards[flippedIndex!]
                    let match = prevCard.identifier == flipCard.identifier
                    if match {
                        cards[index].isMatched = true
                        cards[flippedIndex!].isMatched = true
                    } else {
                        cards[index].isFaceUp = true
                    }
                    
                    calculateScore(for: flippedIndex!, withResult: match)
                    calculateScore(for: index, withResult: match)
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
