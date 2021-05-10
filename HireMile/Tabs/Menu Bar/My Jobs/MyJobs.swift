//
//  MyJobs.swift
//  HireMile
//
//  Created by JJ Zapata on 11/28/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ScrollableSegmentedControl

class MyJobs: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var running = [MyJobStructure]()
    var completed = [MyJobStructure]()
    var canceled = [MyJobStructure]()
    
    var allJobs = [MyJobStructure]()
    
    let segmentedControl : ScrollableSegmentedControl = {
        let segmentedControl = ScrollableSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Running", at: 0)
        segmentedControl.insertSegment(withTitle: "Completed", at: 1)
        segmentedControl.insertSegment(withTitle: "Canceled", at: 2)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.mainBlue
        segmentedControl.underlineSelected = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentContentColor = .blue
        segmentedControl.segmentContentColor = .purple
//        segmentedControl.fixedSegmentWidth = false
        return segmentedControl
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    let emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bubbleImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "not-service")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.mainBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let mainText : UILabel = {
        let label = UILabel()
        label.text = "No ratings yet"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let descText : UILabel = {
        let label = UILabel()
        label.text = "When people mark your jobs as complete, you find your reviews here!"
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(MyJobsRunningCell.self, forCellReuseIdentifier: "myJobsCellID")
        tableView.register(MyJobsCompletedgCell.self, forCellReuseIdentifier: "myJobsCompletedCellID")
        tableView.register(MyJobsCanceledCell.self, forCellReuseIdentifier: "myJobsCabcekkedCellID")
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Functions to throw
        self.basicSetup()
        
        // there should be a child reference in profile which has a collection of jobs. each job should have the following:
        // - uid of workers
        //     - name
        //     - profile image
        // - some sort of text (descruption, reason of cancel)
        // - job key
        //     - job cover image
        // - bool to see if rating is nil (if it is not nil, fetch the number)
        // - rating, if bool is false
        
        // add jobs to job collection
        // if job type == completed, if job type == running, if job type == canceled, add to certain array
        // tableview should return numberofrowsinsection per collection array
        
        self.allJobs.removeAll()
        self.running.removeAll()
        self.completed.removeAll()
        self.canceled.removeAll()
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let job = MyJobStructure()
                job.authorUid = value["author-uid"] as? String ?? "AUTHOR ID"
                job.reasonOrDescripiotn = value["reason-or-description"] as? String ?? "REASON FALSE"
                job.jobKey = value["job-key"] as? String ?? "JOB KEY FALSE"
                job.rating = value["rating"] as? Int ?? 0
                job.ratingIsNil = value["is-rating-nil"] as? Bool ?? true
                job.type = value["job-status"] as? String ?? "TYPE FALSE"
                job.idThingy = value["job-id-for-me"] as? String ?? "ID FALSE"
                switch job.type! {
                case "running":
                    job.runningStamp = value["running-time"] as? Int ?? 0
                    self.running.append(job)
                    print(job)
                case "completed":
                    job.completedStamp = value["complete-stamp"] as? Int ?? 0
                    self.completed.append(job)
                    print(job)
                case "cancelled":
                    job.cancelStamp = value["cancel-stamp"] as? Int ?? 0
                    self.canceled.append(job)
                    print(job)
                default:
                    print(job.type!)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "My Jobs"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 248/255, blue: 248/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "whiteback"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    @objc func segmentedControlValueChanged(_ semder: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            if self.running.count == 0 {
                self.view.addSubview(self.emptyView)
                self.emptyView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
                self.emptyView.leftAnchor.constraint(equalTo: self.tableView.leftAnchor).isActive = true
                self.emptyView.rightAnchor.constraint(equalTo: self.tableView.rightAnchor).isActive = true
                self.emptyView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true

                self.emptyView.addSubview(self.contentView)
                self.contentView.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor).isActive = true
                self.contentView.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor, constant: -50).isActive = true
                self.contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
                self.contentView.widthAnchor.constraint(equalToConstant: 250).isActive = true

                self.contentView.addSubview(bubbleImage)
                self.bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                self.bubbleImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.bubbleImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.bubbleImage.heightAnchor.constraint(equalToConstant: 100).isActive = true

                self.contentView.addSubview(mainText)
                self.mainText.topAnchor.constraint(equalTo: self.bubbleImage.bottomAnchor).isActive = true
                self.mainText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.mainText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.mainText.heightAnchor.constraint(equalToConstant: 45).isActive = true

                self.contentView.addSubview(descText)
                self.descText.topAnchor.constraint(equalTo: self.mainText.bottomAnchor, constant: -10).isActive = true
                self.descText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -20).isActive = true
                self.descText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 20).isActive = true
                self.descText.heightAnchor.constraint(equalToConstant: 75).isActive = true
                
                self.setInformation(withTitle: "No Jobs", withMessage: "You have no running jobs", imageNamed: "not-service")
            } else {
                self.emptyView.removeFromSuperview()
                self.tableView.backgroundColor = UIColor.white
            }
            return self.running.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if self.completed.count == 0 {
                self.tableView.backgroundColor = UIColor.clear
                self.view.addSubview(self.emptyView)
                self.emptyView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
                self.emptyView.leftAnchor.constraint(equalTo: self.tableView.leftAnchor).isActive = true
                self.emptyView.rightAnchor.constraint(equalTo: self.tableView.rightAnchor).isActive = true
                self.emptyView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true

                self.emptyView.addSubview(self.contentView)
                self.contentView.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor).isActive = true
                self.contentView.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor, constant: -50).isActive = true
                self.contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
                self.contentView.widthAnchor.constraint(equalToConstant: 250).isActive = true

                self.contentView.addSubview(bubbleImage)
                self.bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                self.bubbleImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.bubbleImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.bubbleImage.heightAnchor.constraint(equalToConstant: 100).isActive = true

                self.contentView.addSubview(mainText)
                self.mainText.topAnchor.constraint(equalTo: self.bubbleImage.bottomAnchor).isActive = true
                self.mainText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.mainText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.mainText.heightAnchor.constraint(equalToConstant: 45).isActive = true

                self.contentView.addSubview(descText)
                self.descText.topAnchor.constraint(equalTo: self.mainText.bottomAnchor, constant: -10).isActive = true
                self.descText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -20).isActive = true
                self.descText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 20).isActive = true
                self.descText.heightAnchor.constraint(equalToConstant: 75).isActive = true
                
                self.setInformation(withTitle: "No Jobs", withMessage: "You have no completed jobs", imageNamed: "not-service")
            } else {
                self.emptyView.removeFromSuperview()
                self.tableView.backgroundColor = UIColor.white
            }
            return self.completed.count
        } else if segmentedControl.selectedSegmentIndex == 2 {
            if self.canceled.count == 0 {
                self.tableView.backgroundColor = UIColor.clear
                self.view.addSubview(self.emptyView)
                self.emptyView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
                self.emptyView.leftAnchor.constraint(equalTo: self.tableView.leftAnchor).isActive = true
                self.emptyView.rightAnchor.constraint(equalTo: self.tableView.rightAnchor).isActive = true
                self.emptyView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true

                self.emptyView.addSubview(self.contentView)
                self.contentView.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor).isActive = true
                self.contentView.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor, constant: -50).isActive = true
                self.contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
                self.contentView.widthAnchor.constraint(equalToConstant: 250).isActive = true

                self.contentView.addSubview(bubbleImage)
                self.bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                self.bubbleImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.bubbleImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.bubbleImage.heightAnchor.constraint(equalToConstant: 100).isActive = true

                self.contentView.addSubview(mainText)
                self.mainText.topAnchor.constraint(equalTo: self.bubbleImage.bottomAnchor).isActive = true
                self.mainText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                self.mainText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.mainText.heightAnchor.constraint(equalToConstant: 45).isActive = true

                self.contentView.addSubview(descText)
                self.descText.topAnchor.constraint(equalTo: self.mainText.bottomAnchor, constant: -10).isActive = true
                self.descText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -20).isActive = true
                self.descText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 20).isActive = true
                self.descText.heightAnchor.constraint(equalToConstant: 75).isActive = true
                
                self.setInformation(withTitle: "No Jobs", withMessage: "You have no cancelled jobs", imageNamed: "not-service")
            } else {
                self.emptyView.removeFromSuperview()
                self.tableView.backgroundColor = UIColor.white
            }
            return self.canceled.count
        } else {
            return 0
        }
    }
    
    func setInformation(withTitle title: String, withMessage message: String, imageNamed named: String) {
        self.bubbleImage.image = UIImage(named: named)
        self.mainText.text = title
        self.descText.text = message
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            let alert = UIAlertController(title: "Ending Job?", message: "How are you going to end this job?", preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Cancel Job", style: .default, handler: { (action) in
//                // alert other user that job has been cancelled
//                // change the dict to cancelled, so it shows up in the cancelled the project.
//                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs").child(self.running[indexPath.row].idThingy!).child("job-status").setValue("canceled")
//                // reload stuff
//                self.viewWillAppear(true)
//            }))
//            alert.addAction(UIAlertAction(title: "Complete Job", style: .default, handler: { (action) in
//                // change the dict to completed
//                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs").child(self.running[indexPath.row].idThingy!).child("job-status").setValue("completed")
//                // reload stuff
//                self.viewWillAppear(true)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            print("nothing")
//        } else if segmentedControl.selectedSegmentIndex == 2 {
//            print("nothing")
//        } else {
//            print("shouldnt be printed :)")
//        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if let authorId = self.running[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(authorId).observe(.value) { (snapshot) in
                    if let profileUID : String = (snapshot.key as? String) {
                        GlobalVariables.userUID = profileUID
                        self.navigationController?.pushViewController(OtherProfile(), animated: true)
                    }
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let authorId = self.completed[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(authorId).observe(.value) { (snapshot) in
                    if let profileUID : String = (snapshot.key as? String) {
                        GlobalVariables.userUID = profileUID
                        
                        self.navigationController?.pushViewController(OtherProfile(), animated: true)
                    }
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            if let authorId = self.canceled[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(authorId).observe(.value) { (snapshot) in
                    if let profileUID : String = (snapshot.key as? String) {
                        GlobalVariables.userUID = profileUID
                        self.navigationController?.pushViewController(OtherProfile(), animated: true)
                    }
                }
            }
        } else {
            print("other")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
            // get author name and get author profile image from type authorId in MyJobStructure from database. Then update cell.
            
            if let timestamp = self.running[indexPath.row].runningStamp {
                if timestamp == 0 {
                    cell.date.isHidden = true
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    cell.date.text = "\(formatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
                    cell.date.isHidden = false
                }
            }
            
            if let uid = self.running[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.userNameLabel.text! = nameString
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        }
                    } else {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                    }
                }
            }
            
            if let jobKey = self.running[indexPath.row].jobKey {
                Database.database().reference().child("Jobs").child(jobKey).child("image").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.postImageView.loadImageUsingCacheWithUrlString(pictureString)
                    }
                }
                
                Database.database().reference().child("Jobs").child(jobKey).child("title").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.reviewLabel.text = "\(pictureString)"
                    } else {
                        cell.reviewLabel.text = "Deleted Job"
                    }
                }
            }
            
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCompletedCellID", for: indexPath) as! MyJobsCompletedgCell
            
            if let timestamp = self.completed[indexPath.row].completedStamp {
                if timestamp == 0 {
                    cell.date.isHidden = true
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    cell.date.text = "\(formatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
                    cell.date.isHidden = false
                }
            }
            
            if let uid = self.completed[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.userNameLabel.text! = nameString
                    } else {
                        cell.userNameLabel.text! = "Deleted User"
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        }
                    } else {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                    }
                }
            }
            
            
            if let rating = self.completed[indexPath.row].ratingIsNil {
                if rating == false {
                    if let finalRating = self.completed[indexPath.row].rating {
                        if finalRating == 100 {
                            cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        } else {
                            switch finalRating {
                            case 0:
                                cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            case 1:
                                cell.star1.tintColor = UIColor.mainBlue
                                cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            case 2:
                                cell.star1.tintColor = UIColor.mainBlue
                                cell.star2.tintColor = UIColor.mainBlue
                                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            case 3:
                                cell.star1.tintColor = UIColor.mainBlue
                                cell.star2.tintColor = UIColor.mainBlue
                                cell.star3.tintColor = UIColor.mainBlue
                                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            case 4:
                                cell.star1.tintColor = UIColor.mainBlue
                                cell.star2.tintColor = UIColor.mainBlue
                                cell.star3.tintColor = UIColor.mainBlue
                                cell.star4.tintColor = UIColor.mainBlue
                                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            case 5:
                                cell.star1.tintColor = UIColor.mainBlue
                                cell.star2.tintColor = UIColor.mainBlue
                                cell.star3.tintColor = UIColor.mainBlue
                                cell.star4.tintColor = UIColor.mainBlue
                                cell.star5.tintColor = UIColor.mainBlue
                            default:
                                print("hello")
                            }
                        }
                    }
                }
            }
            
            if let jobKey = self.completed[indexPath.row].jobKey {
                Database.database().reference().child("Jobs").child(jobKey).child("image").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.postImageView.loadImageUsingCacheWithUrlString(pictureString)
                    }
                }
            }
            
            if let description = self.completed[indexPath.row].reasonOrDescripiotn {
                cell.reviewLabel.text! = description
            } else {
                cell.reviewLabel.text! = "Deleted Post"
            }
            
            // get review notes
            
            cell.profileButton.addTarget(self, action: #selector(mapsHit), for: .touchUpInside)
            cell.profileButton.tag = indexPath.row
            cell.profileStyle = "running"
            
            cell.selectionStyle = .none
            return cell
        } else if segmentedControl.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCabcekkedCellID", for: indexPath) as! MyJobsCanceledCell
            
            if let timestamp = self.canceled[indexPath.row].cancelStamp {
                if timestamp == 0 {
                    cell.date.isHidden = true
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    cell.date.text = "\(formatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
                    cell.date.isHidden = false
                }
            }
            // get author name and get author profile image from type authorId in MyJobStructure from database. Then update cell.
            
            if let uid = self.canceled[indexPath.row].authorUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.userNameLabel.text! = nameString
                    } else {
                        cell.userNameLabel.text! = "Deleted User"
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
            
            if let jobKey = self.canceled[indexPath.row].jobKey {
                Database.database().reference().child("Jobs").child(jobKey).child("image").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.postImageView.loadImageUsingCacheWithUrlString(pictureString)
                    }
                }
                Database.database().reference().child("Jobs").child(jobKey).child("title").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.reviewLabel.text = "\(pictureString)"
                    } else {
                        cell.reviewLabel.text = "Deleted Post"
                    }
                }
            }
            
            cell.profileButton.addTarget(self, action: #selector(mapsHit), for: .touchUpInside)
            cell.profileButton.tag = indexPath.row
            cell.profileStyle = "completed"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
            
            Database.database().reference().child("Users").child(self.canceled[indexPath.row].authorUid!).child("name").observe(.value) { (snapshot) in
                let nameString : String = (snapshot.value as? String)!
                cell.userNameLabel.text! = nameString
            }
            
            Database.database().reference().child("Users").child(self.canceled[indexPath.row].authorUid!).child("profile-image").observe(.value) { (snapshot) in
                let profileImageString : String = (snapshot.value as? String)!
                if profileImageString == "not-yet-selected" {
                    cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    cell.profileImageView.tintColor = UIColor.lightGray
                    cell.profileImageView.contentMode = .scaleAspectFill
                } else {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                    cell.profileImageView.tintColor = UIColor.lightGray
                    cell.profileImageView.contentMode = .scaleAspectFill
                }
            }
            
            cell.profileButton.addTarget(self, action: #selector(mapsHit), for: .touchUpInside)
            cell.profileButton.tag = indexPath.row
            cell.profileStyle = "cancelled"
            
            cell.textLabel?.text = "Cell Running"
            return cell
        }
    }
    
    @objc func mapsHit(sender: UIButton) {
        let index = sender.tag
//        Database.database().reference().child("Users").child(self.messages[index].chatPartnerId()!).observe(.value) { (snapshot) in
//            let profileUID : String = (snapshot.key as? String)!
//            print(profileUID)
//            GlobalVariables.userUID = profileUID
//            self.navigationController?.pushViewController(OtherProfile(), animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 150
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 135
        } else if segmentedControl.selectedSegmentIndex == 2 {
            return 150
        } else {
            return 0
        }
    }
    
}

