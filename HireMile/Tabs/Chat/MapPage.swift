//
//  MapPage.swift
//  HireMile
//
//  Created by JJ Zapata on 3/21/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPage: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    let regionInMeters: Double = 10000
    
    var location : CLLocationCoordinate2D? {
        didSet {
            let annotation = MKPointAnnotation()
            annotation.title = "Location"
            let coordinate = CLLocationCoordinate2D(latitude: location!.latitude, longitude: location!.longitude)
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: location!, latitudinalMeters: 10000, longitudinalMeters: 10000)
            map.setRegion(region, animated: true)
        }
    }
    
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
        map.showsUserLocation = true
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location"
        
        self.map.delegate = self
        
        self.view.addSubview(map)
        self.map.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.map.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.map.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
