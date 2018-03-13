//
//  BaseAnimation.swift
//  MenuIcon
//
//  Created by hyice on 2018/3/13.
//

import UIKit


extension BaseAnimation: IconAnimator {
    func openAnimation(completion: @escaping () -> Void) -> Bool {
        guard menuIcon != nil else {
            fatalError("You must set the menu icon for animator before using")
        }
        
        guard !isAnimating && isInitialState else {
            return false
        }
        
        if originLinePositions == nil {
            storeOriginLinePositions()
        }

        isAnimating = true
        
        self.animate { [weak self] in
            if let strongSelf = self {
                strongSelf.isInitialState = false
                strongSelf.isAnimating = false
            }
        }
        
        return true
    }
    
    func closeAnimation(completion: @escaping () -> Void) -> Bool {
        guard menuIcon != nil else {
            fatalError("You must set the menu icon for animator before using")
        }
        
        guard !isAnimating && !isInitialState else {
            return false
        }
        
        isAnimating = true
        
        self.animate(reverse: true) { [weak self] in
            if let strongSelf = self {
                strongSelf.isInitialState = true
                strongSelf.isAnimating = false
            }
        }
        
        return true
    }
}

class BaseAnimation: NSObject {
    var isInitialState = true
    
    var isAnimating = false
    
    weak var menuIcon: MenuIcon!
    
    var originLinePositions: [CGPoint]!
    
    private let animationSemaphore = DispatchSemaphore(value: 0)
    
    required init(with menuIcon:MenuIcon) {
        
        self.menuIcon = menuIcon
    }
    
    func animate(reverse: Bool = false, completion: @escaping () -> Void) {
        fatalError("method not implenmented, you must override it")
    }
    
    // only can wait for animations whose delegate were assigned to self
    func waitAnimationsToFinish(with count: Int, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            var count = count
            while count != 0 {
                self.animationSemaphore.wait()
                count -= 1
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func storeOriginLinePositions() {
        originLinePositions = [
            menuIcon.topLine.position,
            menuIcon.middleLine.position,
            menuIcon.bottomLine.position
        ]
    }
}

extension BaseAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationSemaphore.signal()
    }
}
