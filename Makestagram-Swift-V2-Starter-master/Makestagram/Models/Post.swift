//
//  Post.swift
//  Makestagram
//
//  Created by Jottie Brerrin on 6/28/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

class Post : PFObject, PFSubclassing {
  
  @NSManaged var imageFile: PFFile?
  @NSManaged var user: PFUser?
  var image: UIImage?
  var photoUploadTask: UIBackgroundTaskIdentifier?

  
  //MARK: PFSubclassing Protocol
  
  static func parseClassName() -> String {
    return "Post"
  }
  
  override init () {
    super.init()
  }
  
  override class func initialize() {
    var onceToken : dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      // inform Parse about this subclass
      self.registerSubclass()
    }
  }
  
  func uploadPost() {
    if let image = image {
      guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
      guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
      
      self.imageFile = imageFile
      self.user = PFUser.currentUser()
      
      photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
      
      saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
    }
  }
  
}