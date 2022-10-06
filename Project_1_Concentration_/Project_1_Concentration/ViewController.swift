//
//  ViewController.swift
//  Project_1_Concentration
//
//  Created by Victor on 15.05.2022.
//

import UIKit

class ViewController: UIViewController {


  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet var cardButtons: [UIButton]!
  @IBOutlet weak var flipCountLabel: UILabel!

  lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

  var emoji: [Int: String] = [:]
  var emojiChoises = EmojiChoises.emojiChoises
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func touchCard(_ sender: UIButton) {

    if let cardNumber = cardButtons.firstIndex(of: sender) {
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    }
  }

  @IBAction func newGameButtonTapped(_ sender: UIButton) {
    game.flipCount = 0
    game.score = 0
    emoji = [:]
    emojiChoises = EmojiChoises.emojiChoises

    flipCountLabel.text = "Flips: \(game.flipCount)"
    scoreLabel.text = "Score: \(game.score)"
    game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    for (index, button) in cardButtons.enumerated() {
      button.backgroundColor = .orange
      button.setTitle("", for: .normal)
      game.cards[index].isMatched = false
      game.cards[index].isFaceUp = false
      Card.identifierFactory = 0
    }
  }

  func updateViewFromModel() {
    game.flipCount += 1
    flipCountLabel.text = "Flips: \(game.flipCount)"
    scoreLabel.text = "Score: \(game.score)"
    for index in cardButtons.indices {
      let button = cardButtons[index]
      let card = game.cards[index]
      if card.isFaceUp {
        button.setTitle(emoji(for: card), for: .normal)
        for item in EmojiChoises.emojiChoises where item.emoji.contains(button.currentTitle ?? ""){
          switch item.theme {
          case "animals":
            button.backgroundColor = .gray
          case "faces":
            button.backgroundColor = .cyan
          case "food":
            button.backgroundColor = .magenta
          case "drinks":
            button.backgroundColor = .blue
          case "sports":
            button.backgroundColor = .lightGray
          case "subject":
            button.backgroundColor = .white
          default:
            button.backgroundColor = .white
          }
        }
      } else {
        button.setTitle("", for: .normal)
        button.backgroundColor = card.isMatched ? .clear : .orange
      }
    }
  }

  func emoji(for card: Card) -> String {

    if emoji[card.identifier] == nil, emojiChoises.count > 0 {
      for (index, item) in emojiChoises.enumerated() where item.emoji.count == 0 {
        emojiChoises.remove(at: index)
      }
      let randomThemes = Int(arc4random_uniform(UInt32(emojiChoises.count)))
      let emojes = emojiChoises[randomThemes].emoji
      let randomEmoji = Int(arc4random_uniform(UInt32(emojes.count)))
      emoji[card.identifier] = emojiChoises[randomThemes].emoji.remove(at: randomEmoji)
    }
    return  emoji[card.identifier] ?? "?"
  }
}
