//
//  ViewController.swift
//  Set
//
//  Created by Konsta Kutvonen on 16/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var model = SetModel()
    
    @IBOutlet var cardList: [UIButton]! {
        didSet {
            drawCards()
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        model = SetModel()
        drawCards()
        updateScore()
    }
    
    @IBOutlet weak var dealButton: UIButton! {
        didSet {
            dealButton.layer.cornerRadius = 8.0
            dealButton.layer.borderWidth = 3
            dealButton.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBAction func cheat(_ sender: UIButton) {
        if model.nextMove() {
            drawCards()
        }
        updateScore()
    }
    
    override func viewDidLoad() {
        for index in 0..<cardList.count {
            let rand = Int(arc4random_uniform(UInt32(cardList.count)))
            let placeholder = cardList[index]
            cardList[index] = cardList[rand]
            cardList[rand] = placeholder
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if String(describing: sender.attributedTitle(for: UIControlState.normal)!) != "" {
            model.touch(model.dealtCards[cardList.index(of: sender)!])
            drawCards()
        }
        updateScore()
    }
    
    @IBAction func dealCards(_ sender: UIButton) {
        model.deal()
        drawCards()
        updateScore()
    }
    
    private func getGNCColor(for color: CardColor) -> CGColor {
        switch color {
            case .blue:
                return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            case .orange:
                return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            case .purple:
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
    }
    
    private func getColor(for color: CardColor, with shading: Shading) -> UIColor {
        let col: UIColor
        let alpha: CGFloat
        switch shading {
            case .empty:
                alpha = CGFloat(0)
            case .solid:
                alpha = CGFloat(1)
            case .striped:
                alpha = CGFloat(0.3)
        }
        
        switch color {
            case .blue:
                col = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .orange:
                col = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            case .purple:
                col = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        
        return col.withAlphaComponent(alpha)
    }
    
    func updateScore() {
        pointLabel.text = "👉🏻 \(model.score)"
    }
    
    private func drawCards() {
        for cardIndex in cardList.indices {
            let cardUI = cardList[cardIndex]
            if cardIndex < model.dealtCards.count {
                let card = model.dealtCards[cardIndex]
                let strokeTextAttributes: [NSAttributedStringKey: Any] = [
                    .strokeColor : getColor(for: card.color, with: Shading.solid),
                    .foregroundColor : getColor(for: card.color, with: card.shading),
                    .strokeWidth : -5.0,
                ]
                let astring = NSAttributedString(string: String(repeating: (card.type.rawValue), count: card.value), attributes: strokeTextAttributes)
                
                cardUI.setAttributedTitle(astring, for: UIControlState.normal)
                cardUI.layer.borderWidth = 3
                cardUI.layer.borderColor = getGNCColor(for: card.color)
                cardUI.layer.cornerRadius = 8.0
                cardUI.isHidden = false
                cardUI.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cardUI.contentEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
                if model.selectedCards.contains(card) {
                    cardUI.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                    if model.selectedCards.count == 3 {
                        let state = model.isSet()
                        cardUI.backgroundColor = state ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    }
                }
            } else {
                cardUI.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardUI.setTitle("", for: UIControlState.normal)
                cardUI.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardUI.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
            }
        }
    }
}

