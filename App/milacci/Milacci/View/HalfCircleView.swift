//
//  HalfCircle.swift
//  Milacci
//
//  Created by Michal Sousedik on 28/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class HalfCircleView: UIView {

    var width: CGFloat = 0
    var height: CGFloat = 0
    let solidHeightPercentage: CGFloat = 0.5

    override func draw(_ rect: CGRect) {

        width = self.bounds.width
        height = self.bounds.height

        self.create()

        self.backgroundColor = .systemBackground

    }

    func create () {
        let path = UIBezierPath()

        let startPoint = CGPoint(x: 0, y: (height*solidHeightPercentage))
        let endPoint = CGPoint(x: width, y: (height * solidHeightPercentage))
        let goThroughPoint = CGPoint(x: width/2, y: height)

        let cp = calculateControlPoint(start: startPoint, goThrough: goThroughPoint, end: endPoint)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: cp)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.close()

        UIColor(named: "primary")?.setFill()
        path.fill()
    }

    private func calculateControlPoint(start: CGPoint, goThrough: CGPoint, end: CGPoint) -> CGPoint {
        return CGPoint(x: (goThrough.x * 2 - (start.x + end.x)/2), y: (goThrough.y * 2 - (start.y + end.y)/2))

    }

}
