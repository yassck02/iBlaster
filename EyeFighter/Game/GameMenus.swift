//
//  MenuNodes.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */

class GameMenu: SKNode {

    var manager: GameManager!
    
    init(manager: GameManager) {
        super.init()
        self.manager = manager
        combinedInit()
    }
    
    func combinedInit() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/* ----------------------------------------------------------------------------------------- */

class StartMenu: GameMenu {
    
    var btn_play: GameButton!
    
    override func combinedInit() {
        btn_play = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "PLAY")
        btn_play.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        btn_play.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_play))
        self.addChild(btn_play)
    }
}

/* ----------------------------------------------------------------------------------------- */

class PauseMenu: GameMenu {
    
    var btn_resume: GameButton!
    var btn_quit: GameButton!
    
    override func combinedInit() {
        btn_resume = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "RESUME")
        btn_resume.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_play))
        btn_resume.position = CGPoint(x: 0, y: 50)
        self.addChild(btn_resume)
        
        btn_quit = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "QUIT")
        btn_quit.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_quit))
        btn_quit.position = CGPoint(x: 0, y: -50)
        self.addChild(btn_quit)
    }

}

/* ----------------------------------------------------------------------------------------- */

class PlayMenu: GameMenu {
    
    var btn_pause: GameButton!
    var lbl_score: SKLabelNode!
    
    override func combinedInit() {
        btn_pause = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "PAUSE")
        btn_pause.position = CGPoint(x: 0 , y: 50)
        btn_pause.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_pause))
        self.addChild(btn_pause)
        
        lbl_score = SKLabelNode(text: "\(manager.score)")
        lbl_score.fontColor = .white
        lbl_score.position = CGPoint(x: 0 , y: 0)
        self.addChild(lbl_score)
    }
}

/* ----------------------------------------------------------------------------------------- */

class EndedMenu: GameMenu {
    
    var btn_quit: GameButton!
    var btn_retry: GameButton!
    
    override func combinedInit() {
        btn_quit = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "QUIT")
        btn_quit.position = CGPoint(x: 0 , y: 50)
        btn_quit.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_quit))
        self.addChild(btn_quit)
        
        btn_retry = GameButton(texture: nil, color: .red, size: CGSize(width: 100, height: 35), text: "RETRY")
        btn_retry.position = CGPoint(x: 0, y: -50)
        btn_retry.setAction(target: manager, triggerEvent: .TouchUpInside, action: #selector(manager.onBtn_play))
        self.addChild(btn_retry)
    }
}

/* ----------------------------------------------------------------------------------------- */
