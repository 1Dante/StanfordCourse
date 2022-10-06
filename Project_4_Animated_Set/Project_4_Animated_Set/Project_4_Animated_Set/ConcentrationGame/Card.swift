//
//  Card.swift
//  Project_1_Concentration
//
//  Created by Victor on 15.05.2022.
//

import Foundation

struct CardConcentration {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        self.identifier = CardConcentration.getUniqueIdentifier()
    }
}
