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
        //convert the image into something usable by parse
        let convertedImage = UIImageJPEGRepresentation(image, 0.8)!
        let parseImage = PFFile(name: "image.jpg", data: convertedImage)
        
        let post = PFObject(className: "Post")
        post["user"] = PFUser.currentUser()
        post["imageFile"] = parseImage
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
          print("Post has been saved.")
        }
      }
    }

  }
}