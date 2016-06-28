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
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBarController?.delegate = self
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