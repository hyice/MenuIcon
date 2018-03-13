//
//  CrossAnimation.swift
//  MenuIcon
//
//  Created by hyice on 2018/3/13.
//

import UIKit

// this animation is inspired by https://dribbble.com/shots/2148679-Icon-Transition-Kit
class CrossAnimation: BaseAnimation {
    
    private let animationSemaphore = DispatchSemaphore(value: 0)
    
    override func animate(reverse: Bool, completion: @escaping () -> Void) {
        let firstStep = reverse ? rotateToCross : allToCenter
        let secondStep = reverse ? allToCenter : rotateToCross

        firstStep(reverse) {
            secondStep(reverse) {
                completion()
            }
        }
    }
    
    private func allToCenter(reverse: Bool = false, completion: @escaping () -> Void) {
        let movingDuration = 0.1
        
        let yPositionAnimation = CABasicAnimation(keyPath: "position.y")
        yPositionAnimation.fromValue = originLinePositions[0].y
        yPositionAnimation.toValue = originLinePositions[1].y
        yPositionAnimation.duration = movingDuration
        yPositionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yPositionAnimation.delegate = self
        yPositionAnimation.isRemovedOnCompletion = false
        yPositionAnimation.fillMode = kCAFillModeForwards
        
        if reverse {
            yPositionAnimation.speed = -1
            yPositionAnimation.timeOffset = movingDuration
        }
        
        menuIcon.topLine.add(yPositionAnimation, forKey: "move-top-line")
        
        yPositionAnimation.fromValue = originLinePositions[2].y
        menuIcon.bottomLine.add(yPositionAnimation, forKey: "move-bottom-line")
        
        menuIcon.middleLine.isHidden = !reverse
        
        waitAnimationsToFinish(with: 2, completion: completion)
    }
    
    private func rotateToCross(reverse: Bool = false, completion: @escaping () -> Void) {
        let rotateDuration = 0.1
        let rotateRadius = Double.pi * 0.24
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = rotateRadius
        rotateAnimation.duration = rotateDuration
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.delegate = self
        
        if reverse {
            rotateAnimation.speed = -1
            rotateAnimation.timeOffset = rotateDuration
        }

        menuIcon.topLine.add(rotateAnimation, forKey: "rotate-top-line")
        
        rotateAnimation.toValue = -rotateRadius
        menuIcon.bottomLine.add(rotateAnimation, forKey: "rotate-bottom-line")
        
        waitAnimationsToFinish(with: 2, completion: completion)
    }
}
