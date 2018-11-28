//
//  ViewController.swift
//  ComplexFilter
//
//  Created by Wang Liu on 2018/11/28.
//  Copyright © 2018 Wang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    lazy var originalImage: UIImage = {
        return UIImage(named: "image.jpeg")!
    }()
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)

        slider.maximumValue = Float(Double.pi)
        slider.minimumValue = Float(-Double.pi)
        slider.value = 0
        slider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)

        let inputImage = CIImage(image: originalImage)
        filter = CIFilter(name: "CIHueAdjust")
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        slider.sendActions(for: .valueChanged)
    }


    @IBAction func valueChanged(_ sender: Any) {
        filter.setValue(slider.value, forKey: kCIInputAngleKey)
        let outputImage = filter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        imageView.image = UIImage(cgImage: cgImage)
    }

    // 原图
    @IBAction func showOriginalImage(_ sender: Any) {
        self.imageView.image = originalImage
    }

    // 更换背景
    @IBAction func replaceBackground(_ sender: Any) {
        let cubeMap = createCubeMap(60, 90)
        let data = NSData(bytesNoCopy: cubeMap.data, length: Int(cubeMap.length), freeWhenDone: true)

        let colorCubeFilter = CIFilter(name: "CIColorCube")!
        colorCubeFilter.setValue(cubeMap.dimension, forKey: "inputCubeDimension")
        colorCubeFilter.setValue(data, forKey: "inputCubeData")
        colorCubeFilter.setValue(CIImage(image: imageView.image!)!, forKey: kCIInputImageKey)
        var outputImage = colorCubeFilter.outputImage!

        let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")!
        sourceOverCompositingFilter.setValue(outputImage, forKey: kCIInputImageKey)
        sourceOverCompositingFilter.setValue(CIImage(image: UIImage(named: "8")!)!, forKey: kCIInputBackgroundImageKey)

        outputImage = sourceOverCompositingFilter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        imageView.image = UIImage(cgImage: cgImage)
    }

    // 显示绿色背景图
    @IBAction func showChangeImage(_ sender: Any) {
        imageView.image = UIImage(named: "7")!
    }
    

    // 反色
    @IBAction func colorInvert(_ sender: Any) {
        let colorInvertFilter = CIColorInvert()
        colorInvertFilter.inputImage = CIImage(image: imageView.image!)
        let outputImage = colorInvertFilter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        imageView.image = UIImage(cgImage: cgImage)
    }

    // 老电影
    @IBAction func oldFilmEffect(_ sender: Any) {
        let inputImage = CIImage(image: originalImage)!

        // 1.创建CISepiaTone滤镜
        let sepiaToneFilter = CIFilter(name: "CISepiaTone")!
        sepiaToneFilter.setValue(inputImage, forKey: kCIInputImageKey)
        sepiaToneFilter.setValue(1, forKey: kCIInputIntensityKey)

        // 2.创建白斑图滤镜
        let whiteSpecksFilter = CIFilter(name: "CIColorMatrix")!
        whiteSpecksFilter.setValue(CIFilter(name: "CIRandomGenerator")!.outputImage!.cropped(to: inputImage.extent), forKey: kCIInputImageKey)
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputRVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputBVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")

        // 3.把CISepiaTone滤镜和白斑图滤镜以源覆盖(source over)的方式先组合起来
        let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")!
        sourceOverCompositingFilter.setValue(whiteSpecksFilter.outputImage!, forKey: kCIInputBackgroundImageKey)
        sourceOverCompositingFilter.setValue(sepiaToneFilter.outputImage!, forKey: kCIInputImageKey)

        // 4.用CIAffineTransform滤镜先对随机噪点图进行处理
        let affineTransformFilter = CIFilter(name: "CIAffineTransform")!
        affineTransformFilter.setValue(CIFilter(name: "CIRandomGenerator")!.outputImage!.cropped(to: inputImage.extent), forKey: kCIInputImageKey)
        affineTransformFilter.setValue(NSValue(cgAffineTransform: CGAffineTransform(scaleX: 1.5, y: 25)), forKey: kCIInputTransformKey)

        // 5.创建蓝绿色磨砂图滤镜
        let darkScratchesFilter = CIFilter(name: "CIColorMatrix")!
        darkScratchesFilter.setValue(affineTransformFilter.outputImage!, forKey: kCIInputImageKey)
        darkScratchesFilter.setValue(CIVector(x: 4, y: 0, z: 0, w: 0), forKey: "inputRVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputGVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputAVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 1, z: 1, w: 1), forKey: "inputBiasVector")

        // 6.用CIMinimumComponent滤镜把蓝绿色磨砂图滤镜处理成黑色磨砂图滤镜
        let minimumComponentFilter = CIFilter(name: "CIMinimumComponent")!
        minimumComponentFilter.setValue(darkScratchesFilter.outputImage!, forKey: kCIInputImageKey)

        // 7.最终组合在一起
        let multiplyCompositingFilter = CIFilter(name: "CIMultiplyCompositing")!
        multiplyCompositingFilter.setValue(minimumComponentFilter.outputImage!, forKey: kCIInputBackgroundImageKey)
        multiplyCompositingFilter.setValue(sourceOverCompositingFilter.outputImage!, forKey: kCIInputImageKey)

        // 8.输出
        let outputImage = multiplyCompositingFilter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!

        imageView.image = UIImage(cgImage: cgImage)

    }
}

