//
//  LobbyVC.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import UIKit

/* ----------------------------------------------------------------------------------------- */

class LobbyVC: UIViewController {
    
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var btn_settings: UIButton!
    @IBOutlet weak var btn_logo: UIButton!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
        setupUI()
    }
    
    func setupUI() {
        let color = UIColor(hue: AppUtility.hue, saturation: 0.75, brightness: 0.75, alpha: 1.0)
        btn_play.tintColor = UIColor.white
        btn_play.layer.cornerRadius = 7.0
        btn_play.layer.borderWidth = 2.0
        btn_play.layer.borderColor = UIColor.white.cgColor
        
        btn_settings.tintColor = UIColor.white
        btn_logo.tintColor = UIColor.white
        
        view.backgroundColor = color
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
