//
//  CFView.swift
//  MyCareersFinder
//
//  Created by ភី ម៉ារ៉ាសុី on 1/5/19.
//  Copyright © 2019 Bo Bunmeng. All rights reserved.
//

import Foundation
import UIKit

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation: Int {
    case vertical = 0
    case horizontal = 1
    case topRightBottomLeft = 2
    case topLeftBottomRight = 3

    var startPoint : CGPoint {
        return points.startPoint
    }

    var endPoint : CGPoint {
        return points.endPoint
    }

    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
            case .horizontal:
                return (CGPoint.zero, CGPoint(x: 1.0, y: 1))
            case .vertical:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
            }
        }
    }
}

// MARK:- This one the same as the one for button but for all views
class CFGradientView: UIView {

    let gradientLayer = CAGradientLayer()

    @IBInspectable
    var firstGradientColor: UIColor?

    @IBInspectable
    var secondGradientColor: UIColor?

    var orientation: GradientOrientation = .vertical

    @IBInspectable
    // MARK :-
    // Type Definition
    // 0 = Vertical
    // 1 = Horizontal
    // 2 = TopRightBottomLeft
    // 3 = TopLeftBottomRight

    var gradientType: Int = 0 {
        didSet {
            orientation = GradientOrientation(rawValue: gradientType) ?? .vertical
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    private func updateUI() {
        if let firstGradientColor = firstGradientColor, let secondGradientColor = secondGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [firstGradientColor.cgColor, secondGradientColor.cgColor]
            gradientLayer.startPoint = orientation.startPoint
            gradientLayer.endPoint = orientation.endPoint
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
