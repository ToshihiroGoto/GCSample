//
//  GameViewController.swift
//  GCSampleMac
//
//  Created by Toshihiro Goto on 2019/05/30.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
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
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
        
        // Event
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            self.keyUp(with: $0)
            return $0
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        
        print(theEvent.keyCode)
        
        switch theEvent.keyCode {
        case 49:
            sphereNode.resetMove()
            return
        case 126:
            // Up
            sphereNode.positionZ = -1
        case 125:
            // Down
            sphereNode.positionZ = 1
        case 123:
            // Left
            sphereNode.positionX = -1
        case 124:
            // Right
            sphereNode.positionX = 1
        default:
            return
        }
        
        sphereNode.move()
    }
    
    override func keyUp(with theEvent: NSEvent) {
        
        switch theEvent.keyCode {
        case 126, 125:
            // Up / Down
            sphereNode.positionZ = 0
        case 123, 124:
            // Left / Right
            sphereNode.positionX = 0
        default:
            break
        }
    }

}
