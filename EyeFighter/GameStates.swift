//
//  GameStates.swift
//  EyeFighter
//
//  Created by Connor yass on 2/21/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameplayKit

/* ----------------------------------------------------------------------------------------- */

class GameState: GKState {
    
    var menu: GameMenu? { return nil }
    
}

/* ----------------------------------------------------------------------------------------- */

class StartingState: GameState {
    
    override var menu: GameMenu? { return StartMenu() }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == PlayingState.self)
    }

}

/* ----------------------------------------------------------------------------------------- */

class PlayingState: GameState {
    
    override var menu: GameMenu? { return PlayMenu() }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == PausedState.self ||
                stateClass == EndedState.self)
    }
    
}

/* ----------------------------------------------------------------------------------------- */

class PausedState: GameState {
    
    override var menu: GameMenu? { return PauseMenu() }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == PlayingState.self ||
                stateClass == StartingState.self)
    }
    
}

/* ----------------------------------------------------------------------------------------- */

class EndedState: GameState {
    
    override var menu: GameMenu? { return EndedMenu() }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == PlayingState.self ||
                stateClass == StartingState.self)
    }

}

/* ----------------------------------------------------------------------------------------- */
