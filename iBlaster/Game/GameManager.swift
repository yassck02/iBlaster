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
    
    var viewController: ViewController!
    
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
                show(startMenu)
                hide(pauseMenu)
                hide(endMenu)
                hide(playMenu)
                
                scene.isPaused = true
                break
            case .playing:
                show(playMenu)
                hide(startMenu)
                hide(pauseMenu)
                hide(endMenu)
                
                btn_resume.isHidden = true
                btn_pause.isHidden = false
                
                scene.isPaused = false
                break
            case .paused:
                show(pauseMenu)
                
                btn_resume.isHidden = false
                btn_pause.isHidden = true
                
                scene.isPaused = true
                break
            case .ended:
                show(endMenu)
                
                scene.isPaused = true
                break
            }
        }
    }
    
    var lives: Int! {
        didSet {
            if lives <= 0 {
                end()
            } else {
                AppUtility.vibrate()
            }
        }
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Init
    
    init(scene: GameScene) {
        Log.function()
        
        self.scene = scene
        scene.manager = self
        
        createPlayMenu()
        createStartMenu()
        createPauseMenu()
        createEndMenu()
        createSettingsMenu()
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
        hide(pauseMenu)
        state = .playing
    }
    
    @objc func settings() {
        Log.function()
        hide(pauseMenu)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: = init, deinit Game
    
    func initGame() {
        lives = 300
        score = 0
    }
    
    func deinitGame() {
        scene.cleanUp()
        score = 0
        lives = 0
    }
        
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Menu create, hide, show
    
    private func createMenu() -> SKNode {
        let menu = SKSpriteNode(color: .clear, size: scene.size)
        menu.zPosition = CGFloat(zOrder.menu)
        self.scene.addChild(menu)
        return menu
    }
    
    private func show(_ menu: SKNode) {
        menu.isHidden = false
        menu.isPaused = false
    }
    
    private func hide(_ menu: SKNode) {
        menu.isHidden = true
        menu.isPaused = true
    }
    
    // - - - - - -
    
    private var settingsMenu: SKNode!
    
    private func createSettingsMenu() {
        Log.function()
        settingsMenu = createMenu()
        hide(settingsMenu)
    }
    
    // - - - - - -
    
    private var playMenu: SKNode!
    
    private var lbl_score: SKLabelNode!
    private var btn_pause: GameButton!
    
    private func createPlayMenu() {
        Log.function()
        playMenu = createMenu()
        
        btn_pause = GameButton(color: .white, size: CGSize(width: 30, height: 30), text: nil)
        btn_pause.fillTexture = SKTexture(imageNamed: "btn_pause")
        btn_pause.lineWidth = 0.0
        btn_pause.position = CGPoint(x: scene.size.width/2 - btn_pause.frame.size.width/2 - 10,
                                     y: scene.size.height/2 - btn_pause.frame.size.height/2 - 10)
        btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(pause))
        playMenu.addChild(btn_pause)
        
        lbl_score = SKLabelNode(fontNamed: "digiffiti")
        lbl_score.text = "0"
        lbl_score.fontSize = 30.0
        lbl_score.position = CGPoint(x: -scene.size.width/2 + 15,
                                     y: scene.size.height/2 - lbl_score.frame.size.height/2 - 15)
        lbl_score.horizontalAlignmentMode = .left
        lbl_score.verticalAlignmentMode = .center
        playMenu.addChild(lbl_score)
        
        hide(playMenu)
    }
    
    // - - - - - -
    
    private var startMenu: SKNode!
    
    private func createStartMenu() {
        Log.function()
        startMenu = createMenu()
        
        let btn_play = GameButton(color: AppUtility.color_2, size: CGSize(width: 100, height: 35), text: "play")
        btn_play.position = CGPoint(x: 0, y: -100)
        btn_play.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(play))
        startMenu.addChild(btn_play)
        
        let btn_settings = GameButton(color: AppUtility.color_2, size: CGSize(width: 100, height: 35), text: "")
        btn_settings.position = CGPoint(x: 0, y: -200)
        btn_settings.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(settings))
        startMenu.addChild(btn_settings)
        
        let lbl_title = SKLabelNode(fontNamed: "digiffiti")
        lbl_title.text = "iBLASTER"
        lbl_title.fontSize = 50.0
        lbl_title.position = CGPoint(x: 0, y: 100)
        lbl_title.horizontalAlignmentMode = .center
        lbl_title.verticalAlignmentMode = .center
        startMenu.addChild(lbl_title)
        
        hide(startMenu)
    }
    
    // - - - - - -
    
    private var pauseMenu: SKNode!
    
    private var btn_resume: GameButton!
    
    private func createPauseMenu() {
        Log.function()
        pauseMenu = createMenu()
        
        btn_resume = GameButton(color: .white, size: CGSize(width: 30, height: 30), text: nil)
        btn_resume.fillTexture = SKTexture(imageNamed: "btn_play")
        btn_resume.lineWidth = 0.0
        btn_resume.position = CGPoint(x: scene.size.width/2 - btn_resume.frame.size.width/2 - 10,
                                      y: scene.size.height/2 - btn_resume.frame.size.height/2 - 10)
        btn_resume.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(resume))
        btn_resume.zPosition = 5
        pauseMenu.addChild(btn_resume)
        
        let btn_quit = GameButton(color: AppUtility.color_2, size: CGSize(width: 100, height: 35), text: "quit")
        btn_quit.position = CGPoint(x: btn_resume.position.x - btn_quit.frame.size.width/2 - 25 ,
                                    y: btn_resume.position.y)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        pauseMenu.addChild(btn_quit)
        
        hide(pauseMenu)
    }
    
    // - - - - - -
    
    private var endMenu: SKNode!
    
    private func createEndMenu() {
        Log.function()
        endMenu = createMenu()
        
        let btn_restart = GameButton(color: AppUtility.color_2, size: CGSize(width: 100, height: 35), text: "restart")
        btn_restart.position = CGPoint(x: 0, y: 100)
        btn_restart.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(restart))
        endMenu.addChild(btn_restart)
        
        let btn_quit = GameButton(color: AppUtility.color_2, size: CGSize(width: 100, height: 35), text: "quit")
        btn_quit.position = CGPoint(x: 0, y: -100)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        endMenu.addChild(btn_quit)
        
        let lbl_ended = SKLabelNode(fontNamed: "digiffiti")
        lbl_ended.text = "Game Over"
        lbl_ended.fontSize = 22.0
        lbl_ended.position = CGPoint(x: 0, y: 200)
        lbl_ended.horizontalAlignmentMode = .center
        lbl_ended.verticalAlignmentMode = .center
        endMenu.addChild(lbl_ended)
        
        hide(endMenu)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
