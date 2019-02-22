//
//  GameManager.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameplayKit

/* ----------------------------------------------------------------------------------------- */

class GameManager {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var scene: GameScene?
    
    private var menu: GameMenu? {
        willSet {
            if (menu != nil) {
                menu?.removeFromParent()
            }
        }
        didSet {
            if(menu != nil) {
                scene.addChild(menu!)
                
                if let startMenu = menu as? StartMenu {
                    startMenu.btn_play.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_play))
                } else if let pauseMenu = menu as? PauseMenu {
                    pauseMenu.btn_resume.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_play))
                    pauseMenu.btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_quit))
                } else if let playMenu = menu as? PlayMenu {
                    playMenu.btn_pause.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_pause))
                } else if let endMenu = menu as? EndedMenu {
                    endMenu.btn_quit.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_quit))
                    endMenu.btn_retry.setAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.onBtn_play))
                }
            }
        }
    }
    
    private var stateMachine = GKStateMachine(states: [
        StartingState(),
        PlayingState(),
        PausedState(),
        EndedState()
    ])
    
    var state: AnyClass? {
        get {
            return nil
        }
        set {
            if(newValue != nil) {
                if stateMachine.enter(newValue!) {
                    menu = (stateMachine.currentState as! GameState).menu
                } else {
                    Log.verbose("could not set to \(newValue)")
                }
            } else {
                Log.verbose("setting to nil")
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    @objc func onBtn_play() {
        state = PlayingState.self
    }
    
    @objc func onBtn_pause() {
        state = PausedState.self
    }
    
    @objc func onBtn_quit() {
        state = StartingState.self
    }
    
}

/* ----------------------------------------------------------------------------------------- */
