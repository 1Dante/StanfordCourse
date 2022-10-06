//
//  HatchedFigureView.swift
//  Project_3_Graphical_Set
//
//  Created by Viktor on 05.08.2022.
//

import Foundation
import UIKit

class HatchedFigureView: UIView {
  
  let path: UIBezierPath
  let color: UIColor
  
  init(path: UIBezierPath, color: UIColor) {
    self.path = path
    self.color = color
    super.init(frame: path.bounds)
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  override func draw(_ rect: CGRect) {
    drawHatchedTexture()
  }
  
  private func drawHatchedTexture() {
    path.addClip()
    
    let pathBounds = path.bounds
    
    path.removeAllPoints()
    let p1 = CGPoint(x:pathBounds.maxX, y:0)
    let p2 = CGPoint(x:0, y:pathBounds.maxX)
    
    path.move(to: p1)
    path.addLine(to: p2)
    
    path.lineWidth = bounds.width * 2 //
    
    let dashes: [CGFloat] = [5.0, 5.0]
    path.setLineDash(dashes, count: 2, phase: 0.0)
    color.set()
    path.stroke()
  }
}
