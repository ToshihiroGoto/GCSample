//
//  ProcdualSky.swift
//  GCSample1
//
//  Created by Toshihiro Goto on 2019/05/26.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit
import ModelIO

class ProcdualSky: NSObject {
    
    open class var texture:MDLTexture {
        // MDLSkyCubeTexture
        let skyTexture = MDLSkyCubeTexture(
            name: "sky",
            channelEncoding: .uInt8,
            textureDimensions: vector_int2(128, 128),
            turbidity: 1.0,
            sunElevation: 0.778,
            sunAzimuth: 0,
            upperAtmosphereScattering: 0.4,
            groundAlbedo: 0.33
        )
        
        let groundColor = SCNColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.0)
        skyTexture.groundColor = groundColor.cgColor
        
        skyTexture.gamma = 0.05
        skyTexture.exposure = 0
        skyTexture.brightness = 0
        skyTexture.contrast = 0
        skyTexture.saturation = -2
        
        skyTexture.update()
        
        return skyTexture
    }
}
