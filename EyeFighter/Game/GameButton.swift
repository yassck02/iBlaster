//
//  GameButton.swift
//  EyeFighter
//
//  Created by Connor yass on 2/22/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */

class GameButton: SKSpriteNode {
    
    enum GameButtonActionType: Int {
        case TouchUpInside, TouchDown, TouchUp
    }
    
    var isEnabled: Bool = true {
        didSet {
            color = isEnabled ? color.withAlphaComponent(0.5) : color.withAlphaComponent(1.0)
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            color = isSelected ? color.withAlphaComponent(0.85) : color.withAlphaComponent(1.0)
        }
    }
    
    var label: SKLabelNode!
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }    
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, text: String?) {
        super.init(texture: texture, color: color, size: size)
        
        label = SKLabelNode(text: text)
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        addChild(label)

        isUserInteractionEnabled = true
    }
    
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
    
    var actionTouchUpInside: Selector?
    var actionTouchUp: Selector?
    var actionTouchDown: Selector?
    
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?
    
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
    
}

/* ----------------------------------------------------------------------------------------- */
