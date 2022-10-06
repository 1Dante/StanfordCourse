//
//  Concentration.swift
//  Project_1_Concentration
//
//  Created by Victor on 15.05.2022.
//

import Foundation

class Concentration {
    var cards: [CardConcentration] = []
    var indexOfoneAndOnlyFaceUpCard: Int?
    var flipCount = 0
    var score = 0

    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = CardConcentration()
            cards += [card, card]
            cards.shuffle()
        }
    }

    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfoneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                cards[index].isFaceUp = true
                indexOfoneAndOnlyFaceUpCard = nil
                if !cards[index].isMatched && score > 0 {
                    score -= 1
                }
            } else {
                //either no cards or 2 cards are face up
                for flipDownindex in cards.indices {
                    cards[flipDownindex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfoneAndOnlyFaceUpCard = index
            }
        }
    }
}
