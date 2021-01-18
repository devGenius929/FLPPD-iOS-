//
//  PropertyFeedTableViewCell.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 3/3/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import AlamofireImage

class PropertyFeedTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerElementsView: UIView!
  @IBOutlet weak var defaultImageView: UIImageView!
  @IBOutlet weak var propertyTypeImageView: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var arvLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var datePubLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    containerElementsView.clipsToBounds = true
    containerElementsView.layer.cornerRadius = 5
    

    
    avatarImageView.image = avatarImageView.image?.af_imageRoundedIntoCircle()
    avatarImageView.layer.cornerRadius = 15.5
    avatarImageView.layer.borderWidth = 1.5
    avatarImageView.layer.borderColor = UIColor.white.cgColor
    avatarImageView.layer.masksToBounds = true
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
    
    func configureCell(property:FLPPDPropertyViewModel) {
        self.priceLabel.text = property.flppdProperty.price_currency ?? "$0.0"
        self.arvLabel.text = property.flppdProperty.property_type_id == 2 ? "ARV: \(property.flppdProperty.arv_currency ?? "$0.0")" : "RR: \(property.flppdProperty.arv_currency ?? "$0.0")"
        self.locationLabel.text = "\(property.flppdProperty.city ?? ""), \(property.flppdProperty.state ?? "0")"
        self.datePubLabel.text = "\(property.flppdProperty.created_at_in_words ?? " 0 sec") ago".uppercased()
        self.propertyTypeImageView.image = property.flppdProperty.property_type_id == 2 ? #imageLiteral(resourceName: "flipDealDot") : #imageLiteral(resourceName: "reantalDealDot")
        self.defaultImageView.af_setImage(withURL: property.defaultImageURL)
        self.avatarImageView.af_setImage(withURL: property.avatarURL)
    }
  
}
