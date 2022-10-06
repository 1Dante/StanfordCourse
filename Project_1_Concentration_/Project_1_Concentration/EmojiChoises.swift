//
//  EmojiChoises.swift
//  Project_1_Concentration
//
//  Created by Victor on 01.06.2022.
//

import Foundation


struct EmojiChoises {
  let theme: String
  var emoji: [String]

  static var emojiChoises: [EmojiChoises] = [EmojiChoises(theme: "animals", emoji: ["🐶","🐱","🐼","🐻"]),
                                             EmojiChoises(theme: "faces", emoji: ["😀","😇","🥹","🤯"]),
                                             EmojiChoises(theme: "food", emoji: ["🍐","🍎","🍇","🍆"]),
                                             EmojiChoises(theme: "drinks", emoji: ["🍷","☕️","🫖","🍺"]),
                                             EmojiChoises(theme: "sports", emoji: ["⚽️","🏀","🥎","🏉"]),
                                             EmojiChoises(theme: "subject", emoji: ["⌚️","📱","💻","🖥"])]
}

