//
//  Card.swift
//  Project_3_Graphical_Set
//
//  Created by Viktor on 13.07.2022.
//

import Foundation
import UIKit

class SetupGame {
  
  var attributesTitleOfCards: [AttributesOfCard] = []
  var cards: [Card] = []
  var scoreCompletion: ((_ score: Int) -> ())?
  
  func checkMatchingCard() -> Bool {
    var selectedCards: [AttributesOfCard] = []
    cards.forEach {
      if $0.isSelected == true {
        selectedCards.append($0.attributesCard)
      }
    }
    
    var qtyOfChar: [Int] = []
    var color: [UIColor] = []
    var figure: [Figure] = []
    var texture: [Texture] = []
    selectedCards.forEach { attribute in
      qtyOfChar.append(attribute.qtyOfChar)
      color.append(attribute.color)
      figure.append(attribute.figure)
      texture.append(attribute.texture)
    }
    
    let compareElements = [Set(qtyOfChar).count,Set(color).count,Set(figure).count,Set(texture).count]
    print(compareElements.count)
    if !compareElements.contains(2) {
      scoreCompletion?(5)
      return true
    } else {
      scoreCompletion?(-3)
      return false
    }
  }
  
  func setupSets() {
    var itemsOfSet = 0
    while itemsOfSet < 81 {
      let attributesOfCard = AttributesOfCard(color: UIColor.attributedColor, figure: Figure.allCases.randomElement()!, qtyOfChar: Int.attributedInt, texture: Texture.allCases.randomElement()!)
      if !attributesTitleOfCards.contains(where: {$0 == attributesOfCard} ) {
        attributesTitleOfCards.append(attributesOfCard)
        itemsOfSet += 1
      }
    }
    attributesTitleOfCards.forEach { cards.append(Card(isSelected: false, attributesCard: $0))}
  }
}


