//
//  ViewController.swift


import UIKit

class SetViewController: UIViewController {
  
  
  @IBOutlet weak var dealMoreThreeCardsButton: UIButton!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var cardDeskImage: UIImageView!
  
  @IBOutlet weak var discardPileImageView: UIImageView!
  @IBOutlet weak var viewForCards: UIView!
  
  var game = SetupGame()
  var result = 0
  var cardViews: [UIView] = []
  var isFirstTime = true
  var isNeedSetupView = false
  var animator: UIDynamicAnimator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    discardPileImageView.image = UIImage(named: "cardBack")
    discardPileImageView.alpha = 0.0
    scoreLabel.text = "score: 0"
    game.scoreCompletion = { score in
      self.result += score
      self.scoreLabel.text = "score: \(self.result)"
      
    }
    
    addCardViews()
    game.setupSets()
    setupGestureRecornizers()
    
    animator = UIDynamicAnimator(referenceView: self.viewForCards)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      self.animateCardView(for: self.cardViews.count - 1)
    }
    isNeedSetupView = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateGrid()
  }
  
  func setupGestureRecornizers() {
    cardViews.forEach {
      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCardTapGesture(_:)))
      $0.addGestureRecognizer(tapRecognizer)
    }
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addThreeCardByTapGesture))
    cardDeskImage.isUserInteractionEnabled = true
    cardDeskImage.addGestureRecognizer(tapRecognizer)
  }
  
  var viewRowsCount = 3
  var viewColumnCount = 4
  var gridCounts = 12
  
  func addCardViews() {
    if isFirstTime {
      isFirstTime = false
      for _ in 0...gridCounts - 1 {
        let cardView = UIView()
        cardViews.append(cardView)
        viewForCards.addSubview(cardView)
        cardView.alpha = 0.0
      }
    } else {
      gridCounts += 3
      viewRowsCount = Int(Float(gridCounts).squareRoot())
      viewColumnCount = gridCounts / viewRowsCount
      if viewColumnCount * viewRowsCount < gridCounts {
        viewColumnCount += 1
      }
      for _ in 0...2 {
        let cardView = UIView()
        cardViews.append(cardView)
        viewForCards.addSubview(cardView)
        cardView.alpha = 0.0
      }
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
    setupGestureRecornizers()
    discardPileImageView.alpha = 0.0
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      self.animateCardView(for: self.cardViews.count - 1)
    }
    isNeedSetupView = true
  }
  
  
  @IBAction func dealThreeMoreCardsButtonTapped(_ sender: UIButton) {
    dealThreeMoreCards()
  }
  
  private func dealThreeMoreCards() {
    if cardViews.count > game.cards.count {
      dealMoreThreeCardsButton.isEnabled = false
      cardDeskImage.gestureRecognizers?.first?.isEnabled = false
    }
    tappedCount = 1
    addCardViews()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      self.animateCardView(for: self.cardViews.count - 1)
    }
    isNeedSetupView = true
    setupGestureRecornizers()
  }
  
  private func updateGrid() {
    let grid = Grid(layout: .dimensions(rowCount: viewRowsCount, columnCount: viewColumnCount), frame: viewForCards.bounds)
    
    for (index,_) in cardViews.enumerated() {
      cardViews[index].frame = grid[index]!
      cardViews[index].layer.borderWidth = 2.0
      cardViews[index].layer.borderColor = UIColor.black.cgColor
      
    }
    
    if isNeedSetupView {
      isNeedSetupView = false
      setupView()
    }
  }
  
  private func animateCardView(for index: Int) {
    
    let group = DispatchGroup()
    let position = CABasicAnimation(keyPath: "position")
    position.fromValue = CGPoint(x: self.view.bounds.minX + 30, y: self.view.bounds.minY - 50)
    position.toValue = CGPoint(x: cardViews[index].frame.midX , y: cardViews[index].frame.midY)
    
    let transformScale = CABasicAnimation(keyPath: "transform.scale")
    transformScale.fromValue = CATransform3DScale(.init(), 0.1, 0.1, 1.0)
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.duration = 1
    groupAnimation.repeatCount = 1
    groupAnimation.animations = [position, transformScale]
    
    group.enter()
    let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2, delay: 0.0, options: .curveEaseOut) {
      self.cardViews[index].alpha = 1
      self.cardViews[index].layer.add(groupAnimation, forKey: nil)
      group.leave()
    } completion: { _ in
      UIView.transition(from: self.cardViews[index].subviews[1], to: self.cardViews[index].subviews[0], duration: 1, options: [.transitionFlipFromLeft])
    }
    animator.startAnimation()
    
    group.notify(queue: .main) {
      if self.cardViews.count <= 12 && index > 0 || self.cardViews.count > 12 && index > self.cardViews.count - 3 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
          self.animateCardView(for: index - 1)
        }
      }
    }
  }
  
  private func setupView() {
    
    for (index, view) in cardViews.enumerated() {
      cardViews[index].subviews.forEach { $0.removeFromSuperview() }
      let subView = CardView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
      
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
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height * 2 , width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      case 2:
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height + distance, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + (height * 2) + (distance * 2), width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      case 3:
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + height * 2 + distance, width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
        subView.prepareView(cgRect: CGRect(x: view.bounds.minX, y: view.bounds.minY + (height * 3) + (distance * 2), width: width, height: height), cornerRadius: cornerRadius, color: attributes.color, texture: attributes.texture)
      default:
        break
      }
      
      let backView = UIImageView(frame: subView.frame)
      backView.image = UIImage(named: "cardBack")
      view.addSubview(subView)
      view.addSubview(backView)
      
      if cardViews.count > 12 && index < cardViews.count - 3 {
        view.bringSubviewToFront(subView)
      }
    }
  }
  
  @objc func addThreeCardByTapGesture(_ sender: UISwipeGestureRecognizer) {
    dealThreeMoreCards()
    updateGrid()
  }
  
  
  var tappedCount = 1
  @objc func selectCardTapGesture(_ sender: UITapGestureRecognizer) {
    
    for (index,view) in cardViews.enumerated() {
      if sender.view == view && view.subviews.last?.backgroundColor == .gray {
        view.subviews.last?.backgroundColor = .cyan
        game.cards[index].isSelected = false
        tappedCount -= 1
      } else if sender.view == view {
        
        view.subviews.last?.backgroundColor = .gray
        game.cards[index].isSelected = true
        
        if tappedCount == 3 {
          let result = game.checkMatchingCard()
          if result {
            var animatedViews: [UIView] = []
            game.cards.removeAll { $0.isSelected == true }
            cardViews.removeAll(where: {$0.subviews.last?.backgroundColor == .gray})
            viewForCards.subviews.forEach {
              if $0.subviews.last?.backgroundColor == .gray {
                animatedViews.append($0)
              }
            }
            animatePassedResult(animatedViews: animatedViews)
            setupGestureRecornizers()
          } else {
            for (index, _) in game.cards.enumerated() {
              if game.cards[index].isSelected {
                game.cards[index].isSelected = false
              }
            }
            self.isNeedSetupView = false
            let alert = UIAlertController(title: "Wrong", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
              self.cardViews.forEach{ $0.subviews.first?.backgroundColor = .cyan}
            }))
            self.present(alert, animated: true)
          }
          tappedCount = 0
        }
        tappedCount += 1
      }
    }
  }
  
  func animatePassedResult(animatedViews: [UIView]) {
    let conteinerAnimatedView = UIView(frame: self.view.frame)
    conteinerAnimatedView.backgroundColor = .clear
    for view in animatedViews{
      conteinerAnimatedView.addSubview(view)
    }
    viewForCards.addSubview(conteinerAnimatedView)
    viewForCards.bringSubviewToFront(conteinerAnimatedView)
    
    
    let customBehiever = UIDynamicBehavior()
    let push = UIPushBehavior(items: animatedViews, mode: .continuous)
    let dinamicItem = UIDynamicItemBehavior(items: animatedViews)
    let collision = UICollisionBehavior(items: animatedViews)
    
    var offset = UIOffset(horizontal: 0, vertical: CGFloat.random(in: 150..<200))
    push.setTargetOffsetFromCenter(offset, for: animatedViews[0])
    offset = UIOffset(horizontal: 0, vertical: CGFloat.random(in: -200 ..< -150))
    push.setTargetOffsetFromCenter(offset, for: animatedViews[1])
    offset = UIOffset(horizontal: CGFloat.random(in: -200 ..< -150), vertical: 0)
    push.setTargetOffsetFromCenter(offset, for: animatedViews[2])
    push.pushDirection = CGVector(dx: CGFloat.random(in: -1 ..< -0.8), dy: CGFloat.random(in: -1 ..< -0.8))
    push.magnitude = 2.0 + Double.random(in: 0...2.0)
    dinamicItem.elasticity = 1.0
    dinamicItem.resistance = 1.0
    collision.translatesReferenceBoundsIntoBoundary = true
    
    customBehiever.addChildBehavior(dinamicItem)
    customBehiever.addChildBehavior(push)
    customBehiever.addChildBehavior(collision)
    
    self.animator.addBehavior(customBehiever)
    
    UIView.animate(withDuration: 3.0, delay: 1.0, options: .allowAnimatedContent) {
      animatedViews.forEach {$0.transform = CGAffineTransform(scaleX: 4, y: 4)}
      
    } completion: { _ in
      let moveCards = CABasicAnimation(keyPath: "position")
      moveCards.toValue = CGPoint(x: self.discardPileImageView.frame.maxX, y: self.discardPileImageView.frame.minY)
      moveCards.duration = 3.0
      animatedViews.forEach {$0.layer.add(moveCards, forKey: nil)}
      UIView.animate(withDuration: 3.0, delay: 0.0, options: .allowAnimatedContent) {
        animatedViews.forEach {$0.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)}
      } completion: { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
          self.discardPileImageView.transform = CGAffineTransform(rotationAngle: .pi/4)
          UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.discardPileImageView.alpha = 1.0
          })
        }
        self.viewForCards.subviews.forEach {
          if $0.subviews.last?.backgroundColor == .gray {
            $0.removeFromSuperview()
          }
        }
        conteinerAnimatedView.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.dealThreeMoreCards()
          self.updateGrid()
        }
      }
      self.animator.removeBehavior(customBehiever)
    }
  }
}

