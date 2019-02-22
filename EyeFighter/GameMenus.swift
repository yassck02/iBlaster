//
//  MenuNodes.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

protocol GameMenuDelegate {
    func onPressed(Button: SKNode, ID: String)
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
        
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
        addChild(self.label)
    }
    
    /**
     * Taking a target object and adding an action that is triggered by a Button event.
     */
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
    
    func setLabel(title: NSString, fontSize: CGFloat) {
        self.label.text = title as String
        self.label.fontSize = fontSize
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
    
    override init() {
        super.init()
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/* ----------------------------------------------------------------------------------------- */

class StartMenu: GameMenu {
    
    var btn_play:     GameButton!
    
    override init() { super.init(); combinedInit() }
    required init?(coder aDecoder: NSCoder) { super.init(); combinedInit() }
    
    func combinedInit() {
        Log.verbose("")
        btn_play = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                              selectedTexture: SKTexture.init(imageNamed: "Button"),
                              disabledTexture: nil)
        btn_play.setLabel(title: "Play", fontSize: 20.0)
        btn_play.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(btn_play)
    }
}

/* ----------------------------------------------------------------------------------------- */

class PauseMenu: GameMenu {
    
    var btn_resume: GameButton!
    var btn_quit: GameButton!
    
    override init() { super.init(); combinedInit() }
    required init?(coder aDecoder: NSCoder) { super.init(); combinedInit() }
    
    func combinedInit() {
        btn_resume = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                              selectedTexture: SKTexture.init(imageNamed: "Button"),
                              disabledTexture: nil)
        btn_resume.setLabel(title: "Resume", fontSize: 12.0)
        btn_resume.position = CGPoint(x: 0, y: 50)
        self.addChild(btn_resume)
        
        btn_quit = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                                selectedTexture: SKTexture.init(imageNamed: "Button"),
                                disabledTexture: nil)
        btn_quit.setLabel(title: "Quit", fontSize: 12.0)
        btn_quit.position = CGPoint(x: 0, y: -50)
        self.addChild(btn_quit)
    }
}

/* ----------------------------------------------------------------------------------------- */

class PlayMenu: GameMenu {
    
    var btn_pause: GameButton!
    
    override init() { super.init(); combinedInit() }
    required init?(coder aDecoder: NSCoder) { super.init(); combinedInit() }
    
    func combinedInit() {
        btn_pause = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                              selectedTexture: SKTexture.init(imageNamed: "Button"),
                              disabledTexture: nil)
        btn_pause.setLabel(title: "Pause", fontSize: 12.0)
        btn_pause.position = CGPoint(x: 100, y: 100)
        self.addChild(btn_pause)
    }
}

/* ----------------------------------------------------------------------------------------- */

class EndedMenu: GameMenu {
    
    var btn_quit: GameButton!
    var btn_retry: GameButton!
    
    override init() { super.init(); combinedInit() }
    required init?(coder aDecoder: NSCoder) { super.init(); combinedInit() }
    
    func combinedInit() {
        btn_quit = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                              selectedTexture: SKTexture.init(imageNamed: "Button"),
                              disabledTexture: nil)
        btn_quit.setLabel(title: "Quit", fontSize: 12.0)
        btn_quit.position = CGPoint(x: 0, y: 50)
        self.addChild(btn_quit)
        
        btn_retry = GameButton(normalTexture: SKTexture.init(imageNamed: "Button"),
                              selectedTexture: SKTexture.init(imageNamed: "Button"),
                              disabledTexture: nil)
        btn_retry.setLabel(title: "Retry", fontSize: 12.0)
        btn_retry.position = CGPoint(x: 0, y: -50)
        self.addChild(btn_retry)
    }
}

/* ----------------------------------------------------------------------------------------- */
