//
//  ViewController.swift
//  SimpleFilter
//
//  Created by Wang Liu on 2018/11/28.
//  Copyright © 2018 Wang Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    lazy var originalImage: UIImage = {
        return UIImage(named: "4.jpeg")!
    }()

    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()

    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        showFiltersInConsole()

        self.imageView.layer.shadowOpacity = 0.8
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.imageView.image = originalImage
    }

    @IBAction func showOriginalImage(_ sender: Any) {
        self.imageView.image = originalImage
    }
    
    @IBAction func autoAdjust(_ sender: Any) {
        var inputImage = CIImage(image: originalImage)!
        let filters = inputImage.autoAdjustmentFilters()
        for filter: CIFilter in filters {
//            let inputKeys = filter.inputKeys
//            print(filter.name)
//            print(inputKeys)
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage = filter.outputImage!
        }
//        self.imageView.image = UIImage(ciImage: inputImage)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            self.imageView.image = UIImage(cgImage: cgImage)
        }
    }

    // MARK: - 怀旧
    @IBAction func photoEffectInstant(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectInstant")
        outputImage()
    }

    // MARK: - 色调
    @IBAction func photoEffectTonal(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectTonal")
        outputImage()
    }

    // MARK: - 岁月
    @IBAction func photoEffectTransfer(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectTransfer")
        outputImage()
    }

    // MARK: - 黑白
    @IBAction func photoEffectNoir(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectNoir")
        outputImage()
    }

    // MARK: - 褪色
    @IBAction func photoEffectFade(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectFade")
        outputImage()
    }

    // MARK: - 冲印
    @IBAction func photoEffectProcess(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectProcess")
        outputImage()
    }

    // MARK: - 铬黄
    @IBAction func photoEffectChrome(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectChrome")
        outputImage()
    }

    // MARK: - 单色
    @IBAction func photoEffectMono(_ sender: Any) {
        filter = CIFilter(name: "CIPhotoEffectMono")
        outputImage()
    }
    


    func outputImage() {
        print(filter)
        let inputImage = CIImage(image: originalImage)!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        self.imageView.image = UIImage(cgImage: cgImage)
    }


    func showFiltersInConsole() {
        let filterNames = CIFilter.filterNames(inCategory: kCICategoryColorEffect)
        print(filterNames.count)
        print(filterNames)
        for filterName in filterNames {
            print(filterName)
            let filter = CIFilter(name: filterName)!
            let attributes = filter.attributes
            print(attributes)
            print("==================================================")
        }
    }
}

