//
//  GameManager.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameplayKit

/* ----------------------------------------------------------------------------------------- */

enum GameState {
    case starting
    case playing
    case paused
    case ended
    
    static let allValues = [starting, playing, paused, ended]
}

/* ----------------------------------------------------------------------------------------- */

class GameManager {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    var scene: GameScene!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var score: Int = 0 {
        didSet {
            lbl_score.text = "\(score)"
        }
    }
    
    var difficulty: Float = 0.0
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var state: GameState! {
        didSet {
            switch(state!) {
            case .starting:
                Log.function()
                showStartMenu()
                break
            case .playing:
                break
            case .paused:
                showPauseMenu()
                break
            case .ended:
                showEndMenu()
                break
            }
        }
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init(scene: GameScene) {
        Log.function()
        self.scene = scene
        createPlayMenu()
        createStartMenu()
        createPauseMenu()
        createEndMenu()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    @objc func play() {
        Log.function()
        hideStartMenu()
        showPlayMenu()
    }
    
    @objc func pause() {
        Log.function()
        showPauseMenu()
    }
    
    @objc func quit() {
        Log.function()
        hidePauseMenu()
        hideEndMenu()
        hidePlayMenu()
        showStartMenu()
    }
    
    @objc func end() {
        Log.function()
        showEndMenu()
    }
    
    @objc func restart() {
        Log.function()
    }
    
    @objc func resume() {
        Log.function()
        hidePauseMenu()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func initGame() {
        
    }
    
    func deinitGame() {
        scene.cleanUp()
        score = 0
        difficulty = 0
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    private var lbl_score: SKLabelNode!
    private var playMenu: SKNode!
    
    private func createPlayMenu() {
        Log.function()
        playMenu = SKSpriteNode(texture: nil, color: .clear, size: scene.size)
        playMenu.zPosition = 100
        scene.addChild(playMenu)
        
        let btn_pause = GameButton(texture: nil, color: .purple, size: CGSize(width: 125, height: 50), text: "PAUSE")
        btn_pause.position = CGPoint(x: scene.size.width/2 - btn_pause.size.width/2 - 10,
                                     y: scene.size.height/2 - btn_pause.size.height/2 - 10)
        btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(pause))
        playMenu.addChild(btn_pause)
        
        lbl_score = SKLabelNode(text: "0")
        lbl_score.position = CGPoint(x: -100, y: 100)
        playMenu.addChild(lbl_score)
        
        hidePlayMenu()
    }
    
    private func showPlayMenu() { playMenu.isHidden = false; playMenu.isPaused = false }
    private func hidePlayMenu() { playMenu.isHidden = true;  playMenu.isPaused = true  }
    
    // - - - - - -
    
    private var startMenu: SKNode!
    
    private func createStartMenu() {
        Log.function()
        startMenu = SKSpriteNode(texture: nil, color: .clear, size: scene.size)
        startMenu.zPosition = 100
        scene.addChild(startMenu)
        
        let btn_play = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "PLAY")
        btn_play.position = CGPoint(x: 0, y: -100)
        btn_play.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(play))
        startMenu.addChild(btn_play)
        
        hideStartMenu()
    }
    
    private func showStartMenu() { startMenu.isHidden = false; startMenu.isPaused = false }
    private func hideStartMenu() { startMenu.isHidden = true;  startMenu.isPaused = true  }
    
    // - - - - - -
    
    private var pauseMenu: SKNode!
    
    private func createPauseMenu() {
        Log.function()
        pauseMenu = SKSpriteNode(texture: nil, color: .clear, size: scene.size)
        pauseMenu.zPosition = 100
        scene.addChild(pauseMenu)
        
        let btn_resume = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "RESUME")
        btn_resume.position = CGPoint(x: scene.size.width/2 - btn_resume.size.width/2 - 10,
                                      y: scene.size.height/2 - btn_resume.size.height/2 - 10)
        btn_resume.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(resume))
        pauseMenu.addChild(btn_resume)
        
        let btn_quit = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "QUIT")
        btn_quit.position = CGPoint(x: 0, y: -100)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        pauseMenu.addChild(btn_quit)
        
        hidePauseMenu()
    }
    
    private func showPauseMenu() { pauseMenu.isHidden = false; pauseMenu.isPaused = false }
    private func hidePauseMenu() { pauseMenu.isHidden = true;  pauseMenu.isPaused = true  }
    
    // - - - - - -
    
    private var endMenu: SKNode!
    
    private func createEndMenu() {
        Log.function()
        endMenu = SKSpriteNode(texture: nil, color: .clear, size: scene.size)
        endMenu.zPosition = 100
        scene.addChild(endMenu)
        
        let btn_restart = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "RESTART")
        btn_restart.position = CGPoint(x: 0, y: 100)
        btn_restart.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(restart))
        endMenu.addChild(btn_restart)
        
        let btn_quit = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "QUIT")
        btn_quit.position = CGPoint(x: 0, y: -100)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        endMenu.addChild(btn_quit)
        
        hideEndMenu()
    }
    
    private func showEndMenu() { endMenu.isHidden = false; endMenu.isPaused = false }
    private func hideEndMenu() { endMenu.isHidden = true;  endMenu.isPaused = true  }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


}

/* ----------------------------------------------------------------------------------------- */
