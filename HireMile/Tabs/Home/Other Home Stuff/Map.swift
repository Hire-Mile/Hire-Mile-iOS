//
//  Map.swift
//  HireMile
//
//  Created by JJ Zapata on 2/5/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import FirebaseDatabase
import SDWebImage
class Map: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    let regionInMeters: Double = 10000
    
    let urlLink = "https://firebasestorage.googleapis.com/v0/b/hiremile-aaacc.appspot.com/o/Grupo%202273%403x.png?alt=media&token=7d506e89-5755-4c4f-960a-bbbb025f3e5c"

    
    var postId = ""
    
    var authorOfPost = ""
    
    var postImage = ""
    
    var postPrice = 0
    
    var imageUrl = ""
    
    var postDesc = ""
    
    var postItlte = ""
    
    var isPresenting = false
    
    var locations = ["", ""]
    
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
    
    let popUpView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    let applyButton : MainButton = {
        let button = MainButton(title: "View Post")
        button.addTarget(self, action: #selector(viewPostSelected), for: .touchUpInside)
        return button
    }()
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let postAuthorImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let authorName : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let price : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleOfPost : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let exitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()
    
    let centerButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "centerOnMap"), for: .normal)
        button.addTarget(self, action: #selector(centerViewOnUserLocation), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        view.backgroundColor = .red
        
        self.view.addSubview(map)
        self.map.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.map.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.map.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
        
        self.map.delegate = self
        
        self.view.addSubview(centerButton)
        self.centerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.centerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
        self.centerButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        self.centerButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.view.addSubview(self.popUpView)
        self.popUpView.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.popUpView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.popUpView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.popUpView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        self.popUpView.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.popUpView.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.popUpView.addSubview(self.postImageView)
        self.postImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.postImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.postImageView.bottomAnchor.constraint(equalTo: self.applyButton.topAnchor, constant: -20).isActive = true
        self.postImageView.topAnchor.constraint(equalTo: self.popUpView.topAnchor, constant: 20).isActive = true
        
        self.popUpView.addSubview(self.postAuthorImageView)
        self.postAuthorImageView.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 15).isActive = true
        self.postAuthorImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.postAuthorImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.postAuthorImageView.topAnchor.constraint(equalTo: self.postImageView.topAnchor).isActive = true
        
        self.popUpView.addSubview(authorName)
        self.authorName.leftAnchor.constraint(equalTo: self.postAuthorImageView.rightAnchor, constant: 15).isActive = true
        self.authorName.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -65).isActive = true
        self.authorName.topAnchor.constraint(equalTo: self.postImageView.topAnchor).isActive = true
        self.authorName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.popUpView.addSubview(price)
        self.price.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 15).isActive = true
        self.price.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.price.topAnchor.constraint(equalTo: self.postAuthorImageView.bottomAnchor, constant: 15).isActive = true
        self.price.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.popUpView.addSubview(titleOfPost)
        self.titleOfPost.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 15).isActive = true
        self.titleOfPost.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100).isActive = true
        self.titleOfPost.topAnchor.constraint(equalTo: self.postAuthorImageView.bottomAnchor, constant: 15).isActive = true
        self.titleOfPost.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.popUpView.addSubview(exitButton)
        self.exitButton.rightAnchor.constraint(equalTo: self.popUpView.rightAnchor, constant: -30).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.popUpView.topAnchor, constant: 15).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backButtonTitle = " "
        
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
        Database.database().reference().child("Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = JobStructure()
                job.authorName = value["author"] as? String ?? "Error"
                job.titleOfPost = value["title"] as? String ?? "Error"
                job.descriptionOfPost = value["description"] as? String ?? "Error"
                job.price = value["price"] as? Int ?? 0
                job.category = value["category"] as? String ?? "Error"
                job.imagePost = value["image"] as? String ?? "Error"
                job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                job.postId = value["postId"] as? String ?? "Error"
                job.lat = value["lat"] as? Float ?? 0
                job.long = value["long"] as? Float ?? 0
                if job.lat != 0 || job.long != 0 {
                    self.addAnnotation(withPostId: job.postId!, withTitle: job.titleOfPost!, withDesc: job.descriptionOfPost!, withImageUrl: job.imagePost!, latitude: job.lat!, longitude: job.long!)
                } else {
                    print("no lcoatino")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func viewPostSelected() {
        GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.imageUrl)
        GlobalVariables.postImageDownlodUrl = self.imageUrl
        GlobalVariables.postTitle = self.postItlte
        GlobalVariables.postDescription = self.postDesc
        GlobalVariables.postPrice = self.postPrice
        GlobalVariables.userUID = self.authorOfPost
        GlobalVariables.authorId = self.authorOfPost
        GlobalVariables.postId = self.postId
        GlobalVariables.type = "Total"
        let controller = ViewPostController()
        Database.database().reference().child("Users").child(authorOfPost).child("profile-image").observe(.value) { (snapshot) in
            if let profileImageUrl : String = (snapshot.value as? String) {
                controller.profileImage.sd_setImage(with: URL(string: profileImageUrl)) { image, _, _, _ in
                    guard let image = image else { return }
                    controller.profileImage.image = image
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
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
        @unknown default:
            fatalError()
        }
    }
    
    func addAnnotation(withPostId postId: String, withTitle title: String, withDesc desc: String, withImageUrl imageURL: String, latitude: Float, longitude: Float) {
        let annotation = ImportantAnnotation(title: title, subtitle: desc, imageURL: imageURL, id: postId, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
        self.map.addAnnotation(annotation)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            var annotationView = self.map.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
            return annotationView
        } else {
            var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        if let annotation = view.annotation as? ImportantAnnotation {
            print(annotation.id!)
            if let postId = annotation.id {
                self.postId = postId
                Database.database().reference().child("Jobs").child(postId).child("image").observe(.value) { (imageSnap) in
                    if let postImageUrl : String = (imageSnap.value as? String) {
                        self.imageUrl = postImageUrl
                        self.postImageView.sd_setImage(with: URL(string: postImageUrl)!, completed: nil)
                        Database.database().reference().child("Jobs").child(postId).child("title").observe(.value) { (titleSnap) in
                            if let titleOfJob : String = (titleSnap.value as? String) {
                                self.titleOfPost.text = titleOfJob
                                self.postItlte = titleOfJob
                                Database.database().reference().child("Jobs").child(postId).child("price").observe(.value) { (priceSnap) in
                                    if let price = priceSnap.value as? NSNumber {
                                        let priceInt = Int(price)
                                        self.postPrice = priceInt
                                        self.price.text = String("$\(priceInt)")
                                        Database.database().reference().child("Jobs").child(postId).child("author").observe(.value) { (authSnap) in
                                            if let authString : String = (authSnap.value as? String) {
                                                print("THE AUTH STIRNG IS: \(authString)")
                                                self.authorOfPost = authString
                                                Database.database().reference().child("Users").child(authString).child("profile-image").observe(.value) { (authImage) in
                                                    if let authImageUrl : String = (authImage.value as? String) {
                                                        self.postAuthorImageView.sd_setImage(with: URL(string: authImageUrl)!, completed: nil)
                                                        Database.database().reference().child("Users").child(authString).child("name").observe(.value) { (authName) in
                                                            if let authNameString : String = (authName.value as? String) {
                                                                self.authorName.text = authNameString
                                                                Database.database().reference().child("Jobs").child(postId).child("description").observe(.value) { (descSnap) in
                                                                    if let postDesc : String = (descSnap.value as? String) {
                                                                        self.postDesc = postDesc
                                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                                            self.showPopup()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.dismissPopup()
    }
    
    func showPopup() {
        if isPresenting {
            dismissPopup()
        } else {
            isPresenting = true
            UIView.animate(withDuration: 0.5) {
                self.popUpView.frame.origin.y -= 280
            }
        }
    }
    
    func dismissPopup() {
        isPresenting = false
        UIView.animate(withDuration: 0.5) {
            self.popUpView.frame.origin.y += 280
        }
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

class ImageAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class ImportantAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var imageURL: String?
    var id: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, imageURL: String, id: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.id = id
        self.coordinate = coordinate
    }
    
}
