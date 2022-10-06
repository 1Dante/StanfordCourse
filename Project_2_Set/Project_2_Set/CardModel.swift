//
//  AttributesOfCard.swift
//  Project_2_Set
//
//  Created by Viktor on 28.07.2022.
//

import UIKit


struct Card {
  
  var isSelected: Bool
  var attributesCard: AttributesOfCard
}

struct AttributesOfCard {
  var color: UIColor
  var figure: Figure
  var qtyOfChar: Int
  var texture: Texture
}

extension AttributesOfCard: Equatable, Hashable {
  func hash(into hasher: inout Hasher) {
      hasher.combine(color)
      hasher.combine(figure)
    hasher.combine(texture)
  }
}


enum Figure: String, CaseIterable {
  case circle = "●"
  case triangle = "▲"
  case square = "■"
}

enum QtyOfChar: Int, CaseIterable {
  case one = 1
  case two = 2
  case three = 3
}

enum Texture: CaseIterable {
  
  case fillFigure
  case emptyFigure
  case hatchedFigure

}
