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
    
    @IBOutlet var cardList: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var winLabel: UIButton!
    @IBOutlet weak var flipLabel: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var clock: UILabel!
    
    lazy var theme = themes["🇫🇮"]!
    var cardMap = [Int:String]()
    var themes = [
        "🇫🇮": Theme(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),  ["🇦🇺", "🇦🇹", "🇦🇿", "🇧🇸", "🇧🇭", "🇧🇩", "🇧🇧", "🇧🇾", "🇧🇪", "🇧🇷", "🇨🇦", "🇨🇱", "🇨🇮", "🇩🇰", "🇪🇬", "🇫🇴", "🇫🇮", "🇸🇻", "🇪🇺", "🇩🇪", "🇮🇸", "🇯🇲", "🇯🇵", "🇱🇻", "🇳🇱", "🇳🇴"], #colorLiteral(red: 0.043926768, green: 0.01171275042, blue: 0.007308681495, alpha: 1)),
        "😀": Theme(#colorLiteral(red: 0.8440151215, green: 0.07041918486, blue: 0.7130127549, alpha: 1), ["😅", "😂", "😇", "😍", "😜", "🧐","🤪","😎","🤩","😟","😢","😭","🤬","😡","😱","😳","🤯","😴","😵","🤧","🤮","🤠","🤕"], #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)),
        "👻": Theme(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), ["💀", "☠️", "👻", "👽", "👾", "🧜‍♂️","🧟‍♂️","🧞‍♂️","🧞‍♀️","🧛‍♀️","🧛‍♂️","🧟‍♀️","🎃","👀","👁","👅","👂🏼","😡","🤬","😈","👿","🤡","👺"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "🍎": Theme(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), ["🍎", "🍏", "🍐", "🍊", "🍋", "🍌","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥕","🌽","🌶","🥒","🥦","🥑"], #colorLiteral(red: 0.6221042871, green: 0.09209621698, blue: 0.5389434695, alpha: 1)),
    ]
    
    lazy var emojis = themes["😀"]!.emojis
    var timer = Timer()
    
    override func viewDidLoad() {
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateClock)
    }
    
    func updateClock(timer clocker: Timer) {
        model.incrementTimer()
        if model.isWon {
            timer.invalidate()
        }
        let modulo = model.timer % 60
        let minutes = Int(floor(Double(model.timer) / Double(60)))
        clock.text = "\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(modulo < 10 ? "0\(modulo)" : "\(modulo)")"
        scoreLabel.text = "Score: \(model.score)"
    }
    
    func setTheme() {
        for card in cardList {
            card.backgroundColor = theme.cardColor
        }
        scoreLabel.textColor = theme.cardColor
        flipLabel.textColor = theme.cardColor
        background.backgroundColor = theme.backgroundColor
    }
    
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
        theme = themes[sender.currentTitle!]!
        emojis = theme.emojis
        model = Concentration(numberOfPairs: (cardList.count) / 2)
        updateCards()
        setTheme()
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
                    cardUI.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cardUI.setTitle(getEmoji(forId: cardModel.identifier), for: UIControlState.normal)
                } else {
                    cardUI.backgroundColor = theme.cardColor
                }
            }
        }
        
        if model.isWon {
            winLabel.isHidden = false
        } else {
            winLabel.isHidden = true
        }
        
        scoreLabel.text = "Score: \(model.score)"
        flipLabel.text = "Flips: \(model.flips)"
    }
    
    @IBAction func flipCard(_ sender: UIButton) {
        if let cardIndex = cardList.index(of: sender) {
            model.flipCard(withIndex: cardIndex)
        } else {
            print("Not registered card!!")
        }
        updateCards()
    }
    
}

