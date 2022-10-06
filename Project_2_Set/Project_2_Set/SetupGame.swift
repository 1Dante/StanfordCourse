//
//  Card.swift
//  Project_2_Set
//
//  Created by Viktor on 13.07.2022.
//

import Foundation
import UIKit

class SetupGame {
  
  var attributesTitleOfCards: [AttributesOfCard] = []
  var cards: [Card] = []
  var scoreCompletion: ((_ score: Int) -> ())?
  
  
  func checkMatchingCard() {
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
    if !compareElements.contains(2) {
      scoreCompletion?(5)
    } else {
      scoreCompletion?(-3)
    }
  }
  
  func setupSets() {
    var itemsOfSet = 0
    while itemsOfSet <= 23 {
      let attributesOfCard = AttributesOfCard(color: UIColor.attributedColor, figure: Figure.allCases.randomElement()!, qtyOfChar: Int.attributedInt, texture: Texture.allCases.randomElement()!)
      if !attributesTitleOfCards.contains(where: {$0 == attributesOfCard} ) {
        attributesTitleOfCards.append(attributesOfCard)
        itemsOfSet += 1
      }
    }
  }
  
  func convertFromModelToAttributedText(attributeOfCard: AttributesOfCard) -> NSAttributedString {
    
    var text = String(repeating: attributeOfCard.figure.rawValue + "\n", count: attributeOfCard.qtyOfChar)
    text.removeLast()
    
    var attributeStringKey: [NSAttributedString.Key: Any] = [:]
    
    switch attributeOfCard.texture {
    case .fillFigure:
      attributeStringKey = [NSAttributedString.Key.strokeWidth: -1] //negative number filled up figure
      attributeStringKey.updateValue(attributeOfCard.color, forKey: NSAttributedString.Key.foregroundColor)
    case .emptyFigure:
      attributeStringKey = [NSAttributedString.Key.strokeWidth: 5]
      attributeStringKey.updateValue(attributeOfCard.color, forKey: NSAttributedString.Key.foregroundColor)
    case .hatchedFigure:
      attributeStringKey = [NSAttributedString.Key.foregroundColor: attributeOfCard.color.withAlphaComponent(0.15)]
    }
    
    attributeStringKey.updateValue(UIFont.systemFont(ofSize: 30), forKey: NSAttributedString.Key.font )
    
    return NSAttributedString(string: text, attributes: attributeStringKey)
  }
}


