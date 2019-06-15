//
//  Theme.swift
//  Concentration
//
//  Created by Konsta Kutvonen on 15/06/2019.
//  Copyright © 2019 Don Wouge. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    let cardColor: UIColor
    let emojis: [String]
    let backgroundColor: UIColor
    
    init(_ cardColor: UIColor, _ emojis: [String], _ backgroundColor: UIColor) {
        self.cardColor = cardColor
        self.emojis = emojis
        self.backgroundColor = backgroundColor
    }
}
