//
//  CIColorInvert.swift
//  ComplexFilter
//
//  Created by Wang Liu on 2018/11/28.
//  Copyright © 2018 Wang Liu. All rights reserved.
//

import UIKit

class CIColorInvert: CIFilter {
    var inputImage: CIImage!

    override var outputImage: CIImage! {
        get {
            return CIFilter(name: "CIColorMatrix", parameters: [
                kCIInputImageKey : inputImage,
                "inputRVector" : CIVector(x: -1, y: 0, z: 0),
                "inputGVector" : CIVector(x: 0, y: -1, z: 0),
                "inputBVector" : CIVector(x: 0, y: 0, z: -1),
                "inputBiasVector" : CIVector(x: 1, y: 1, z: 1)
                ])!.outputImage
        }
    }
}
