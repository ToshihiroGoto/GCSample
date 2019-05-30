//
//  SphereNode.swift
//  GCSample1
//
//  Created by Toshihiro Goto on 2019/05/26.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit

class SphereNode: SCNNode {
    
    // 移動距離
    private var accel:Float = 0.5

    // 移動差分 
    public var positionX:Float = 0.0 {
        didSet {
            positionX *= accel
        }
    }
    
    public var positionZ:Float = 0.0 {
        didSet {
            positionZ *= accel
        }
    }
    
    override init(){
        super.init()
        
        // 球の半径
        let radius:CGFloat = 0.5
        
        // 球のジオメトリとこのノードに挟むノード
        let sphereGeometryNode = SCNNode()
        sphereGeometryNode.name = "sphereGeometryNode"
        sphereGeometryNode.simdPosition.y = Float(radius)
        
        // 球のジオメトリの生成
        sphereGeometryNode.geometry = SCNSphere(radius: radius)
        sphereGeometryNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
        sphereGeometryNode.geometry?.firstMaterial?.diffuse.contents = SCNColor.red
        
        // 上記のノードをこのノードに設定する
        self.name = "sphereNode"
        self.addChildNode(sphereGeometryNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 移動アニメーション
    func move(){
        self.runAction(
            SCNAction.moveBy(
                x: CGFloat(positionX),
                y: 0,
                z: CGFloat(positionZ),
                duration: 0.1
            )
        )
    }
    
    // 移動をリセットするアニメーション
    func resetMove(){
        positionX = 0
        positionZ = 0
        
        let length = simd_length(self.simdPosition) / 100.0
        
        self.runAction(
            SCNAction.sequence([
                SCNAction.move(to: SCNVector3(0,0,0), duration: TimeInterval(length)),
                SCNAction.wait(duration: 1.0)
            ])
        )
    }
}
