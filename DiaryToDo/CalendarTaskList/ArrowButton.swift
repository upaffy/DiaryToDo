//
//  ArrowButton.swift
//  DiaryToDo
//
//  Created by Pavlentiy on 07.02.2022.
//

import UIKit

class ArrowButton: UIButton {
    private var arrow: CAShapeLayer?
    
    let buttonSize: CGFloat
    let isMirrored: Bool
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(buttonSize: CGFloat, isMirrored: Bool = false) {
        self.buttonSize = buttonSize
        self.isMirrored = isMirrored
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        
        setupButton()
    }
    
    private func setupButton() {
        setupArrow()
        
        if isMirrored {
            layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
        }
        layer.addSublayer(self.arrow ?? CAShapeLayer())
    }
    
    private func setupArrow() {
        let arrow = CAShapeLayer()
        arrow.path = arrowPath()
        
        arrow.lineWidth = 2
        arrow.lineJoin = CAShapeLayerLineJoin.round
        arrow.bounds = CGRect(x: 0, y: 0, width: buttonSize / 2, height: buttonSize / 2)
        arrow.position = CGPoint(x: buttonSize / 2, y: buttonSize / 2)
        arrow.drawsAsynchronously = true
        arrow.fillColor = UIColor.clear.cgColor
        arrow.strokeColor = UIColor.red.cgColor
        
        self.arrow = arrow
    }
    
    private func arrowPath() -> CGPath {
        let bezierPath = UIBezierPath()
        let max: CGFloat = buttonSize / 2
        bezierPath.move(to: CGPoint(x: max * 0.65, y: 0))
        bezierPath.addLine(to: CGPoint(x: max * 0.2, y: max * 0.5))
        bezierPath.addLine(to: CGPoint(x: max * 0.65, y: max))
        
        return bezierPath.cgPath
    }
}
