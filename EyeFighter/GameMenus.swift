//
//  MenuNodes.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

protocol GameMenuDelegate {
    func onPressed(button: SKNode, ID: String)
}

/* ----------------------------------------------------------------------------------------- */

class GameButton: SKSpriteNode {
    
    enum GameButtonActionType: Int {
        case TouchUpInside, TouchDown, TouchUp
    }
    
    var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                texture = isEnabled ? defaultTexture : disabledTexture
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }
    
    var defaultTexture: SKTexture
    var selectedTexture: SKTexture
    var disabledTexture: SKTexture?

    var label: SKLabelNode
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(normalTexture defaultTexture: SKTexture!, selectedTexture: SKTexture!, disabledTexture: SKTexture?) {
        
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        self.label = SKLabelNode(fontNamed: "Helvetica");
        
        super.init(texture: defaultTexture, color: UIColor.white, size: defaultTexture.size())
        isUserInteractionEnabled = true
        
        //Creating and adding a blank label, centered on the button
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
        addChild(self.label)
        
        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: defaultTexture.size())
        bugFixLayerNode.position = self.position
        addChild(bugFixLayerNode)
        
    }
    
    /**
     * Taking a target object and adding an action that is triggered by a button event.
     */
    func setButtonAction(target: AnyObject, triggerEvent event: GameButtonActionType, action:Selector) {
        
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
    
    func setButtonLabel(title: NSString, font: String, fontSize: CGFloat) {
        self.label.text = title as String
        self.label.fontSize = fontSize
        self.label.fontName = font
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

class GameMenu: SKNode {
    var delegegate: GameMenuDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self) {
            for child in children {
                if child.contains(touch) {
                    didTouch(child)
                    break
                }
            }
        }
    }
    
    func didTouch(_ node: SKNode) { }
}

/* ----------------------------------------------------------------------------------------- */

class StartMenu: GameMenu {
    
    var btn_play: GameButton!
    var btn_settings: GameButton!
    
    override func didTouch(_ node: SKNode) {
        switch node {
        case btn_play:
            Log.verbose("Play button pressed")
            delegegate?.onPressed(button: node, ID: "play")
        case btn_settings:
            Log.verbose("Settings button pressed")
            delegegate?.onPressed(button: node, ID: "settings")
        default:
            Log.error("Unrecognized button pressed")
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

class PauseMenu: GameMenu {
    
    var btn_quit: GameButton!
    var btn_play: GameButton!
    var btn_restart: GameButton!
    
    override func didTouch(_ node: SKNode) {
        switch node {
        case btn_quit:
            Log.verbose("Quit button pressed")
            delegegate?.onPressed(button: node, ID: "quit")
        case btn_play:
            Log.verbose("Play button pressed")
            delegegate?.onPressed(button: node, ID: "play")
        case btn_restart:
            Log.verbose("Restart button pressed")
            delegegate?.onPressed(button: node, ID: "restart")
        default:
            Log.error("Unrecognized button pressed")
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

class PlayingMenu: GameMenu {
    
    var btn_pause: GameButton!
    
    override init() { super.init(); combinedInit() }
    required init?(coder aDecoder: NSCoder) { super.init(); combinedInit() }
    
    func combinedInit() {
    }
    
    override func didTouch(_ node: SKNode) {
        switch node {
        case btn_pause:
            Log.verbose("Pause button pressed")
            delegegate?.onPressed(button: node, ID: "pause")
        default:
            Log.error("Unrecognized button pressed")
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

class EndedMenu: GameMenu {
    
    var btn_retry: GameButton!
    var btn_quit: GameButton!
    
    override func didTouch(_ node: SKNode) {
        switch node {
        case btn_retry:
            Log.verbose("Retry button pressed")
            delegegate?.onPressed(button: node, ID: "retry")
        case btn_quit:
            Log.verbose("Quit button pressed")
            delegegate?.onPressed(button: node, ID: "quit")
        default:
            Log.error("Unrecognized button pressed")
        }
    }
}

/* ----------------------------------------------------------------------------------------- */
