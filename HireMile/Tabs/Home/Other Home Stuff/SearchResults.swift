//
//  SearchResults.swift
//  HireMile
//
//  Created by JJ Zapata on 3/29/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SDWebImage

class SearchResults: UITableViewController {

    var keyword : String? {
        didSet {
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Results for '\(keyword!.lowercased().capitalized)'"
            searchDataWithTitle(keyword)
        }
    }

    var allJobs = [JobStructure]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CategoryCell.self, forCellReuseIdentifier: "reusableCellString")

        // Do any additional setup after loading the view.
    }

    private func searchDataWithTitle(_ keyword: String?) {
        if let keyword = keyword {
            print(keyword)
            Database.database().reference().child("Jobs").observe(DataEventType.childAdded) { (snapshot) in
                if let value = snapshot.value as? [String : Any] {
                    let job = JobStructure()
                    job.authorId = value["author"] as? String ?? "Error"
                    job.titleOfPost = value["title"] as? String ?? "Error"
                    job.descriptionOfPost = value["description"] as? String ?? "Error"
                    job.price = value["price"] as? Int ?? 0
                    job.category = value["category"] as? String ?? "Error"
                    job.imagePost = value["image"] as? String ?? "Error"
                    job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                    job.postId = value["postId"] as? String ?? "Error"
                    if let title = job.titleOfPost, let description = job.descriptionOfPost {
                        print(title)
                        print(description)
                        if title.lowercased().contains(keyword.lowercased()) || description.lowercased().contains(keyword.lowercased()) {
                            print("hey there")
                            self.allJobs.append(job)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allJobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCellString") as! CategoryCell
        cell.titleImageView.sd_setImage(with: URL(string: self.allJobs[indexPath.row].imagePost!), placeholderImage: nil, options: .retryFailed, completed: nil)
        cell.titleLabel.text = self.allJobs[indexPath.row].titleOfPost!
        cell.postId = self.allJobs[indexPath.row].postId!
        cell.desscription.text = self.allJobs[indexPath.row].descriptionOfPost!
        if self.allJobs[indexPath.row].typeOfPrice == "Hourly" {
            cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!) / Hour"
        } else {
            cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = CommonUtils.getStoryboardVC(StoryBoard.Home.rawValue, vcIdetifier: ViewPostVC.className) as? ViewPostVC {
            controller.hidesBottomBarWhenPushed = true
            let Jobs = self.allJobs[indexPath.row]
            controller.jobPost = Jobs
            controller.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
