//
//  ViewController.swift
//  Project_3_Graphical_Set
//
//  Created by Victor on 01.06.2022.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var dealMoreThreeCardsButton: UIButton!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet weak var viewForCards: UIView!
  
  var game = SetupGame()
  var result = 0
  var cardViews: [CardView] = []
  var isFirstTime = true
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scoreLabel.text = "score: 0"
    game.scoreCompletion = { score in
      self.result += score
      self.scoreLabel.text = "score: \(self.result)"
    }
    
    addCardViews()
    game.setupSets()
    setupGestureRecornizers()
    cardViews.forEach { viewForCards.addSubview($0) }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateGrid()
  }
  
  func setupGestureRecornizers() {
    let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(shufleCardsByRotateGesture(_:)))
    viewForCards.addGestureRecognizer(rotationGestureRecognizer)
    let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCardBySwipeDownTapGesture(_:)))
    swipeDownRecognizer.direction = .down
    viewForCards.addGestureRecognizer(swipeDownRecognizer)
    cardViews.forEach {
      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCardTapGesture(_:)))
      $0.addGestureRecognizer(tapRecognizer) }
  }
  
  var viewRowsCount = 3
  var viewColumnCount = 4
  var gridCounts = 12
  
  func addCardViews() {
    if isFirstTime {
      isFirstTime = false
    } else {
      gridCounts += 3
      print("gridcount\(gridCounts)")
      viewRowsCount = Int(Float(gridCounts).squareRoot())
      viewColumnCount = gridCounts / viewRowsCount
      if viewColumnCount * viewRowsCount < gridCounts {
        viewColumnCount += 1
      }
    }
    for _ in 1...gridCounts {
      let cardView = CardView()
      cardViews.append(cardView)
    }
  }

  @IBAction func newGameButtonTapped(_ sender: UIButton) {
    result = 0
    scoreLabel.text = "score: 0"
    viewForCards.subviews.forEach {$0.removeFromSuperview()}
    viewRowsCount = 3
    viewColumnCount = 4
    gridCounts = 12
    isFirstTime = true
    cardViews = []
    game.attributesTitleOfCards = []
    game.cards = []
    game.setupSets()
    addCardViews()
    tappedCount = 1
    cardViews.forEach { viewForCards.addSubview($0) }
    setupGestureRecornizers()
  }
  
  
  @IBAction func dealThreeMoreCardsButtonTapped(_ sender: UIButton) {
    setupGestureRecornizers()
    if cardViews.count > game.cards.count {
      dealMoreThreeCardsButton.isEnabled = false
    }
    
    viewForCards.subviews.forEach {$0.removeFromSuperview()}
    cardViews = []
    tappedCount = 1
    addCardViews()
    cardViews.forEach { viewForCards.addSubview($0) }
    setupGestureRecornizers()
  }
  
  func updateGrid() {
    let grid = Grid(layout: .dimensions(rowCount: viewRowsCount, columnCount: viewColumnCount), frame: viewForCards.bounds)
    
    for (index,_) in cardViews.enumerated() {
      cardViews[index].frame = grid[index]!
      cardViews[index].layer.borderWidth = 2.0
      cardViews[index].layer.borderColor = UIColor.black.cgColor
    }
    setupView()
  }
  
  func setupView() {
    
    for (index, view) in cardViews.enumerated() {
      
      let attributes = game.cards[index].attributesCard
      
      var cornerRadius: CGFloat = 1
      switch attributes.figure {
      case .circle:
        cornerRadius = 100
      case .triangle:
        cornerRadius = 50 // lets mean that need draw Squiggle figure
      case .square:
        cornerRadius = 0
      }
      
      let height = view.bounds.height / 6
      let width = view.bounds.width / 3
      var distance: CGFloat = 0
      cardViews.count > 27 ? (distance = 10) : (distance = 20)
      
      switch attributes.qtyOfChar {
      case 1:
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height * 2 , width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      case 2:
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height + distance, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + (height * 2) + (distance * 2), width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      case 3:
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height * 2 + distance, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        view.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + (height * 3) + (distance * 2), width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      default:
        break
      }
    }
  }
  
  @objc func shufleCardsByRotateGesture(_ sender: UIGestureRecognizer){
    if sender.state == .began {
      viewForCards.subviews.forEach {$0.removeFromSuperview()}
      game.cards.shuffle()
      cardViews = []
      isFirstTime = true
      addCardViews()
      cardViews.forEach { viewForCards.addSubview($0)}
      updateGrid()
    }
  }
  
  @objc func addThreeCardBySwipeDownTapGesture(_ sender: UISwipeGestureRecognizer) {
    viewForCards.subviews.forEach {$0.removeFromSuperview()}
    cardViews = []
    addCardViews()
    cardViews.forEach { viewForCards.addSubview($0)}
    updateGrid()
  }
  
  var tappedCount = 1
  @objc func selectCardTapGesture(_ sender: UITapGestureRecognizer) {
    for (index,view) in cardViews.enumerated() {
      if sender.view == view && view.backgroundColor == .gray {
        view.backgroundColor = .cyan
        game.cards[index].isSelected = false
        tappedCount -= 1
      } else if sender.view == view {
        view.backgroundColor = .gray
        game.cards[index].isSelected = true
        if tappedCount == 3 {
          let result = game.checkMatchingCard()
          if result {
            game.cards.removeAll { $0.isSelected == true }
            viewForCards.subviews.forEach {$0.removeFromSuperview()}
            cardViews = []
            addCardViews()
            cardViews.forEach { viewForCards.addSubview($0)}
            setupGestureRecornizers()
            updateGrid()
          } else {
            for (index, _) in game.cards.enumerated() {
              if game.cards[index].isSelected {
                game.cards[index].isSelected = false
              }
            }
            
            let alert = UIAlertController(title: "Wrong", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
              self.cardViews.forEach{ $0.backgroundColor = .cyan}
            }))
            self.present(alert, animated: true)
          }
          tappedCount = 0
        }
        tappedCount += 1
      }
    }
  }
}

