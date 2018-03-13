//
//  CrossWithCircleAnimation.swift
//  MenuIcon
//
//  Created by hyice on 2018/3/13.
//

import UIKit

// this animation is inspired by https://dribbble.com/shots/1623679-Open-Close
class CrossWithCircleAnimation: BaseAnimation {
    private var originMiddleLinePath: CGPath?
    
    private let duration = 0.5
    private let keyTimes: [NSNumber] = [0, 0.15, 0.22, 0.4, 0.9, 1]
    
    override func animate(reverse: Bool, completion: @escaping () -> Void) {
        if !reverse {
            originMiddleLinePath = menuIcon.middleLine.path
            menuIcon.middleLine.path = emittingPath()
        }

        menuIcon.topLine.add(
            animationForLine(onTop: true, reverse: reverse),
            forKey: "top-line-animation"
        )
        
        menuIcon.bottomLine.add(
            animationForLine(onTop: false, reverse: reverse),
            forKey: "bottom-line-animation"
        )
        
        menuIcon.middleLine.add(
            animationForMiddleLine(reverse: reverse),
            forKey: "middle-line-animation"
        )

        waitAnimationsToFinish(with: 3) {
            if reverse {
                self.menuIcon.middleLine.path = self.originMiddleLinePath
            }
            
            completion()
        }
    }
    
    private func animationForLine(onTop isTopLine: Bool, reverse: Bool) -> CAAnimation {
        var rotationAngles = [0, Double.pi * 0.05, Double.pi * 0.07, 0, -Double.pi * 0.25, -Double.pi * 0.22]

        if !isTopLine {
            rotationAngles = rotationAngles.map({ (angle) -> Double in
                return -angle
            })
        }
        
        return lineRotationAnimation(withAngles: rotationAngles, reverse: reverse)
    }
    
    private func lineRotationAnimation(withAngles rotationAngles: [Double], reverse: Bool) -> CAAnimation {
        let rotationTranslations = rotationAngles.map { (angle) -> Double in
            return -Double(menuIcon.topLine.bounds.size.width - menuIcon.lineWidth/2) / 2 * sin(angle)
        }
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = rotationAngles
        rotateAnimation.keyTimes = keyTimes
        
        let translateAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translateAnimation.values = rotationTranslations
        translateAnimation.keyTimes = keyTimes
        
        let topLineAnimations = CAAnimationGroup()
        topLineAnimations.animations = [rotateAnimation, translateAnimation]
        topLineAnimations.isRemovedOnCompletion = false
        topLineAnimations.fillMode = kCAFillModeForwards
        topLineAnimations.duration = duration
        topLineAnimations.delegate = self
        
        if reverse {
            topLineAnimations.speed = -1
            topLineAnimations.timeOffset = duration
        }
        
        return topLineAnimations
    }
    
    private func animationForMiddleLine(reverse: Bool) -> CAAnimation {
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.values = [0.16, 0.12, 0.15, 0.4, 0.97, 1]
        strokeEndAnimation.keyTimes = keyTimes
        
        let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
        strokeStartAnimation.values = [0.02, 0, 0.02, 0.25, 0.36, 0.38]
        strokeStartAnimation.keyTimes = keyTimes
        
        let middleLineAnimations = CAAnimationGroup()
        middleLineAnimations.animations = [strokeStartAnimation, strokeEndAnimation]
        if !reverse {
            middleLineAnimations.fillMode = kCAFillModeForwards
            middleLineAnimations.isRemovedOnCompletion = false
        }
        middleLineAnimations.duration = duration
        middleLineAnimations.delegate = self
        
        if reverse {
            middleLineAnimations.speed = -1
            middleLineAnimations.timeOffset = duration
        }
        
        return middleLineAnimations
    }
    
    private func emittingPath() -> CGPath {
        let lineWidth = menuIcon.lineWidth
        let lineLength = menuIcon.middleLine.bounds.width
        let radius = lineLength / 2 / cos(CGFloat.pi / 4)
        
        let pullToPoint = CGPoint(x: -lineWidth, y: lineWidth / 2)
        let makeTurnPoint = CGPoint(x: lineLength - lineWidth * 2, y: lineWidth / 2)
        let inCirclePoint = CGPoint(x: lineLength, y: -lineLength / 2 + lineWidth / 2)
        let curveContolPoint = CGPoint(x: lineLength * 1.5, y: lineWidth / 2)
        let circleCenterPoint = CGPoint(x: lineLength / 2, y: lineWidth / 2)
        
        let path = UIBezierPath()
        path.move(to: pullToPoint)
        path.addLine(to: makeTurnPoint)
        path.addCurve(to: inCirclePoint, controlPoint1: makeTurnPoint, controlPoint2: curveContolPoint)
        path.addArc(
            withCenter: circleCenterPoint,
            radius:radius,
            startAngle: -CGFloat.pi / 4,
            endAngle: -CGFloat.pi * 0.75,
            clockwise: false
        )
        path.addArc(
            withCenter: circleCenterPoint,
            radius: radius,
            startAngle: -CGFloat.pi * 0.75,
            endAngle: -CGFloat.pi * 0.7,
            clockwise: false
        )
        return path.cgPath
    }
}
