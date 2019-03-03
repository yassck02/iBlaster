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
// - Keeps track of game state, and score
// - Constructs and presents menuse based on game state
// 

class GameManager {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Variables
    
    var scene: GameScene!
    
    var timer: StopWatch!
    
    var score: CGFloat = 0 {
        didSet {
            lbl_score.text = "\(Int(score))"
        }
    }
    
    var state: GameState! {
        didSet {
            switch(state!) {
            case .starting:
                showStartMenu()
                hidePauseMenu()
                hideEndMenu()
                hidePlayMenu()
                scene.isPaused = true
                break
            case .playing:
                showPlayMenu()
                hideStartMenu()
                hidePauseMenu()
                hideEndMenu()
                scene.isPaused = false
                break
            case .paused:
                showPauseMenu()
                scene.isPaused = true
                break
            case .ended:
                showEndMenu()
                scene.isPaused = true
                break
            }
        }
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: = Init
    
    init(scene: GameScene) {
        Log.function()
        
        self.scene = scene
        scene.manager = self
        
        createPlayMenu()
        createStartMenu()
        createPauseMenu()
        createEndMenu()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    @objc func play() {
        Log.function()
        initGame()
        state = .playing
    }
    
    @objc func pause() {
        Log.function()
        state = .paused
    }
    
    @objc func quit() {
        Log.function()
        scene.cleanUp()
        state = .starting
    }
    
    @objc func end() {
        Log.function()
        state = .ended
    }
    
    @objc func restart() {
        Log.function()
        deinitGame()
        initGame()
        state = .playing
    }
    
    @objc func resume() {
        Log.function()
        hidePauseMenu()
        state = .playing
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: = init, deinit Game
    
    var startTime: CFAbsoluteTime!
    var elapsedTime: CGFloat {
        return CGFloat(startTime! - CFAbsoluteTimeGetCurrent())
    }
    
    func initGame() {
        startTime = CFAbsoluteTimeGetCurrent()
        scene.spawnEnemy()
    }
    
    func deinitGame() {
        scene.cleanUp()
        score = 0
    }
        
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Menu create, hide, show
    
    private func initMenu() -> SKNode {
        let menu = SKSpriteNode(texture: nil, color: .clear, size: scene.size)
        menu.zPosition = CGFloat(zOrder.menu)
        self.scene.addChild(menu)
        return menu
    }
    
    // - - - - - -
    
    private var lbl_score: SKLabelNode!
    private var playMenu: SKNode!
    
    private func createPlayMenu() {
        Log.function()
        playMenu = initMenu()
        
        let btn_pause = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "PAUSE")
        btn_pause.position = CGPoint(x: scene.size.width/2 - btn_pause.size.width/2 - 10,
                                     y: scene.size.height/2 - btn_pause.size.height/2 - 10)
        btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(pause))
        playMenu.addChild(btn_pause)
        
        lbl_score = SKLabelNode(text: "0")
        lbl_score.position = CGPoint(x: -scene.size.width/2 + 15,
                                     y: scene.size.height/2 - 20)
        lbl_score.horizontalAlignmentMode = .left
        lbl_score.verticalAlignmentMode = .top
        playMenu.addChild(lbl_score)
        
        hidePlayMenu()
    }
    
    private func showPlayMenu() { playMenu.isHidden = false; playMenu.isPaused = false }
    private func hidePlayMenu() { playMenu.isHidden = true;  playMenu.isPaused = true  }
    
    // - - - - - -
    
    private var startMenu: SKNode!
    
    private func createStartMenu() {
        Log.function()
        startMenu = initMenu()
        
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
        pauseMenu = initMenu()
        
        let btn_resume = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "RESUME")
        btn_resume.position = CGPoint(x: scene.size.width/2 - btn_resume.size.width/2 - 10,
                                      y: scene.size.height/2 - btn_resume.size.height/2 - 10)
        btn_resume.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(resume))
        btn_resume.zPosition = 5
        pauseMenu.addChild(btn_resume)
        
        let btn_quit = GameButton(texture: nil, color: .purple, size: CGSize(width: 150, height: 50), text: "QUIT")
        btn_quit.position = CGPoint(x: scene.size.width/2 - btn_quit.size.width/2 - 10,
                                    y: scene.size.height/2 - btn_quit.size.height/2 - 100)
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
        endMenu = initMenu()
        
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
