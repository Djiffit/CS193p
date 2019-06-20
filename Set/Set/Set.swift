//
//  Set.swift
//  Set
//
//  Created by Konsta Kutvonen on 16/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import Foundation

struct SetModel {
    private(set) var deck = [Card]()
    private(set) var dealtCards = [Card]()
    private(set) var selectedCards = [Card]() {
        willSet {
            if selectedCards.count == 3 {
                if isSet() {
                    score += 5
                } else {
                    score -= 3
                }
            }
        }
    }
    private(set) var score = 0
    
    private func testSet(_ selectedCards: [Card]) -> Bool {
        let values = Set(selectedCards.map {$0.value}).count
        let colors = Set(selectedCards.map {$0.color}).count
        let shading = Set(selectedCards.map {$0.shading}).count
        let shapes = Set(selectedCards.map {$0.type}).count
        
        return ([values, colors, shading, shapes].filter {$0 == 2}).count == 0
    }
    
    func isSet() -> Bool {
        return testSet(selectedCards)
    }
    
    mutating func touch(_ card: Card) {
        assert(dealtCards.contains(card), "Card not in dealt cards")
        if !selectedCards.contains(card) || selectedCards.count == 3 {
            if selectedCards.count == 3 {
                if isSet() {
                    removeSet()
                }
                selectedCards = [Card]()
            } else {
                selectedCards += [card]
            }
        } else {
            selectedCards.remove(at: selectedCards.firstIndex(of: card)!)
        }
    }
    
    mutating private func removeSet() {
        for card in selectedCards {
            dealtCards.remove(at: dealtCards.firstIndex(of: card)!)
        }
        selectedCards = [Card]()
        deal()
    }
    
    mutating func deal() {
        if isSet(), selectedCards.count == 3 {
            removeSet()
        } else {
            for _ in 0..<3 {
                if dealtCards.count < 24, deck.count > 0 {
                    dealtCards += [deck.remove(at: 0)]
                }
            }
            selectedCards = [Card]()
        }
    }
    
    mutating func nextMove() -> Bool {
        if dealtCards.count > 3 {
            for first in 0..<(dealtCards.count - 2) {
                for second in (first + 1)..<(dealtCards.count - 1) {
                    for third in (second + 1)..<dealtCards.count {
                        let test = [dealtCards[first], dealtCards[second], dealtCards[third]]
                        
                        if testSet(test) {
                            selectedCards = test
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    mutating func shuffle() {
        for index in 0..<deck.count {
            let rand = Int(arc4random_uniform(UInt32(deck.count)))
            let placeholder = deck[index]
            deck[index] = deck[rand]
            deck[rand] = placeholder
        }
    }
    
    init() {
        deck = Card.createCards()
        shuffle()
        for _ in 0...3 {
            deal()
        }
    }
}
