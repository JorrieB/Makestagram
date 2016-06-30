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
    
    // 1
    let followingQuery = PFQuery(className: "Follow")
    followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
    
    // 2
    let postsFromFollowedUsers = Post.query()
    postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
    
    // 3
    let postsFromThisUser = Post.query()
    postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
    
    // 4
    let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
    // 5
    query.includeKey("user")
    // 6
    query.orderByDescending("createdAt")
    
    // 7
    query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
      // 8
      self.posts = result as? [Post] ?? []
      // 9
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
    // 2
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell")!
    
    cell.textLabel!.text = "Post"
    
    return cell
  }
}
