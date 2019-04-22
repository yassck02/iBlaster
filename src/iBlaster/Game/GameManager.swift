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
    
    var paused: Bool = true
    
    var state: GameState! {
        didSet {
            switch(state!) {
            case .starting:
                show(startMenu)
                hide(pauseMenu)
                hide(endMenu)
                hide(playMenu)
                
                scene.ship.removeAllActions()
                scene.ship.alpha = 1.0
                
                scene.isPaused = true
                viewController.stopTrackingInput()
                break
                
            case .playing:
                show(playMenu)
                hide(startMenu)
                hide(pauseMenu)
                hide(endMenu)
                
                btn_resume.isHidden = true
                btn_pause.isHidden = false
                
                scene.isPaused = false
                viewController.startTrackingInput()
                break
                
            case .paused:
                show(pauseMenu)
                
                btn_resume.isHidden = false
                btn_pause.isHidden = true
                
                scene.isPaused = true
                viewController.stopTrackingInput()
                break
                
            case .ended:
                show(endMenu)
                
                if(score > AppUtility.highScore) {
                    AppUtility.highScore = score
                    lbl_highScore.isHidden = false
                } else {
                    lbl_highScore.isHidden = true
                }
                
                scene.isPaused = true
                viewController.stopTrackingInput()
                break
            }
            Log.info(state)
        }
    }
        
    var lives: Int = 0 {
        willSet {
            if newValue > lives {
                for i in 0..<(newValue - lives) {
                    let image = SKSpriteNode(imageNamed: "ship")
                    image.size = CGSize(width: 15, height: 15)
                    image.position = CGPoint(x: -scene.frame.width/2.0 + (CGFloat(i) + 1) * 20.0,
                                             y: lbl_score.position.y - 20.0 )
                    image.addShadow(color: .darkGray, alpha: 0.5, radius: 10.0)
                    playMenu.addChild(image)
                    life_images.append(image)
                }
            } else {
                for _ in 0..<(lives - newValue) {
                    if(life_images.isEmpty == false) {
                        let image = life_images.removeLast()
                        image.removeFromParent()
                    }
                }
                AppUtility.vibrate()
                scene.ship.run(Ship.flash)
            }
        }
        didSet {
            if lives <= 0 {
                end()
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
        lives = 3
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
    
    private var life_images = [SKSpriteNode]()
    
    private func createPlayMenu() {
        Log.function()
        playMenu = createMenu()
        
        btn_pause = GameButton(color: .white, size: CGSize(width: 30, height: 30), text: nil)
        btn_pause.fillTexture = SKTexture(imageNamed: "btn_pause")
        btn_pause.lineWidth = 0.0
        btn_pause.position = CGPoint(x: scene.size.width/2 - btn_pause.frame.size.width/2 - 15,
                                     y: scene.size.height/2 - btn_pause.frame.size.height/2 - 15)
        btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(pause))
        playMenu.addChild(btn_pause)
        
        lbl_score = SKLabelNode(fontNamed: AppUtility.font)
        lbl_score.text = "0"
        lbl_score.fontSize = 20.0
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
        
        let btn_play = GameButton(color: .clear, size: CGSize(width: 100, height: 35), text: "PLAY")
        btn_play.position = CGPoint(x: 0, y: -100)
        btn_play.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(play))
        startMenu.addChild(btn_play)
        
        let btn_settings = GameButton(color: .white, size: CGSize(width: 25, height: 25), text: "")
        btn_settings.lineWidth = 0.0
        btn_settings.fillTexture = SKTexture(imageNamed: "btn_settings")
        btn_settings.position = CGPoint(x: scene.size.width/2 - btn_settings.frame.size.width/2 - 15,
                                        y: scene.size.height/2 + btn_settings.frame.size.height/2 - btn_settings.frame.size.height - 15)
        btn_settings.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(settings))
        startMenu.addChild(btn_settings)
        
        let lbl_title = SKLabelNode(fontNamed: AppUtility.font)
        lbl_title.text = "iBlaster"
        lbl_title.fontSize = 40.0
        lbl_title.position = CGPoint(x: 0, y: 100)
        lbl_title.horizontalAlignmentMode = .center
        lbl_title.verticalAlignmentMode = .center
        lbl_title.addShadow(color: .darkGray, alpha: 0.5, radius: 10)
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
        
        let btn_quit = GameButton(color: .clear, size: CGSize(width: 100, height: 35), text: "Quit")
        btn_quit.position = CGPoint(x: scene.size.width/2 - btn_quit.frame.size.width/2 - 10,
                                    y: btn_resume.position.y - btn_quit.frame.size.height/2 - 20)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        pauseMenu.addChild(btn_quit)
        
        hide(pauseMenu)
    }
    
    // - - - - - -
    
    private var endMenu: SKNode!
    
    private var lbl_highScore: SKLabelNode!
    
    private func createEndMenu() {
        Log.function()
        endMenu = createMenu()
        
        let btn_restart = GameButton(color: .clear, size: CGSize(width: 100, height: 35), text: "Restart")
        btn_restart.position = CGPoint(x: 0, y: 100)
        btn_restart.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(restart))
        endMenu.addChild(btn_restart)
        
        let btn_quit = GameButton(color: .clear, size: CGSize(width: 100, height: 35), text: "Quit")
        btn_quit.position = CGPoint(x: 0, y: -100)
        btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(quit))
        endMenu.addChild(btn_quit)
        
        let lbl_ended = SKLabelNode(fontNamed: AppUtility.font)
        lbl_ended.text = "GAME OVER"
        lbl_ended.fontSize = 25.0
        lbl_ended.position = CGPoint(x: 0, y: 200)
        lbl_ended.horizontalAlignmentMode = .center
        lbl_ended.verticalAlignmentMode = .center
        lbl_ended.addShadow(color: .darkGray, alpha: 0.5, radius: 10)
        endMenu.addChild(lbl_ended)
        
        lbl_highScore = SKLabelNode(fontNamed: AppUtility.font)
        lbl_highScore.addShadow(color: .darkGray, alpha: 0.5, radius: 10)
        lbl_highScore.text = "New High Score!"
        lbl_highScore.fontSize = 13.0
        lbl_highScore.position = CGPoint(x: 0, y: 175)
        lbl_highScore.horizontalAlignmentMode = .center
        lbl_highScore.verticalAlignmentMode = .center
        lbl_highScore.addShadow(color: .darkGray, alpha: 0.5, radius: 10)
        endMenu.addChild(lbl_highScore)
        
        hide(endMenu)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
