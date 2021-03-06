//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Jottie Brerrin on 6/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
  
  var photoTakingHelper: PhotoTakingHelper?
  @IBOutlet weak var tableView: UITableView!
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBarController?.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    ParseHelper.timelineRequestForCurrentUser {
      (result: [PFObject]?, error: NSError?) -> Void in
      self.posts = result as? [Post] ?? []
      
      for post in self.posts {
        do {
          let data = try post.imageFile?.getData()
          post.image = UIImage(data: data!, scale:1.0)
        } catch {
          print("could not get image")
        }
      }
      self.tableView.reloadData()
    }
    
  }
  
}

//MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
  func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

    if (viewController is PhotoViewController) {
      takePhoto()
      return false
    }
    return true
  }
  
  func takePhoto(){
    // instantiate photo taking class, provide callback for when photo is selected
    photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
      if let image = image{
        let post = Post()
        post.image = image
        post.uploadPost()
      }
    }

  }
}

extension TimelineViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 1
    return posts.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // 1
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
    
    // 2
    cell.postImageView.image = posts[indexPath.row].image
    
    return cell
    
  }
}
