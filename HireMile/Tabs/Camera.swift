//
//  Camera.swift
//  HireMile
//
//  Created by JJ Zapata on 12/3/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Camera: UIViewController {

    let cameraButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.alpha = 0.35
        view.clipsToBounds = true
        return view
    }()

    let secondViewCameraPress : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 27.5
        view.alpha = 0.5
        view.clipsToBounds = true
        return view
    }()

    let mainViewCameraPress : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    let buttonShutterButton : UIView = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonShutterButtonPressed), for: .touchUpInside)
        return button
    }()

    let xButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(xmarktouched), for: .touchUpInside)
        return button
    }()

//    let xButton : UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "xmark"), for: .normal)
//        button.tintColor = UIColor.white
//        button.addTarget(self, action: #selector(xmarktouched), for: .touchUpInside)
//        return button
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black

        setupUI()
//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        startRunningCaptureSession()
    }

    func setupUI() {

        self.view.addSubview(xButton)
        xButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        xButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        xButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        self.view.addSubview(self.cameraButtonView)
        cameraButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        cameraButtonView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cameraButtonView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        cameraButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cameraButtonView.backgroundColor = UIColor.darkGray

        self.cameraButtonView.addSubview(self.secondViewCameraPress)
        secondViewCameraPress.centerYAnchor.constraint(equalTo: self.cameraButtonView.centerYAnchor).isActive = true
        secondViewCameraPress.widthAnchor.constraint(equalToConstant: 55).isActive = true
        secondViewCameraPress.heightAnchor.constraint(equalToConstant: 55).isActive = true
        secondViewCameraPress.centerXAnchor.constraint(equalTo: self.cameraButtonView.centerXAnchor).isActive = true
        secondViewCameraPress.backgroundColor = UIColor.lightGray

        self.view.addSubview(self.mainViewCameraPress)
        mainViewCameraPress.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainViewCameraPress.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainViewCameraPress.centerXAnchor.constraint(equalTo: self.secondViewCameraPress.centerXAnchor).isActive = true
        mainViewCameraPress.centerYAnchor.constraint(equalTo: self.secondViewCameraPress.centerYAnchor).isActive = true
        
        self.view.addSubview(self.buttonShutterButton)
        self.buttonShutterButton.topAnchor.constraint(equalTo: self.cameraButtonView.topAnchor).isActive = true
        self.buttonShutterButton.leftAnchor.constraint(equalTo: self.cameraButtonView.leftAnchor).isActive = true
        self.buttonShutterButton.rightAnchor.constraint(equalTo: self.cameraButtonView.rightAnchor).isActive = true
        self.buttonShutterButton.bottomAnchor.constraint(equalTo: self.cameraButtonView.bottomAnchor).isActive = true
        
        // button set image, last from camera roll
    }

//    func setupCaptureSession() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//    }
//
//    func setupDevice() {
//        let deviceDiscovreySession = AVCaptureDevice.DiscoverySession(deviceType: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], angle, mediaType: AVMediaType.video, position: AVCaptureDevice.position.unspecified)
//        let devices = deviceDiscovreySession.devices
//        for device in devices {
//            if device.position ==  AVCaptureDevice.Position.back {
//                backCamera = device
//            } else if device.position == AVCaptureDevice.Position.front {
//                frontCamera = device
//            }
//        }
//        currentCamera = backCamera
//    }
//
//    func setupInputOutput() {
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
//            captureSession.addInput(captureDeviceInput)
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
//        } catch {
//            print(error)
//        }
//    }
//
//    func setupPreviewLayer() {
//        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//        cameraPreviewLayer?.frame = self.view.frame
//        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
//    }
//
//    func startRunningCaptureSession() {
//        captureSession.startRunning()
//    }

    @objc func buttonShutterButtonPressed() {
        print("hi")
    }

    @objc func xmarktouched () {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Your current post will not be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
