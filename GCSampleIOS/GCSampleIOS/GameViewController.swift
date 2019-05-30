//
//  GameViewController.swift
//  GCSampleIOS
//
//  Created by Toshihiro Goto on 2019/05/29.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import GameController

class GameViewController: UIViewController {
    
    private var sphereNode:SphereNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scene
        let scene = SCNScene()
        
        // Texture: ProcdualSky
        let skyTexture = ProcdualSky.texture
        scene.background.contents = skyTexture
        scene.lightingEnvironment.contents = skyTexture
        
        // Geometry
        sphereNode = SphereNode()
        scene.rootNode.addChildNode(sphereNode)
        
        let floorNode = FloorNode()
        scene.rootNode.addChildNode(floorNode)
        
        // Light
        let light = SCNLight()
        light.type = .directional
        light.intensity = 1000
        light.castsShadow = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.simdPosition.y = 10
        lightNode.simdEulerAngles = float3(-(0.25 * .pi), 0.0, -(0.25 * .pi))
        scene.rootNode.addChildNode(lightNode)
        
        // Camera
        let camera = SCNCamera()
        camera.zNear = 0.1
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.simdPosition = float3(0.0, 4.0, 4.0)
        cameraNode.simdEulerAngles.x = -(0.25 * .pi)
        scene.rootNode.addChildNode(cameraNode)
        
        // Constraint
        let lookAtConstraint = SCNLookAtConstraint(target: sphereNode)
        lookAtConstraint.influenceFactor = 0.07
        lookAtConstraint.isGimbalLockEnabled = true
        cameraNode.constraints = [lookAtConstraint]
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.scene = scene
        //scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        // Setup: Game Controller
        setupGameController()
    }
    
    // MARK: - GameController
    func setupGameController() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        guard let controller = GCController.controllers().first else {
            return
        }
        registerGameController(controller)
    }
    
    @objc
    func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }
        
        registerGameController(gameController)
    }
    
    @objc
    func handleControllerDidDisconnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }
        
        unregisterGameController()
        
        for controller: GCController in GCController.controllers() where gameController != controller {
            registerGameController(controller)
        }
        
    }
    
    func registerGameController(_ gameController: GCController) {
        
        var buttonA: GCControllerButtonInput?
        var buttonB: GCControllerButtonInput?
        var gamePadLeft: GCControllerDirectionPad?
        
        print(String(describing: gameController.vendorName))
        
        if let gamepad = gameController.extendedGamepad {
            gamePadLeft = gamepad.leftThumbstick
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
            print("Controller: extendedGamepad")
        } else if let gamepad = gameController.gamepad {
            gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
            print("Controller: gamepad")
        } else if let gamepad = gameController.microGamepad {
            gamepad.allowsRotation = true
            gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonX
            buttonB = gamepad.buttonA
            print("Controller: microGamepad")
        }
        
        gamePadLeft?.valueChangedHandler = {(_ dpad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void in
            
            self.sphereNode.positionX = xValue
            self.sphereNode.positionZ = -yValue
            
            self.sphereNode.move()
        }
        
        buttonA?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            
            self.sphereNode.resetMove()
        }
        
        buttonB?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            
            self.sphereNode.resetMove()
        }
    }
    
    func unregisterGameController() {
    }
}
