//
//  FloorNode.swift
//  GCSample1
//
//  Created by Toshihiro Goto on 2019/05/26.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit

class FloorNode: SCNNode {
    
    override init(){
        super.init()
        
        let floor = SCNFloor()
        let floorMatrixScale:Float = 50
        let floorMatrix = float4x4(
            float4(floorMatrixScale, 0, 0, 0),
            float4(0, floorMatrixScale, 0, 0),
            float4(0, 0, floorMatrixScale, 0),
            float4(0, 0, 0, 1)
        )
        floor.firstMaterial?.diffuse.contents = SCNImage(named: "check")
        floor.firstMaterial?.diffuse.contentsTransform = SCNMatrix4(floorMatrix)
        
        self.geometry = floor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
