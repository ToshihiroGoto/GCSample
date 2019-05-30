//
//  MultiPlatformSettings.swift
//  GCSample1
//
//  Created by Toshihiro Goto on 2019/05/26.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

#if os(macOS)
import Cocoa
typealias SCNColor = NSColor
typealias SCNImage = NSImage
#else
import UIKit
typealias SCNColor = UIColor
typealias SCNImage = UIImage
#endif
