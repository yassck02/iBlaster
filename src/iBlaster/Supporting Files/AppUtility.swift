//
//  AppUtility.swift
//  EyeFighter
//
//  Created by Connor yass on 2/19/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/* ----------------------------------------------------------------------------------------- */

struct PhysicsCategory {
    static let asteroid   : UInt32 = 0x1 << 0
    static let ship       : UInt32 = 0x1 << 1
    static let projectile : UInt32 = 0x1 << 2
}

/* ----------------------------------------------------------------------------------------- */

struct zOrder {
    static let asteroid   : CGFloat = 0.0
    static let projectile : CGFloat = 1.0
    static let ship       : CGFloat = 2.0
    static let menu       : CGFloat = 3.0
}

/* ----------------------------------------------------------------------------------------- */


class AppUtility {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static var hue_1: CGFloat = 0.62
    static var hue_2: CGFloat = 0.28
    
    static var color_1: SKColor {
        return SKColor(hue: hue_1, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    static var color_2: SKColor {
        return SKColor(hue: hue_2, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static var feedbackGenerator: UIImpactFeedbackGenerator?
    
    static func vibrate() {
        DispatchQueue.main.async {
            if feedbackGenerator == nil {
                feedbackGenerator = UIImpactFeedbackGenerator()
            }
            feedbackGenerator!.prepare()
        }
        DispatchQueue.main.async {
            self.feedbackGenerator!.impactOccurred()
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
//    static var themeToLoad: Theme? {
//        didSet {
//            Log.info("set to \(String(describing: themeToLoad?.rawValue))")
//        }
//    }
//
//    static func loadTheme() {
//        Log.function()
//
//        if(themeToLoad != nil) {
//            if (UIApplication.shared.supportsAlternateIcons == false) {
//                Log.error("alternate icons unsupported")
//            } else {
//                UIApplication.shared.setAlternateIconName("icon_" + themeToLoad!.rawValue) { (error: Error?) in
//                    guard let error = error else {
//                        Log.info("icon set to icon_\(themeToLoad!.rawValue)")
//                        return
//                    }
//                    Log.error("could not set icon to icon_\(themeToLoad!.rawValue): \(error)")
//                }
//            }
//        } else {
//            Log.error("themeToLoad: nil")
//        }
//    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    static var font: String = "Helvetica"
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    static var highScore: CGFloat!     // The players high score
    static var count_deaths: Int!      // Number of deaths (lives lost)
    static var count_games: Int!       // Number of games played (started)
    static var count_shots: Int!       // Number of projectiles shot
    static var count_asteroids: Int!   // Number of asteroids destroyed
    
    static func loadStats() {
        let defaults = UserDefaults.standard
        highScore = CGFloat(defaults.float(forKey: "highScore"))
        count_deaths = defaults.integer(forKey: "count_deaths")
        count_games = defaults.integer(forKey: "count_games")
        count_shots = defaults.integer(forKey: "count_shots")
        count_asteroids = defaults.integer(forKey: "count_asteroids")
    }
    
    static func saveStats() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        defaults.set(count_deaths, forKey: "count_deaths")
        defaults.set(count_games, forKey: "count_games")
        defaults.set(count_shots, forKey: "count_shots")
        defaults.set(count_asteroids, forKey: "count_asteroids")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */

