//
//  GameButton.swift
//  EyeFighter
//
//  Created by Connor yass on 2/22/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */
// - A spritekit button that can be placed in a SKScene

class GameButton: SKShapeNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    enum GameButtonActionType: Int {
        case TouchUpInside, TouchDown, TouchUp
    }
    
    var isEnabled: Bool = true {
        didSet {
            fillColor = isEnabled ? color : SKColor.white
            strokeColor = isEnabled ? SKColor.white : color
            label?.color = isEnabled ? .darkGray : .white
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            fillColor = isSelected ? SKColor.white : color
            strokeColor = isSelected ? color : SKColor.white
            label?.color = isSelected ? color : .white
        }
    }
    
    private var _color: SKColor!
    private var color: SKColor! {
        get {
            return _color
        }
        set {
            self.fillColor = newValue
            _color = newValue
        }
    }
    
    private var label: SKLabelNode?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }    
    
    init(color: UIColor, size: CGSize, text: String?) {
        super.init()
        
//      self.path = CGPath.init(roundedRect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size),
//                              cornerWidth: size.height/2, cornerHeight: size.height/2, transform: nil)
        self.path = CGPath.init(rect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size), transform: nil)
        
        self.lineWidth = 3.0
        self.color = color
        
        if text != nil {
            label = SKLabelNode(fontNamed: "Courier Bold")
            label!.fontSize = 35.0
            label!.text = text
            label!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            label!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            label!.colorBlendFactor = 1.0
            addChild(label!)
        }

        isUserInteractionEnabled = true
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func setAction(target: AnyObject, triggerEvent event: GameButtonActionType, action:Selector) {
        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }
    }
    
    private var actionTouchUpInside: Selector?
    private var actionTouchUp: Selector?
    private var actionTouchDown: Selector?
    
    private weak var targetTouchUpInside: AnyObject?
    private weak var targetTouchUp: AnyObject?
    private weak var targetTouchDown: AnyObject?
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) { return }
        isSelected = true
        
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown)) {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) { return }
        
        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)
        if (frame.contains(touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) { return }
        isSelected = false
        
        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            let touch: AnyObject! = touches.first
            let touchLocation = touch.location(in: parent!)
            if (frame.contains(touchLocation) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }
        }
        
        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
