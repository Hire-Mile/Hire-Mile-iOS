//
//  InfoPage.swift
//  HireMile
//
//  Created by JJ Zapata on 3/10/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import PhoneNumberKit

class InfoPage: UIViewController {
    
    var phoneNumber = 0
    
    var followingUsers = [UserStructure]()
    
    var firstSocialLink : String?
    
    var secondSocialLink : String?
    
    var user : UserStructure? {
        didSet {
            gatherInformation()
        }
    }
    
    var followers : Int? {
        didSet {
            firstMainInfoLabel.text = String(followers!)
        }
    }
    
    var rating : Int? {
        didSet {
            if rating == 0 {
                secondMainInfoLabel.text = String("None")
            } else {
                secondMainInfoLabel.text = String(rating!)
            }
        }
    }
    
    var hours : WorkingHoursStructure? {
        didSet {
            workMonday.text = hours!.monday
            workTuesday.text = hours!.tuesday
            workWednesday.text = hours!.wednesday
            workThursday.text = hours!.thursday
            workFriday.text = hours!.friday
            workSaturday.text = hours!.saturday
            workSunday.text = hours!.sunday
        }
    }
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let infoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 245/255, green: 250/255, blue: 251/255, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    let infoViewBorder1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 226/255, green: 231/255, blue: 231/255, alpha: 1)
        return view
    }()
    
    let infoViewBorder2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 226/255, green: 231/255, blue: 231/255, alpha: 1)
        return view
    }()
    
    let firstMainInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let secondMainInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let thirdMainInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let firstMainDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let secondMainDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let thirdMainDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let descriptionTtleLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 12
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let phoneNumberTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Contact"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let phoneImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let phoneLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let callButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CALL", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1).cgColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(callNumber), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let workingHoursTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Working Hours"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let monday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Monday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let tuesday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Tuesday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let wednesday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Wednesday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let thursday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Thursday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let friday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Friday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let saturday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Saturday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let sunday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Sunday"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        return label
    }()
    
    let workMonday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workTuesday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workWednesday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workThursday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workFriday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workSaturday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let workSunday : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        return label
    }()
    
    let socialMediaTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Social Media"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let firstSocialViewMain : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 13
        return view
    }()
    
    let firstSocialImageMain : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let firstSocialImageOpen : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let firstSocialTextMain : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let firstSocialButtonMain : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openFirstSocialLink), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    let secondSocialViewMain : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 13
        return view
    }()
    
    let secondSocialImageMain : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let secondSocialImageOpen : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let secondSocialTextMain : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let secondSocialButtonMain : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openSecondSocialLink), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    private func constraints(withDescription description: String) {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 850)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        infoView.addSubview(infoViewBorder1)
        infoViewBorder1.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        infoViewBorder1.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: (((view.bounds.size.width) - 48) / 3)).isActive = true
        infoViewBorder1.widthAnchor.constraint(equalToConstant: 1).isActive = true
        infoViewBorder1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoView.addSubview(infoViewBorder2)
        infoViewBorder2.centerYAnchor.constraint(equalTo: infoView.centerYAnchor).isActive = true
        infoViewBorder2.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -(((view.bounds.size.width) - 48) / 3)).isActive = true
        infoViewBorder2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        infoViewBorder2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        infoView.addSubview(firstMainInfoLabel)
        firstMainInfoLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        firstMainInfoLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor).isActive = true
        firstMainInfoLabel.rightAnchor.constraint(equalTo: infoViewBorder1.leftAnchor).isActive = true
        firstMainInfoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20).isActive = true
        
        infoView.addSubview(secondMainInfoLabel)
        secondMainInfoLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        secondMainInfoLabel.leftAnchor.constraint(equalTo: infoViewBorder1.rightAnchor).isActive = true
        secondMainInfoLabel.rightAnchor.constraint(equalTo: infoViewBorder2.leftAnchor).isActive = true
        secondMainInfoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20).isActive = true
        
        infoView.addSubview(thirdMainInfoLabel)
        thirdMainInfoLabel.topAnchor.constraint(equalTo: infoView.topAnchor).isActive = true
        thirdMainInfoLabel.leftAnchor.constraint(equalTo: infoViewBorder2.leftAnchor).isActive = true
        thirdMainInfoLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor).isActive = true
        thirdMainInfoLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20).isActive = true
        
        infoView.addSubview(firstMainDescLabel)
        firstMainDescLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 25).isActive = true
        firstMainDescLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor).isActive = true
        firstMainDescLabel.rightAnchor.constraint(equalTo: infoViewBorder1.leftAnchor).isActive = true
        firstMainDescLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        
        infoView.addSubview(secondMainDescLabel)
        secondMainDescLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 25).isActive = true
        secondMainDescLabel.leftAnchor.constraint(equalTo: infoViewBorder1.rightAnchor).isActive = true
        secondMainDescLabel.rightAnchor.constraint(equalTo: infoViewBorder2.leftAnchor).isActive = true
        secondMainDescLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        
        infoView.addSubview(thirdMainDescLabel)
        thirdMainDescLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 25).isActive = true
        thirdMainDescLabel.leftAnchor.constraint(equalTo: infoViewBorder2.leftAnchor).isActive = true
        thirdMainDescLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor).isActive = true
        thirdMainDescLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        
        scrollView.addSubview(descriptionTtleLabel)
        descriptionTtleLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 24).isActive = true
        descriptionTtleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        descriptionTtleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        descriptionTtleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(descriptionLabel)
        let description : String = description
        descriptionLabel.text = description
        descriptionLabel.topAnchor.constraint(equalTo: descriptionTtleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: estimateFrameForText(text: description).height + 15).isActive = true
        
        scrollView.addSubview(phoneNumberTitleLabel)
        phoneNumberTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24).isActive = true
        phoneNumberTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        phoneNumberTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        phoneNumberTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(phoneImageView)
        phoneImageView.topAnchor.constraint(equalTo: phoneNumberTitleLabel.bottomAnchor, constant: 15).isActive = true
        phoneImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        phoneImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        phoneImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        scrollView.addSubview(phoneLabel)
        phoneLabel.text = "No Phone Added"
        phoneLabel.topAnchor.constraint(equalTo: phoneNumberTitleLabel.bottomAnchor, constant: 15).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: phoneImageView.rightAnchor, constant: 12).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
