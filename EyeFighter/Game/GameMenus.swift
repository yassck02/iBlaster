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
    
}

/* ----------------------------------------------------------------------------------------- */

class StartMenu: GameMenu {
    
    var btn_play: GameButton!
    
    override init() {
        super.init()
        btn_play = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "PLAY")
        btn_play.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        btn_play.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_play))
        self.addChild(btn_play)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onBtn_play() {
        GameManager.shared.play()
    }
}

/* ----------------------------------------------------------------------------------------- */

class PauseMenu: GameMenu {
    
    var btn_resume: GameButton!
    var btn_quit: GameButton!
    
    override init() {
        super.init()
        btn_resume = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "RESUME")
        btn_resume.position = CGPoint(x: 0, y: 50)
        btn_resume.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_resume))
        self.addChild(btn_resume)
        
        btn_quit = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "QUIT")
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_quit))
        btn_quit.position = CGPoint(x: 0, y: -50)
        self.addChild(btn_quit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onBtn_resume() {
        GameManager.shared.play()
    }
    
    @objc func onBtn_quit() {
        GameManager.shared.quit()
    }
}

/* ----------------------------------------------------------------------------------------- */

class PlayMenu: GameMenu {
    
    var btn_pause: GameButton!
    var lbl_score: SKLabelNode!
    
    override init() {
        super.init()
        btn_pause = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "PAUSE")
        btn_pause.position = CGPoint(x: 0 , y: 50)
        btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_pause))
        self.addChild(btn_pause)
        
        lbl_score = SKLabelNode(text: "\(0)")
        lbl_score.fontColor = .white
        lbl_score.position = CGPoint(x: 0 , y: 0)
        self.addChild(lbl_score)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onBtn_pause() {
        GameManager.shared.pause()
    }
}

/* ----------------------------------------------------------------------------------------- */

class EndedMenu: GameMenu {
    
    var btn_quit: GameButton!
    var btn_retry: GameButton!
    
    override init() {
        super.init()
        btn_quit = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "QUIT")
        btn_quit.position = CGPoint(x: 0 , y: 50)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_quit))
        self.addChild(btn_quit)
        
        btn_retry = GameButton(texture: nil, color: .purple, size: CGSize(width: 100, height: 35), text: "RETRY")
        btn_retry.position = CGPoint(x: 0, y: -50)
        btn_retry.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(onBtn_retry))
        self.addChild(btn_retry)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onBtn_quit() {
        GameManager.shared.quit()
    }
    
    @objc func onBtn_retry() {
        GameManager.shared.play()
    }
}

/* ----------------------------------------------------------------------------------------- */
