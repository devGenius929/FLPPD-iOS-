//
//  EvalMapViewController.swift
//  FLPPD
//
//  Created by PC on 5/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MapKit
class EvalMapViewController:UIViewController{
  let mapView = MKMapView()
  lazy var locationManager: CLLocationManager? = {()->CLLocationManager? in
    if (CLLocationManager.locationServicesEnabled())
    {
      let locationManager = CLLocationManager()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.delegate = self
      return locationManager
    }
    return nil
  }()
  private let disposeBag = DisposeBag()
  @IBOutlet weak var addressView: UIView!
  @IBOutlet weak var streetLabel: UILabel!
  @IBOutlet weak var cityStateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  private let currentLocationButton = UIBarButtonItem(image: UIImage(named:"currentLocation"), style:.plain, target: nil, action: nil)
  var property:Property!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let bundle = Bundle(for: type(of: self))
    UINib(nibName: "AddressView", bundle: bundle).instantiate(withOwner: self, options: nil)
    view.addSubview(mapView)
    mapView.pinToSuperView()
    mapView.showsUserLocation = true
    navigationItem.title = "Map"
    navigationItem.rightBarButtonItem = currentLocationButton
    view.addSubview(addressView)
    addressView.backgroundColor = UIColor.white
    addressView.layer.cornerRadius = 4
    addressView.setHeightConstraint(86, priority: UILayoutPriority(rawValue: 1000))
    addressView.setLeadingInSuperview(14, priority: UILayoutPriority(rawValue: 1000))
    addressView.setTrailingInSuperview(-14, priority: UILayoutPriority(rawValue: 1000))
    addressView.setBottomInSuperview(-14, priority: UILayoutPriority(rawValue: 1000))
    streetLabel.text = property.street!
    cityStateLabel.text = property.city!+", "+property.state!
    priceLabel.text = property.worksheet!.purchasePrice!.isGreaterThan(0) ? property.worksheet!.purchasePrice!.dollarFormat() : nil
    priceLabel.textColor = property.isKind(of: FlipProperty.self) ? UIColor.darkgreen : UIColor.darkerGold
    var address = property.street!
    address.append(" "+property.city!+" "+property.state!+" "+property.zipcode!)
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: {(placemarks,error) -> Void in
      if let placemark = placemarks?[0]{
        let mkPlaceMark = MKPlacemark(placemark: placemark)
        let region = MKCoordinateRegion(center: mkPlaceMark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
        self.mapView.setRegion(region, animated: true)
      }
    })
    self.mapView.delegate = self
    currentLocationButton.rx.tap.subscribe(onNext:{[unowned self] Void in
      guard let locationManager = self.locationManager else{
        return
      }
      if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
        locationManager.requestWhenInUseAuthorization()
        return
      }
      locationManager.startUpdatingLocation()
    }).disposed(by: disposeBag)
  }
  func showUserLocation(){
    guard let coordinate = self.mapView.userLocation.location?.coordinate else{
      return
    }
    mapView.setCenter(coordinate, animated: true)
  }
}
extension EvalMapViewController:MKMapViewDelegate,CLLocationManagerDelegate{
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation.isEqual(mapView.userLocation){
      return nil
    }
    let annotationView = EvalPropertyAnnotationView()
    annotationView.image = UIImage(named: "greenDot")
    annotationView.price = property.worksheet!.purchasePrice!.dollarFormat()
    annotationView.arv = property.worksheet!.afterRepairValue!.dollarFormat()
    return annotationView
  }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse{
      manager.startUpdatingLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.showUserLocation()
  }
}
