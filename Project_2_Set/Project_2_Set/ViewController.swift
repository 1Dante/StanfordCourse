//
//  ViewController.swift
//  Project_2_Set
//
//  Created by Victor on 01.06.2022.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var dealMoreThreeCardsButton: UIButton!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet var cardsButtonSet: [UIButton]!
  var game = SetupGame()
  var result = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    game.setupSets()
    setupView()
  }
  
  
  
  var buttonTappedCount = 0
  @IBAction func cardButtonTapped(_ sender: UIButton) {
    let index = cardsButtonSet.firstIndex(of: sender)!
    if (cardsButtonSet.firstIndex(of: sender) != nil) {
      if buttonTappedCount <= 2 && sender.backgroundColor == .lightGray {
        game.cards[index].isSelected = false
        buttonTappedCount -= 1
        result -= 1
        sender.backgroundColor = .clear
      } else {
        game.cards[index].isSelected = true
        sender.backgroundColor = .lightGray
        buttonTappedCount += 1
        if buttonTappedCount == 3 {
          game.checkMatchingCard()
          dealMoreThreeCardsButton.isEnabled = true
          cardsButtonSet.forEach { $0.isEnabled = false }
          if game.attributesTitleOfCards.isEmpty {
            dealMoreThreeCardsButton.isEnabled = false
            let alert = UIAlertController(title: "Game is over", message: "your score: \(result)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
          }
        }
      }
    }
    
  }
  
  @IBAction func newGameButtonTapped(_ sender: UIButton) {
    game.attributesTitleOfCards = []
    game.cards = []
    game.setupSets()
    setupView()
    cardsButtonSet.forEach { $0.isEnabled = true }
    buttonTappedCount = 0
  }
  
  @IBAction func dealThreeMoreCardsButtonTapped(_ sender: UIButton) {
    dealMoreThreeCardsButton.isEnabled = false
    
    for card in cardsButtonSet {
      if card.backgroundColor == .lightGray {
        card.setAttributedTitle(game.convertFromModelToAttributedText(attributeOfCard: game.attributesTitleOfCards.first!), for: .normal)
        if  let index = game.cards.firstIndex(where: {$0.isSelected == true}) {
          game.cards[index].isSelected = false
          game.cards[index].attributesCard = game.attributesTitleOfCards.first!
          game.attributesTitleOfCards.removeFirst()
        }
      }
      card.isEnabled = true
      card.backgroundColor = .clear
    }
    buttonTappedCount = 0
  }
  
  func setupView() {
    for (index,card) in cardsButtonSet.enumerated() {
      card.layer.borderWidth = 3.0
      card.layer.borderColor = UIColor.black.cgColor
      card.setAttributedTitle(game.convertFromModelToAttributedText(attributeOfCard: game.attributesTitleOfCards[index]), for: .normal)
      game.cards.append(Card(isSelected: false, attributesCard: game.attributesTitleOfCards[index]))
      game.attributesTitleOfCards.remove(at: index)
      card.backgroundColor = .clear
    }
    dealMoreThreeCardsButton.isEnabled = false
    result = 0
    scoreLabel.text = "score: 0"
    game.scoreCompletion = { score in
      self.result += score
      self.scoreLabel.text = "score: \(self.result)"
    }
  }
}
