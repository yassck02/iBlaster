//
//  SettingsVC.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import UIKit

/* ----------------------------------------------------------------------------------------- */

class SettingsVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sldr_color: UISlider!
    private var colorChanged = false
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    //MARK: - Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if colorChanged {
            AppUtility.hue = CGFloat(sldr_color.value)
        }
    }
    
    func setupUI() {
        let color = UIColor(hue: AppUtility.hue, saturation: 0.75, brightness: 0.75, alpha: 1.0)
        
        sldr_color.tintColor = color
        sldr_color.setValue(Float(AppUtility.hue), animated: false)
        
        navigationController?.toolbar.tintColor = color
        navigationController?.navigationBar.tintColor = color
        
        if self.navigationController != nil {
            if self.navigationController!.toolbarItems != nil {
                if self.navigationController!.toolbarItems!.count > 0 {
                    for barItem in self.navigationController!.toolbarItems! {
                        barItem.tintColor = color
                    }
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - TableViewStuff
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 40.0 }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Buttons
    
    @IBAction func onSliderChanged_color(_ sender: Any) {
        let newColor = UIColor(hue: CGFloat(sldr_color.value), saturation: 1.0, brightness: 0.75, alpha: 1.0)
        sldr_color.tintColor = newColor
        
        navigationController?.toolbar.tintColor = newColor
        navigationController?.navigationBar.tintColor = newColor
        navigationController?.toolbar.tintColor = newColor
        
        colorChanged = true
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */

