//
//  MenuIcon.swift
//  MenuIcon
//
//  Created by hyice on 2018/3/12.
//

import UIKit


public protocol IconAnimator {
    func openAnimation(completion: @escaping () -> Void) -> Bool
    func closeAnimation(completion: @escaping () -> Void) -> Bool
}


public extension MenuIcon {
    @discardableResult
    func open(completion: (() -> Void)? = nil) -> Bool {
        guard !isOpened else {
            return false
        }
        
        currentAnimator = animator
        
        isOpened = currentAnimator.openAnimation {
            if let completion = completion {
                completion()
            }
        }
        
        return isOpened
    }
    
    @discardableResult
    func close(completion: (() -> Void)? = nil) -> Bool {
        guard isOpened else {
            return false
        }
        
        isOpened = !currentAnimator.closeAnimation {
            if let completion = completion {
                completion()
            }
        }
        
        return isOpened
    }
}


open class MenuIcon: UIView {
    
    open var insets = UIEdgeInsets.zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var lineWidth: CGFloat = 0 {
        didSet {
            configureLines { (_, line) in
                line.lineWidth = lineWidth
            }
        }
    }
    
    open var lineColor = UIColor.black {
        didSet {
            configureLines { (_, line) in
                line.strokeColor = lineColor.cgColor
            }
        }
    }
    
    public var animator: IconAnimator?
    
    // storing already opened animator, use a new animator only if old animator was closed
    private var currentAnimator: IconAnimator!
    
    public var isOpened: Bool = false
    
    internal let topLine = CAShapeLayer()
    internal let middleLine = CAShapeLayer()
    internal let bottomLine = CAShapeLayer()

    private let iconRatio = 1.4
    
    private var iconRect: CGRect {
        get {
            // menu icon will be displayed on the center with half width and height(after considered insets)
            var drawingWidth = Double(bounds.size.width - insets.left - insets.right) / 2
            var drawingHeight = Double(bounds.size.height - insets.top - insets.bottom) / 2
            
            // in case size or insets was wrong
            drawingWidth = max(0, drawingWidth)
            drawingHeight = max(0, drawingHeight)
            
            // icon will always keep the ratio
            if drawingWidth / drawingHeight > iconRatio {
               drawingWidth = drawingHeight * iconRatio
            } else {
                drawingHeight = drawingWidth / iconRatio
            }
            return CGRect(
                x: (Double(bounds.size.width) - drawingWidth) / 2,
                y: (Double(bounds.size.height) - drawingHeight) / 2,
                width: drawingWidth,
                height: drawingHeight
            )
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        animator = CrossWithCircleAnimation(with: self)
        
        layer.addSublayer(topLine)
        layer.addSublayer(middleLine)
        layer.addSublayer(bottomLine)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not implemented")
    }
    
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        setupMenuLines()
    }
    
    private func setupMenuLines() {
        lineWidth = lineWidth == 0 ? iconRect.height / 6 : lineWidth
        let linePadding = (iconRect.height - lineWidth * 3) / 2
        
        var yPositions = [CGFloat]()
        var y = iconRect.origin.y + lineWidth / 2
        
        for _ in 0..<3 {
            yPositions.append(y)
            
            y += linePadding + lineWidth
        }
        
        configureLines { (index, line) in
            line.bounds = CGRect(x: 0, y: 0, width: iconRect.width, height: lineWidth)
            line.path = bezierLine(withLength: iconRect.width, lineWidth: lineWidth).cgPath
            line.fillColor = UIColor.clear.cgColor
            line.strokeColor = lineColor.cgColor
            line.lineWidth = CGFloat(lineWidth)
            line.lineCap = kCALineCapRound
            line.position = CGPoint(x: iconRect.origin.x + iconRect.width / 2, y: yPositions[index])
        }
    }
    
    private func bezierLine(withLength length: CGFloat, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: lineWidth / 2, y: lineWidth / 2))
        path.addLine(to: CGPoint(x: length - lineWidth/2, y: lineWidth / 2))
        return path
    }
    
    private func configureLines(_ block: (_ index: Int, _ line: CAShapeLayer) -> Void) {
        for (index, line) in [topLine, middleLine, bottomLine].enumerated() {
            block(index, line)
        }
    }
}
