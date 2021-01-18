//
//  StrechyHeaderView.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 4/12/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

class StrechyHeaderView: UIView{

  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage?{
    didSet{
      if let image = image{
        imageView.image = image
      }else{
        imageView.image = nil
      }
    }
  }
  
}