//        scrollView.addSubview(callButton)
//        callButton.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor).isActive = true
//        callButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
//        callButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        callButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(workingHoursTitleLabel)
        workingHoursTitleLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 24).isActive = true
        workingHoursTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workingHoursTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workingHoursTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(monday)
        monday.topAnchor.constraint(equalTo: workingHoursTitleLabel.bottomAnchor, constant: 20).isActive = true
        monday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        monday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        monday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workMonday)
        workMonday.topAnchor.constraint(equalTo: workingHoursTitleLabel.bottomAnchor, constant: 20).isActive = true
        workMonday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workMonday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workMonday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(tuesday)
        tuesday.topAnchor.constraint(equalTo: monday.bottomAnchor, constant: 10).isActive = true
        tuesday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        tuesday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        tuesday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workTuesday)
        workTuesday.topAnchor.constraint(equalTo: monday.bottomAnchor, constant: 10).isActive = true
        workTuesday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workTuesday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workTuesday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(wednesday)
        wednesday.topAnchor.constraint(equalTo: tuesday.bottomAnchor, constant: 10).isActive = true
        wednesday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        wednesday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        wednesday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workWednesday)
        workWednesday.topAnchor.constraint(equalTo: tuesday.bottomAnchor, constant: 10).isActive = true
        workWednesday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workWednesday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workWednesday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(thursday)
        thursday.topAnchor.constraint(equalTo: wednesday.bottomAnchor, constant: 10).isActive = true
        thursday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        thursday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        thursday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workThursday)
        workThursday.topAnchor.constraint(equalTo: wednesday.bottomAnchor, constant: 10).isActive = true
        workThursday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workThursday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workThursday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(friday)
        friday.topAnchor.constraint(equalTo: thursday.bottomAnchor, constant: 10).isActive = true
        friday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        friday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        friday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workFriday)
        workFriday.topAnchor.constraint(equalTo: thursday.bottomAnchor, constant: 10).isActive = true
        workFriday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workFriday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workFriday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(saturday)
        saturday.topAnchor.constraint(equalTo: friday.bottomAnchor, constant: 10).isActive = true
        saturday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        saturday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        saturday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workSaturday)
        workSaturday.topAnchor.constraint(equalTo: friday.bottomAnchor, constant: 10).isActive = true
        workSaturday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workSaturday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workSaturday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(sunday)
        sunday.topAnchor.constraint(equalTo: saturday.bottomAnchor, constant: 10).isActive = true
        sunday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        sunday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        sunday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(workSunday)
        workSunday.topAnchor.constraint(equalTo: saturday.bottomAnchor, constant: 10).isActive = true
        workSunday.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        workSunday.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        workSunday.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(socialMediaTitleLabel)
        socialMediaTitleLabel.topAnchor.constraint(equalTo: sunday.bottomAnchor, constant: 24).isActive = true
        socialMediaTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        socialMediaTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        socialMediaTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        scrollView.addSubview(firstSocialViewMain)
        firstSocialViewMain.topAnchor.constraint(equalTo: socialMediaTitleLabel.bottomAnchor, constant: 20).isActive = true
        firstSocialViewMain.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        firstSocialViewMain.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        firstSocialViewMain.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        firstSocialViewMain.addSubview(firstSocialImageMain)
        firstSocialImageMain.centerYAnchor.constraint(equalTo: firstSocialViewMain.centerYAnchor).isActive = true
        firstSocialImageMain.leftAnchor.constraint(equalTo: firstSocialViewMain.leftAnchor, constant: 18).isActive = true
        firstSocialImageMain.widthAnchor.constraint(equalToConstant: 40).isActive = true
        firstSocialImageMain.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        firstSocialViewMain.addSubview(firstSocialImageOpen)
        firstSocialImageOpen.centerYAnchor.constraint(equalTo: firstSocialViewMain.centerYAnchor).isActive = true
        firstSocialImageOpen.rightAnchor.constraint(equalTo: firstSocialViewMain.rightAnchor, constant: -18).isActive = true
        firstSocialImageOpen.widthAnchor.constraint(equalToConstant: 30).isActive = true
        firstSocialImageOpen.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstSocialViewMain.addSubview(firstSocialTextMain)
        firstSocialTextMain.topAnchor.constraint(equalTo: firstSocialViewMain.topAnchor).isActive = true
        firstSocialTextMain.rightAnchor.constraint(equalTo: firstSocialImageOpen.leftAnchor, constant: -14).isActive = true
        firstSocialTextMain.leftAnchor.constraint(equalTo: firstSocialImageMain.rightAnchor, constant: 14).isActive = true
        firstSocialTextMain.bottomAnchor.constraint(equalTo: firstSocialViewMain.bottomAnchor).isActive = true
        
        firstSocialViewMain.addSubview(firstSocialButtonMain)
        firstSocialButtonMain.topAnchor.constraint(equalTo: firstSocialViewMain.topAnchor).isActive = true
        firstSocialButtonMain.rightAnchor.constraint(equalTo: firstSocialViewMain.rightAnchor).isActive = true
        firstSocialButtonMain.leftAnchor.constraint(equalTo: firstSocialViewMain.leftAnchor).isActive = true
        firstSocialButtonMain.bottomAnchor.constraint(equalTo: firstSocialViewMain.bottomAnchor).isActive = true
        
        scrollView.addSubview(secondSocialViewMain)
        secondSocialViewMain.topAnchor.constraint(equalTo: firstSocialViewMain.bottomAnchor, constant: 20).isActive = true
        secondSocialViewMain.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        secondSocialViewMain.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        secondSocialViewMain.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        secondSocialViewMain.addSubview(secondSocialImageMain)
        secondSocialImageMain.centerYAnchor.constraint(equalTo: secondSocialViewMain.centerYAnchor).isActive = true
        secondSocialImageMain.leftAnchor.constraint(equalTo: secondSocialViewMain.leftAnchor, constant: 18).isActive = true
        secondSocialImageMain.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secondSocialImageMain.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        secondSocialViewMain.addSubview(secondSocialImageOpen)
        secondSocialImageOpen.centerYAnchor.constraint(equalTo: secondSocialViewMain.centerYAnchor).isActive = true
        secondSocialImageOpen.rightAnchor.constraint(equalTo: secondSocialViewMain.rightAnchor, constant: -18).isActive = true
        secondSocialImageOpen.widthAnchor.constraint(equalToConstant: 30).isActive = true
        secondSocialImageOpen.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        secondSocialViewMain.addSubview(secondSocialTextMain)
        secondSocialTextMain.topAnchor.constraint(equalTo: secondSocialViewMain.topAnchor).isActive = true
        secondSocialTextMain.rightAnchor.constraint(equalTo: secondSocialImageOpen.leftAnchor, constant: -14).isActive = true
        secondSocialTextMain.leftAnchor.constraint(equalTo: secondSocialImageMain.rightAnchor, constant: 14).isActive = true
        secondSocialTextMain.bottomAnchor.constraint(equalTo: secondSocialViewMain.bottomAnchor).isActive = true
        
        secondSocialViewMain.addSubview(secondSocialButtonMain)
        secondSocialButtonMain.topAnchor.constraint(equalTo: secondSocialViewMain.topAnchor).isActive = true
        secondSocialButtonMain.rightAnchor.constraint(equalTo: secondSocialViewMain.rightAnchor).isActive = true
        secondSocialButtonMain.leftAnchor.constraint(equalTo: secondSocialViewMain.leftAnchor).isActive = true
        secondSocialButtonMain.bottomAnchor.constraint(equalTo: secondSocialViewMain.bottomAnchor).isActive = true
    }
    
    func gatherInformation() {
        if let uid = user?.uid {
            print("uid: " + uid)
            findFollowing(withUid: uid)
            findDescription(withUid: uid)
            findPhoneNumber(withUid: uid)
            findWorkHours(withUid: uid)
            findSocialAccounts(withUid: uid)
        }
    }
    
    @objc func openFirstSocialLink() {
        if let firstSocialLink = self.firstSocialLink {
            if let url = URL(string: firstSocialLink) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Cannot open link. Invalid input", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Cannot open link. Invalid input", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func openSecondSocialLink() {
        if let secondSocialLink = self.secondSocialLink {
            if let url = URL(string: secondSocialLink) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Cannot open link. Invalid input", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Cannot open link. Invalid input", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func callNumber() {
        if let url = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Cannot call number. Invalid input", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Cannot call number. Invalid input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func findSocialAccounts(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("social").child("instagram").observe(.value) { (instagramSnap) in
            if let instagram = instagramSnap.value as? String {
                self.firstSocialTextMain.text = "Instagram\n\(instagram)"
                self.firstSocialImageMain.image = UIImage(named: "instagram")
                self.firstSocialLink = "https://www.instagram.com/\(instagram)/"
                Database.database().reference().child("Users").child(uid).child("social").child("facebook").observe(.value) { (facebookSnap) in
                    if let facebook = facebookSnap.value as? String {
                        self.secondSocialTextMain.text = "Facebook\n\(facebook)"
                        self.secondSocialImageMain.image = UIImage(named: "face")
                        self.secondSocialLink = "https://www.facebook.com"
                    } else {
                        self.secondSocialViewMain.alpha = 0
                    }
                }
            } else {
                self.secondSocialViewMain.alpha = 0
                Database.database().reference().child("Users").child(uid).child("social").child("facebook").observe(.value) { (facebookSnap) in
                    if let facebook = facebookSnap.value as? String {
                        self.firstSocialTextMain.text = "Facebook\n\(facebook)"
                        self.firstSocialImageMain.image = UIImage(named: "face")
                        self.firstSocialLink = "https://www.facebook.com"
                    } else {
                        self.firstSocialViewMain.alpha = 0
                        self.socialMediaTitleLabel.alpha = 0
                    }
                }
            }
        }
    }
    
    private func findWorkHours(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("work-hours").observe(.value) { (descriptionSnap) in
            if let value = descriptionSnap.value as? [String : Any] {
                let hours = WorkingHoursStructure()
                hours.monday = value["monday"] as? String ?? "Not Set"
                hours.tuesday = value["tuesday"] as? String ?? "Not Set"
                hours.wednesday = value["wednesday"] as? String ?? "Not Set"
                hours.thursday = value["thursday"] as? String ?? "Not Set"
                hours.friday = value["friday"] as? String ?? "Not Set"
                hours.saturday = value["saturday"] as? String ?? "Not Set"
                hours.sunday = value["sunday"] as? String ?? "Not Set"
                self.hours = hours
            } else {
                let hours = WorkingHoursStructure()
                hours.monday = "Not Set"
                hours.tuesday = "Not Set"
                hours.wednesday = "Not Set"
                hours.thursday = "Not Set"
                hours.friday = "Not Set"
                hours.saturday = "Not Set"
                hours.sunday = "Not Set"
                self.hours = hours
            }
        }
    }
    
    private func findPhoneNumber(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("phonenumber").observe(.value) { (descriptionSnap) in
            if let value = descriptionSnap.value as? String {
                let phoneNumberKit = PhoneNumberKit()
                do {
                    let phoneNumber = try phoneNumberKit.parse(value)
                    self.phoneLabel.text = phoneNumberKit.format(phoneNumber, toType: PhoneNumberFormat.international)
                } catch {
                    print("error parsing")
                }
            } else {
                print("no number")
            }
        }
    }
    
    private func findDescription(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("description").observe(.value) { (descriptionSnap) in
            if let value = descriptionSnap.value as? String {
                self.constraints(withDescription: value)
            } else {
                self.constraints(withDescription: "This user has not set a description yet! Be sure to check back soon!")
            }
        }
    }
    
    private func findFollowing(withUid uid: String) {
        print("dind")
        Database.database().reference().child("Users").child(uid).child("favorites").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "error"
                if user.uid != "error" {
                    self.followingUsers.append(user)
                }
            }
            self.thirdMainInfoLabel.text = String(self.followingUsers.count)
        }
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: view.bounds.size.width - 48, height: CGFloat())
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
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
