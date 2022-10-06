//
//  CardView.swift
//  Project_3_Graphical_Set
//
//  Created by Viktor on 02.08.2022.
//

import UIKit

class CardView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .cyan
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) { }
  
  func prepareView(cgRect: CGRect, cornerRadius: CGFloat, color: UIColor, texture: Texture) {
    
    let shapeMask = CAShapeLayer()
    let path = UIBezierPath(roundedRect: CGRect(x: cgRect.maxX, y: cgRect.minY, width: cgRect.width, height: cgRect.height) , cornerRadius: cornerRadius)
    shapeMask.path = path.cgPath
    
    switch texture {
    case .fillFigure:
      if cornerRadius == 50 {
        shapeMask.path = drawSquigglePath(frames: path.bounds).cgPath
        shapeMask.frame = CGRect(x: cgRect.midX, y: cgRect.minY, width: cgRect.width, height: cgRect.height)
      }
      shapeMask.fillColor = color.cgColor
      
      self.layer.addSublayer(shapeMask)
      
    case .emptyFigure:
      if cornerRadius == 50 {
        shapeMask.path = drawSquigglePath(frames: path.bounds).cgPath
        shapeMask.frame = CGRect(x: cgRect.midX, y: cgRect.minY, width: cgRect.width, height: cgRect.height)
      }
      shapeMask.lineWidth = 4.0
      shapeMask.lineCap = .square
      shapeMask.strokeColor = color.cgColor
      shapeMask.fillColor = UIColor.white.cgColor
      self.layer.addSublayer(shapeMask)
      
    case .hatchedFigure:
      if cornerRadius == 50 {
        let path = drawSquigglePath(frames: CGRect(x: 0, y: 0, width: cgRect.width, height: cgRect.height))
        shapeMask.path = path.cgPath
        let hatchedFigureView = HatchedFigureView(path: path, color: color)
        hatchedFigureView.frame.origin = CGPoint(x: cgRect.midX, y: cgRect.minY)
        self.addSubview(hatchedFigureView)
      } else {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: path.bounds.width, height: path.bounds.height), cornerRadius: cornerRadius)
        let hatchedFigureView = HatchedFigureView(path: path, color: color)
        hatchedFigureView.frame.origin = CGPoint(x: cgRect.maxX, y: cgRect.minY)
        addSubview(hatchedFigureView)
      }
    }
  }
  
  func drawSquigglePath(frames: CGRect) -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 104.0, y: 15.0))
    path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                  controlPoint1: CGPoint(x: 112.4, y: 36.9),
                  controlPoint2: CGPoint(x: 89.7, y: 60.8))
    path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                  controlPoint1: CGPoint(x: 52.3, y: 51.3),
                  controlPoint2: CGPoint(x: 42.2, y: 42.0))
    path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                  controlPoint1: CGPoint(x: 9.6, y: 65.6),
                  controlPoint2: CGPoint(x: 5.4, y: 58.3))
    path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                  controlPoint1: CGPoint(x: 4.6, y: 22.0),
                  controlPoint2: CGPoint(x: 19.1, y: 9.7))
    path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                  controlPoint1: CGPoint(x: 59.2, y: 15.2),
                  controlPoint2: CGPoint(x: 61.9, y: 31.5))
    path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                  controlPoint1: CGPoint(x: 95.3, y: 10.0),
                  controlPoint2: CGPoint(x: 100.9, y: 6.9))
    let transformScale = CGAffineTransform(scaleX: 0.9524 * frames.width / 60 , y: 0.9524 * frames.height / 50 )
    path.apply(transformScale)
    return path
  }
}
