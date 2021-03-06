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
import CoreMotion

/* ----------------------------------------------------------------------------------------- */

enum InputMethod: Int {
    case gyro = 0
    case eyeTracking = 1
    
    static var allValues = [gyro, eyeTracking]
}

/* ----------------------------------------------------------------------------------------- */
// - Creates and holds a reference to the game manager
// - Holds a reference to and manages the scene view
// - Initializes and handles the face tracking session

class ViewController: UIViewController, ARSKViewDelegate {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    @IBOutlet var sceneView: ARSKView!
    
    var gameManager: GameManager!
    
    var motionManager = CMMotionManager()
    
    var inputMethod: InputMethod = .gyro {
        didSet {
            Log.info(inputMethod)
        }
    }
    
    var showDevTools: Bool! {
        didSet {
            if (showDevTools == true) {
                view_devTools.isHidden = false
                sceneView.showsFPS = true
                sceneView.showsNodeCount = true
                sceneView.showsPhysics = true
            } else {
                view_devTools.isHidden = true
                sceneView.showsFPS = false
                sceneView.showsNodeCount = false
                sceneView.showsPhysics = false
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(){
        super.init(nibName: "View", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.function()
        
        gameManager = GameManager(scene: GameScene())
        gameManager.viewController = self
        
        sceneView.delegate = self
        sceneView.ignoresSiblingOrder = true
        sceneView.presentScene(gameManager.scene)
        
        gameManager.state = .starting

        showDevTools = false
        view_devTools.isUserInteractionEnabled = false
        
//        if ARFaceTrackingConfiguration.isSupported {
//            inputMethod = .eyeTracking
//        } else {
//            inputMethod = .gyro
//        }
        
        inputMethod = .gyro
        
        startTrackingInput()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func startTrackingInput() {
        switch(inputMethod) {
        case .gyro:
            motionManager.deviceMotionUpdateInterval = 0.2
            motionManager.gyroUpdateInterval = 0.2
            motionManager.startDeviceMotionUpdates()
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if data != nil {
                    self.lookPoints.push(element: CGPoint(x: data!.acceleration.x, y: data!.acceleration.y))
                }
            }
        case .eyeTracking:
            let configuration = ARFaceTrackingConfiguration()
            configuration.isLightEstimationEnabled = false
            sceneView.session.run(configuration)
        }
    }
    
    func stopTrackingInput() {
        switch(inputMethod) {
        case .gyro:
            motionManager.stopAccelerometerUpdates()
            motionManager.stopDeviceMotionUpdates()
        case .eyeTracking:
            sceneView.session.pause()
        }
    }
    
    var point: CGPoint {
        get {
            return lookPoints.average
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    private var faceNode: SCNNode = SCNNode()
    
    private var leftEyeNode: SCNNode = {
        let node = SCNNode()
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    private var rightEyeNode: SCNNode = {
        let node = SCNNode()
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    private var leftTargetNode: SCNNode = SCNNode()
    private var rightTargetNode: SCNNode = SCNNode()
    
    // actual physical size of iPhoneX screen
    private let screenSize: CGSize = UIScreen.main.bounds.size
    
    // actual point size of iPhoneX screen
    private let screenSize_points = CGSize(width: 375, height: 812)
    
    private var virtualPhoneNode: SCNNode = SCNNode()
    
    private var virtualScreenNode: SCNNode = {
        let screenGeometry = SCNPlane(width: 1, height: 1)
        return SCNNode(geometry: screenGeometry)
    }()
    
    private var lookPoints = CircularBuffer(size: 12, initialElement: .zero)
    
    @IBOutlet weak var lbl_xLookPos: UILabel!
    @IBOutlet weak var lbl_yLookPos: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var view_lookPos: UIView!
    
    @IBOutlet weak var view_devTools: UIView!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - ARSKViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        let alert = UIAlertController(title: "OOPS!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: nil))
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
            
            self.lookPoints.push(element: CGPoint(x:  (eyeRLookAt.x + eyeLLookAt.x) / 2.0, y: -(eyeRLookAt.y + eyeLLookAt.y) / 2.0))
        
            // Calculate distance of the eyes to the camera
            let distanceL = self.leftEyeNode.worldPosition - SCNVector3Zero
            let distanceR = self.rightEyeNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            let distance = (distanceL.length() + distanceR.length()) / 2
            
            // update indicator position
            self.view_lookPos.transform = CGAffineTransform(translationX: self.lookPoints.average.x, y: self.lookPoints.average.y)
            self.lbl_distance.text = "\(Int(round(distance * 100))) cm"
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    override var prefersStatusBarHidden: Bool { return true }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func presentAd() {
        gameManager.scene.isPaused = true
    }
    
    func presentPrivacyAlert() {
        let alert = UIAlertController(title: "Uh oh...", message: """
            It looks like your iOS device doesent support face ID.
            To control the blaster, tilt your device in the direction you want to shoot.
        """, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Alright", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Don't warn me again", style: .default, handler: nil))
       
        self.present(alert, animated: true) {
            self.inputMethod = .gyro
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
