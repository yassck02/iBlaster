//
//  ViewController.swift
//  EyeFighter
//
//  Created by Connor yass on 2/19/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

/* ----------------------------------------------------------------------------------------- */

class GameVC: UIViewController, ARSKViewDelegate {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    @IBOutlet var sceneView: ARSKView!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var faceNode: SCNNode = SCNNode()
    
    var leftEyeNode: SCNNode = {
        let node = SCNNode()
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var rightEyeNode: SCNNode = {
        let node = SCNNode()
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var leftTargetNode: SCNNode = SCNNode()
    var rightTargetNode: SCNNode = SCNNode()
    
    // actual physical size of iPhoneX screen
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    // actual point size of iPhoneX screen
    let screenSize_points = CGSize(width: 375, height: 812)
    
    var virtualPhoneNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        let screenGeometry = SCNPlane(width: 1, height: 1)
        return SCNNode(geometry: screenGeometry)
    }()
    
    var xLookPositions: [CGFloat] = []
    var yLookPositions: [CGFloat] = []
    
    @IBOutlet weak var lbl_xLookPos: UILabel!
    @IBOutlet weak var lbl_yLookPos: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var view_lookPos: UIView!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.presentScene(GameManager.shared.scene)
        
        GameManager.shared.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            configuration.isLightEstimationEnabled = false
            sceneView.session.run(configuration)
        } else {
            Log.error("Face tracking not supported :(")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - ARSKViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        let alert = UIAlertController(title: "OOPS!", message: error.localizedDescription, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        
        rightEyeNode.simdTransform = anchor.rightEyeTransform
        leftEyeNode.simdTransform = anchor.leftEyeTransform
        
        var eyeLLookAt = CGPoint()
        var eyeRLookAt = CGPoint()
        
        let heightCompensation: CGFloat = 312
        
        DispatchQueue.main.async {
            
            // Perform Hit test using the ray segments that are drawn by the center of the eyeballs to somewhere two meters away
            // at direction of where users look at to the virtual plane that place at the same orientation of the phone screen
            
            let phoneScreenEyeRHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.rightTargetNode.worldPosition, to: self.rightEyeNode.worldPosition, options: nil)
            let phoneScreenEyeLHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.leftTargetNode.worldPosition, to: self.leftEyeNode.worldPosition, options: nil)
            
            for result in phoneScreenEyeRHitTestResults {
                eyeRLookAt.x = CGFloat(result.localCoordinates.x) / (self.screenSize.width / 2) * self.screenSize_points.width
                eyeRLookAt.y = CGFloat(result.localCoordinates.y) / (self.screenSize.height / 2) * self.screenSize_points.height + heightCompensation
            }
            
            for result in phoneScreenEyeLHitTestResults {
                eyeLLookAt.x = CGFloat(result.localCoordinates.x) / (self.screenSize.width / 2) * self.screenSize_points.width
                eyeLLookAt.y = CGFloat(result.localCoordinates.y) / (self.screenSize.height / 2) * self.screenSize_points.height + heightCompensation
            }
            
            // Add the latest position and keep up to 8 recent position to smooth with.
            let smoothThresholdNumber: Int = 10
            self.xLookPositions.append((eyeRLookAt.x + eyeLLookAt.x) / 2)
            self.yLookPositions.append(-(eyeRLookAt.y + eyeLLookAt.y) / 2)
            self.xLookPositions = Array(self.xLookPositions.suffix(smoothThresholdNumber))
            self.yLookPositions = Array(self.yLookPositions.suffix(smoothThresholdNumber))
            
            let smoothEyeLookAtPositionX = self.xLookPositions.average!
            let smoothEyeLookAtPositionY = self.yLookPositions.average!
            
            // update indicator position
            self.view_lookPos.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX, y: smoothEyeLookAtPositionY)
            
            // Calculate distance of the eyes to the camera
            let distanceL = self.leftEyeNode.worldPosition - SCNVector3Zero
            let distanceR = self.rightEyeNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            let distance = (distanceL.length() + distanceR.length()) / 2
            
            // Update distance label value
            self.lbl_distance.text = "\(Int(round(distance * 100))) cm"
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    override var prefersStatusBarHidden: Bool {
        return type(of: GameManager.shared.stateMachine.currentState) == PlayingState.self
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return type(of: GameManager.shared.stateMachine.currentState) == PlayingState.self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
