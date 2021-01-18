//
//  PropertyDetailContainerViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 8/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import KRProgressHUD

class PropertyDetailContainerViewController: UIViewController {
  
  var propertyViewModel: PropertyViewModel!
  var avatarImage: UIImage!
  var portraitImage: UIImage!
    var showStarred = true
  
  @IBOutlet private weak var propertyDetaiContainerView: UIView!{
    didSet{
      let viewController = storyboard!.instantiateViewController(withIdentifier: "PropertyDetailViewController") as! PropertyDetailViewController
      
      addViewControllerAsChildViewController(viewController, masterView: propertyDetaiContainerView)
      viewController.injectDependencies(property: propertyViewModel, avatar: avatarImage, portrait: portraitImage)
        viewController.starButton.isHidden = !showStarred
        self.navigationController?.hidesBarsOnSwipe = false
    }
  }
 
  
  @IBOutlet private weak var PriceBottomView: UIView!{
    didSet{
      let viewController = storyboard!.instantiateViewController(withIdentifier: "PriceBottomViewController") as! PriceBottomViewController
      
      addViewControllerAsChildViewController(viewController, masterView: PriceBottomView)
    }
  }
  
  //addview containerview
  private func addViewControllerAsChildViewController(_ childViewController: UIViewController, masterView: UIView){
    
    addChildViewController(childViewController)
    
    masterView.addSubview(childViewController.view)
    
    childViewController.view.frame = masterView.bounds
    
    childViewController.didMove(toParentViewController: self)
    
  }
  
}