class MyJobsRunningCell: UITableViewCell {
    
    var profileStyle = "" 
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width,height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width:detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let date : UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title\n Price"
        label.numberOfLines = 3
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "working")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let priceDateLabel : UILabel = {
        let label = UILabel()
//        label.text = "24 Feb. 2018"
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(date)
        addSubview(userNameLabel)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        contentView.addSubview(profileButton)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        date.widthAnchor.constraint(equalToConstant: 100).isActive = true
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        date.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        date.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: date.leftAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        priceDateLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        priceDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceDateLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -5).isActive = true
        priceDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyJobsCompletedgCell: UITableViewCell {
    
    var profileStyle = ""
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let date : UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let star1 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star2 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star3 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star4 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star5 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
//        label.text = "He's a laborius worker, finished everytime, and recommend him to all"
        label.text = "Description"
        label.numberOfLines = 3
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let postImageView : CustomImageView = {
        let imageView = CustomImageView()
//        imageView.image = UIImage(named: "working")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let priceDateLabel : UILabel = {
        let label = UILabel()
//        label.text = "$30, 24 Feb. 2018"
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(date)
        addSubview(userNameLabel)
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        addSubview(star5)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        contentView.addSubview(profileButton)
        
        selectionStyle = .none
//
//        //ios 9 constraint anchors
//        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        date.widthAnchor.constraint(equalToConstant: 100).isActive = true
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        date.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        date.heightAnchor.constraint(equalToConstant: 30).isActive = true

        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: date.leftAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        star1.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star1.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 20).isActive = true

        star2.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star2.leftAnchor.constraint(equalTo: self.star1.rightAnchor, constant: 5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 20).isActive = true

        star3.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star3.leftAnchor.constraint(equalTo: self.star2.rightAnchor, constant: 5).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 20).isActive = true

        star4.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 20).isActive = true

        star5.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 20).isActive = true

        reviewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.star1.bottomAnchor, constant: 10).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true

        postImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

        priceDateLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        priceDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceDateLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -5).isActive = true
        priceDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
}

class MyJobsCanceledCell: UITableViewCell {
    
    var profileStyle = ""
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width,height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width:detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let date : UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title\nReasoning"
        label.numberOfLines = 3
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let priceDateLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(date)
        addSubview(userNameLabel)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        contentView.addSubview(profileButton)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        date.widthAnchor.constraint(equalToConstant: 100).isActive = true
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        date.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        date.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: date.leftAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        postImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        priceDateLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        priceDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceDateLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -5).isActive = true
        priceDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
