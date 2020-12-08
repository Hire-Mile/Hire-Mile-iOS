//
//  ViewPostController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/18/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import ZKCarousel

class ViewPostController: UIViewController, UITextFieldDelegate {
    
    let carousel : ZKCarousel = {
        let carousel = ZKCarousel()
        let firstSlide = ZKCarouselSlide(image: UIImage(named: "grayBack"), title: "", description: "")
        let secondSlide = ZKCarouselSlide(image: UIImage(named: "grayBack"), title: "", description: "")
        let thirdSlide = ZKCarouselSlide(image: UIImage(named: "grayBack"), title: "", description: "")
        let fourthSlide = ZKCarouselSlide(image: UIImage(named: "grayBack"), title: "", description: "")
        carousel.slides = [firstSlide, secondSlide, thirdSlide, fourthSlide]
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    let informationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 40
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Description"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "woman-profile")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.text = "  Say Something..."
        tf.borderStyle = .none
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 2
        tf.returnKeyType = .done
        tf.layer.borderColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        tf.attributedPlaceholder = NSAttributedString(string: "  Say Something...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("SEND", for: .normal)
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addSubviews() {
        self.view.addSubview(self.carousel)
        self.view.addSubview(self.informationView)
        self.informationView.addSubview(self.titleLabel)
        self.informationView.addSubview(self.descriptionLabel)
        self.informationView.addSubview(self.priceLabel)
        self.informationView.addSubview(self.profileImage)
        self.view.addSubview(self.textField)
        self.view.addSubview(self.seeAllButton)
    }
    
    func addConstraints() {
        
        self.carousel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.carousel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.carousel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.carousel.heightAnchor.constraint(equalToConstant: self.view.frame.height / 3).isActive = true
        
        self.informationView.topAnchor.constraint(equalTo: self.carousel.bottomAnchor, constant: 20).isActive = true
        self.informationView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.informationView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.informationView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: self.informationView.topAnchor, constant: 15).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -5).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.descriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: -15).isActive = true
        self.priceLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.priceLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.profileImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -15).isActive = true
        self.profileImage.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.textField.topAnchor.constraint(equalTo: self.informationView.bottomAnchor, constant: 20).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.seeAllButton.rightAnchor.constraint(equalTo: self.textField.rightAnchor).isActive = true
        self.seeAllButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.seeAllButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.seeAllButton.centerYAnchor.constraint(equalTo: self.textField.centerYAnchor).isActive = true
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        
        self.textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.topItem?.title = "Albert Smith"
    }
    
    func changeButtonStatus() {
        if self.textField.text != " " || self.textField.text != "  " || self.textField.text != "   " {
            self.seeAllButton.backgroundColor = UIColor.mainBlue
            self.seeAllButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.seeAllButton.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1)
            self.seeAllButton.setTitleColor(UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1), for: .normal)
        }
    }
    
    @objc func keyboardUp(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 100
        }
    }
    
    @objc func keyboardDown(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // action here
        self.navigationController?.pushViewController(OtherProfile(), animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("began")
        if textField.text != "  Say Something..." {
            //
        } else {
            self.textField.text = "   "
        }
    }
    
    @objc func textFieldDidChange() {
        self.changeButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    
    @objc func sendPressed() {
        if self.textField.text != " " && self.textField.text != "  " && self.textField.text != "   " && self.textField.text != nil && self.textField.text != "  Say Something..." {
            let alert = UIAlertController(title: "Message Sent", message: "Your messsage to Albert was successful", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter valid text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
