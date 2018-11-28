//
//  ViewController.swift
//  RealTimeFilter
//
//  Created by Wang Liu on 2018/11/28.
//  Copyright © 2018 Wang Liu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        previewLayer = CALayer()
        previewLayer.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: self.view.frame.size.width)
        previewLayer.position = CGPoint(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/2.0)
        previewLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(Float.pi/2.0)))
        self.view.layer.insertSublayer(previewLayer, at: 0)

        setupCaptureSession()
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        captureSession.sessionPreset = .low
        let captureDevice = AVCaptureDevice.default(for: .video)!
        let deviceInput = try! AVCaptureDeviceInput.init(device: captureDevice)
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        let queue = DispatchQueue(label: "VideoQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.commitConfiguration()
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
    }


}

