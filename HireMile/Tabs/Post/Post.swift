//
//  Post.swift
//  HireMile
//
//  Created by JJ Zapata on 4/15/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class Post: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var homeRemove = false
    
    let pickerController = UIImagePickerController()
    
    let filterLauncher = PostSourceLauncher()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    let view1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        view.layer.cornerRadius = 3
        return view
    }()
    
    let view2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        view.layer.cornerRadius = 3
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        return button
    }()
    
    let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 15
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cameraImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = UIImage(named: "camera")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cameraLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(red: 72/255, green: 173/255, blue: 242/255, alpha: 1)
        label.text = "Add Photo"
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        label.text = "Title"
        return label
    }()
    
    let titleLabelView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = "Post a Service"
        return label
    }()
    
    let title1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.mainBlue
        label.text = "1. Photos"
        return label
    }()
    
    let title2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(r: 230, g: 230, b: 230)
        label.text = "2. Details"
        return label
    }()
    
    let emailTextField : MainTextField = {
        let textfield = MainTextField(placeholderString: "Write here")
        textfield.keyboardType = .default
        return textfield
    }()
    
    let button : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPhoto), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let loginButton : MainButton = {
        let button = MainButton(title: "Next")
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Post Service"
        
        view.backgroundColor = UIColor.white
        
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.touchDown)
        
        self.view.addSubview(backButton)
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(titleLabelView)
        self.titleLabelView.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 10).isActive = true
        self.titleLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.titleLabelView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.titleLabelView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(scrollView)
        self.scrollView.contentSize = CGSize(width: (self.view.frame.width / 2) - 60, height: 900)
        self.scrollView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 12).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        self.scrollView.addSubview(photoImageView)
        self.photoImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 150).isActive = true
        self.photoImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.photoImageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.photoImageView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        self.scrollView.addSubview(cameraImage)
        self.cameraImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.cameraImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.cameraImage.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 65).isActive = true
        self.cameraImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(cameraLabel)
        self.cameraLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.cameraLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.cameraLabel.topAnchor.constraint(equalTo: cameraImage.bottomAnchor, constant: 15).isActive = true
        self.cameraLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 42).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.scrollView.addSubview(emailTextField)
        self.emailTextField.delegate = self
        self.emailTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 06).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.scrollView.addSubview(button)
        self.button.topAnchor.constraint(equalTo: self.photoImageView.topAnchor).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.photoImageView.leftAnchor).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.photoImageView.rightAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.photoImageView.bottomAnchor).isActive = true
        
        self.scrollView.addSubview(loginButton)
        self.loginButton.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 24).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.scrollView.addSubview(view1)
        self.view1.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40).isActive = true
        self.view1.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        self.view1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.view1.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        self.scrollView.addSubview(view2)
        self.view2.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40).isActive = true
        self.view2.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 15).isActive = true
        self.view2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.view2.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        self.scrollView.addSubview(title1)
        self.title1.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 5).isActive = true
        self.title1.leftAnchor.constraint(equalTo: view1.leftAnchor).isActive = true
        self.title1.rightAnchor.constraint(equalTo: view1.rightAnchor).isActive = true
        self.title1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.scrollView.addSubview(title2)
        self.title2.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 5).isActive = true
        self.title2.leftAnchor.constraint(equalTo: view2.leftAnchor).isActive = true
        self.title2.rightAnchor.constraint(equalTo: view2.rightAnchor).isActive = true
        self.title2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.scrollView.bringSubviewToFront(photoImageView)
        self.scrollView.bringSubviewToFront(cameraImage)
        self.scrollView.bringSubviewToFront(cameraLabel)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Post.homeRemove {
            Post.homeRemove = false
            self.dismiss(animated: true, completion: nil)
        }
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func exitTapped() {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Your current post will not be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addPhoto() {
        presentPhotoPopup()
    }
    
    @objc func loginPressed() {
        if emailTextField.text != "" && photoImageView.image != nil {
            self.navigationController?.pushViewController(PostSecond(), animated: true)
            let controller = PostSecond()
            controller.image = self.photoImageView.image!
            controller.titleOfPost = self.emailTextField.text!
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Select a photo and fill out the title field", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func presentPhotoPopup() {
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
        emailTextField.resignFirstResponder()
        self.filterLauncher.showFilter()
        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.stopJobButton), for: .touchUpInside)
    }
    
    @objc func stopJobButton() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: filterLauncher.handleDismiss)
    }
    
    @objc func completeJobButton() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: filterLauncher.handleDismiss)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let cropped = info[.editedImage] as? UIImage {
            photoImageView.image = cropped
        } else if let original = info[.originalImage] as? UIImage {
            photoImageView.image = original
        }
        sendToBack()
        dismiss(animated: true, completion: nil)
    }
    
    func sendToBack() {
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.mainBlue
        self.scrollView.sendSubviewToBack(self.cameraLabel)
        self.scrollView.sendSubviewToBack(self.cameraImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: scrollView.contentSize.height - 650)
        scrollView.setContentOffset(point, animated: true)
    }

}
