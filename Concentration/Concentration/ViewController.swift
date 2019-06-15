//
//  ViewController.swift
//  Concentration
//
//  Created by Konsta Kutvonen on 15/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var model = Concentration(numberOfPairs: (cardList.count) / 2)
    
    var flipCounter = 0 {
        didSet {
            scoreLabel.text = "Flips: \(flipCounter)"
        }
    }
    
    @IBOutlet var cardList: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var emojis = ["🇦🇺", "🇦🇹", "🇦🇿", "🇧🇸", "🇧🇭", "🇧🇩", "🇧🇧", "🇧🇾", "🇧🇪", "🇧🇷", "🇨🇦", "🇨🇱", "🇨🇮", "🇩🇰", "🇪🇬", "🇫🇴", "🇫🇮", "🇸🇻", "🇪🇺", "🇩🇪", "🇮🇸", "🇯🇲", "🇯🇵", "🇱🇻", "🇳🇱", "🇳🇴"]
    
    var cardMap = [Int:String]()
    
    @IBOutlet weak var winLabel: UIButton!
    
    func getEmoji(forId identifier: Int) -> String {
        if cardMap[identifier] == nil {
            if emojis.count > 0 {
                let random = Int(arc4random_uniform(UInt32(emojis.count)))
                cardMap[identifier] = emojis.remove(at: random)
            }
        }
        return cardMap[identifier] ?? "?"
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        flipCounter = 0
        model = Concentration(numberOfPairs: (cardList.count) / 2)
        updateCards()
        emojis = ["🇦🇺", "🇦🇹", "🇦🇿", "🇧🇸", "🇧🇭", "🇧🇩", "🇧🇧", "🇧🇾", "🇧🇪", "🇧🇷", "🇨🇦", "🇨🇱", "🇨🇮", "🇩🇰", "🇪🇬", "🇫🇴", "🇫🇮", "🇸🇻", "🇪🇺", "🇩🇪", "🇮🇸", "🇯🇲", "🇯🇵", "🇱🇻", "🇳🇱", "🇳🇴"]
    }
    
    func updateCards() {
        for cardIndex in 0..<model.cards.count {
            let cardModel = model.cards[cardIndex]
            let cardUI = cardList[cardIndex]
            cardUI.setTitle("", for: UIControlState.normal)
            
            if cardModel.isMatched {
                cardUI.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            } else {
                if cardModel.isFaceUp {
                    cardUI.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cardUI.setTitle(getEmoji(forId: cardModel.identifier), for: UIControlState.normal)
                } else {
                    cardUI.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
        
        if model.isWon {
            winLabel.isHidden = false
        } else {
            winLabel.isHidden = true
        }
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        if let cardIndex = cardList.index(of: sender) {
            if !model.cards[cardIndex].isFaceUp, !model.cards[cardIndex].isMatched {
                flipCounter += 1
            }
            model.flipCard(withIndex: cardIndex)
        } else {
            print("Not registered card!!")
        }
        updateCards()
    }
    
}

