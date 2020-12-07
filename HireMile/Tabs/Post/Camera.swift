//
//  Camera.swift
//  HireMile
//
//  Created by JJ Zapata on 12/3/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class Camera: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera : AVCaptureDevice?
    var frontCamera : AVCaptureDevice?
    var currentCamera : AVCaptureDevice?
    var photoOutput : AVCapturePhotoOutput?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var isOutside = true
    
    var passingImage : UIImage?
    
    var timer : Timer?
    
    var imageArray = [UIImage]()
    var images:[UIImage] = []
    
    let imagePicker = UIImagePickerController()

    let cameraButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 37.5
        view.alpha = 0.35
        view.clipsToBounds = true
        return view
    }()

    let secondViewCameraPress : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32.5
        view.alpha = 0.5
        view.clipsToBounds = true
        return view
    }()

    let mainViewCameraPress : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        view.layer.cornerRadius = 27.5
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
    
    let cameraRollButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(photoBoothTouched), for: .touchUpInside)
        return button
    }()
    
    let swapCameraButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.mainBlue
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cameraSwap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        self.view.backgroundColor = UIColor.black

        self.setupUI()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        fetchPhotos()
        
    }

    func setupUI() {
        self.view.addSubview(xButton)
        xButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        xButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        xButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        self.view.addSubview(self.cameraButtonView)
        cameraButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        cameraButtonView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cameraButtonView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cameraButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cameraButtonView.backgroundColor = UIColor.darkGray

        self.cameraButtonView.addSubview(self.secondViewCameraPress)
        secondViewCameraPress.centerYAnchor.constraint(equalTo: self.cameraButtonView.centerYAnchor).isActive = true
        secondViewCameraPress.widthAnchor.constraint(equalToConstant: 65).isActive = true
        secondViewCameraPress.heightAnchor.constraint(equalToConstant: 65).isActive = true
        secondViewCameraPress.centerXAnchor.constraint(equalTo: self.cameraButtonView.centerXAnchor).isActive = true
        secondViewCameraPress.backgroundColor = UIColor.lightGray

        self.view.addSubview(self.mainViewCameraPress)
        mainViewCameraPress.widthAnchor.constraint(equalToConstant: 55).isActive = true
        mainViewCameraPress.heightAnchor.constraint(equalToConstant: 55).isActive = true
        mainViewCameraPress.centerXAnchor.constraint(equalTo: self.secondViewCameraPress.centerXAnchor).isActive = true
        mainViewCameraPress.centerYAnchor.constraint(equalTo: self.secondViewCameraPress.centerYAnchor).isActive = true
        
        self.view.addSubview(self.buttonShutterButton)
        self.buttonShutterButton.topAnchor.constraint(equalTo: self.cameraButtonView.topAnchor).isActive = true
        self.buttonShutterButton.leftAnchor.constraint(equalTo: self.cameraButtonView.leftAnchor).isActive = true
        self.buttonShutterButton.rightAnchor.constraint(equalTo: self.cameraButtonView.rightAnchor).isActive = true
        self.buttonShutterButton.bottomAnchor.constraint(equalTo: self.cameraButtonView.bottomAnchor).isActive = true
        
        self.view.addSubview(cameraRollButton)
        cameraRollButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        cameraRollButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        cameraRollButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cameraRollButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(swapCameraButton)
        swapCameraButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        swapCameraButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        swapCameraButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        swapCameraButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscovreySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscovreySession.devices
        for device in devices {
            if device.position ==  AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupDeviceBack() {
        let deviceDiscovreySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscovreySession.devices
        for device in devices {
            if device.position ==  AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }

    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        } catch {
            print(error)
        }
    }

    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }

    func startRunningCaptureSession() {
        captureSession.startRunning()
    }

    func fetchPhotos () {
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 3
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 3
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
            self.cameraRollButton.setImage(images[0], for: .normal)
        }
    }
    
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                self.images += [image]
            }
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                print("Completed array: \(self.images)")
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.passingImage = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.passingImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }

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
    
    @objc func photoBoothTouched () {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func timerFunction() {
        if self.passingImage != nil {
            GlobalVariables.postImage = passingImage!
            let controller = Post()
            controller.modalPresentationStyle = .fullScreen
            timer?.invalidate()
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func cameraSwap() {
        if self.isOutside == false {
            print("helo")
        } else {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
                self.captureSession.stopRunning()
                captureSession.removeInput(captureDeviceInput)
                setupCaptureSession()
                setupDeviceBack()
                setupInputOutput()
                setupPreviewLayer()
                startRunningCaptureSession()
                fetchPhotos()
            } catch {
                print("error found")
            }
        }
    }

}
