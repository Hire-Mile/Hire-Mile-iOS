//
//  AllowLocation.swift
//  HireMile
//
//  Created by JJ Zapata on 2/9/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation
import MapKit

class AllowLocation: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    let map : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsCompass = false
        map.showsTraffic = false	
        map.showsBuildings = false
        map.showsLargeContentViewer = false
        map.showsScale = false
        map.showsLargeContentViewer = false
        map.showsBuildings = false
        return map
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Location", for: .normal)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.backgroundColor = UIColor.mainBlue
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let backButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        view.backgroundColor = .white
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let backButtonImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.backward")
        return imageView
    }()
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        self.map.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkLocationServices), userInfo: nil, repeats: true)
        
        self.view.addSubview(map)
        self.map.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.map.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.map.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(bottomView)
        self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.bottomView.addSubview(self.button)
        self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(backButtonView)
        backButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButtonView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        backButtonView.addSubview(backButtonImage)
        backButtonImage.centerXAnchor.constraint(equalTo: self.backButtonView.centerXAnchor).isActive = true
        backButtonImage.centerYAnchor.constraint(equalTo: self.backButtonView.centerYAnchor).isActive = true
        backButtonImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButtonImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        backButtonView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: backButtonView.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: backButtonView.leftAnchor).isActive = true
        backButton.rightAnchor.constraint(equalTo: backButtonView.rightAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        
        self.view.backgroundColor = UIColor.red

        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    @objc func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    @objc func nextPressed() {
        self.successCompletion()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            self.timer?.invalidate()
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            let alert = UIAlertController(title: "Cannot find location", message: "Please go to Settings and allow location to view this screen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            let alert = UIAlertController(title: "Cannot find location", message: "Your location is marked as 'restricted'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            map.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func successCompletion() {
        MBProgressHUD.hide(for: self.view, animated: true)
        let controller = Biometrics()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
