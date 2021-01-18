///
//  ViewController.swift
//  FLPPD
//
//  Created by Anibal Rodriguez on 1/19/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

struct PropertyAnnotationData{
    let coordinate:CLLocationCoordinate2D
    let index:Int
}

class ExploreViewController: UIViewController {
    
    //MARK: Properties
    var filters = PropertyFilters()
    private let refreshControl = UIRefreshControl()
    fileprivate let properties: Variable<[FLPPDPropertyViewModel]> = Variable([])
    private let propertiesTableView = UITableView()
    fileprivate lazy var propertiesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.bounds.width - 28, height: 130)
        layout.minimumLineSpacing = 28
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    private let exploreFlipControl = UISegmentedControl(items:["List","Map"])
    private let mapView = MKMapView()
    fileprivate var annotationData:[PropertyAnnotationData] = []
    private let disposeBag = DisposeBag()
    private let newPropertyButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: nil)
    private let filtersButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon_filter"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    private let leftArrow = UIButton(type: .custom)
    private let rightArrow = UIButton(type:.custom)
    //MARK:- view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = newPropertyButton
        newPropertyButton.rx.tap.subscribe(onNext:{[unowned self] Void in
            let vc = NewListingViewController()
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = filtersButton
        filtersButton.rx.tap.subscribe(onNext: {
            let vc = UIStoryboard(name: "PropertyFeed", bundle: nil).instantiateViewController(withIdentifier: "FilterProperty") as! FilterPropertiesViewController
            self.show(vc, sender: self)
            vc.filters = self.filters
            vc.updateFileds()
            vc.completion = { (filters) in
                if let filters = filters{
                    self.filters = filters
                    self.getProperties()
                }
            }
        }).disposed(by: disposeBag)
        leftArrow.setImage(#imageLiteral(resourceName: "decrement"), for: .normal)
        rightArrow.setImage(#imageLiteral(resourceName: "increment"), for: .normal)
        refreshControl.tintColor = UIColor.darkerGold
        propertiesTableView.addSubview(refreshControl)
        view.addSubview(propertiesTableView)
        view.addSubview(mapView)
        view.addSubview(propertiesCollectionView)
        view.addSubview(leftArrow)
        view.addSubview(rightArrow)
        propertiesCollectionView.showsVerticalScrollIndicator = true
        propertiesTableView.pinToSuperView()
        propertiesCollectionView.setBottomInSuperview(-14, priority: UILayoutPriority(rawValue: 999))
        propertiesCollectionView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
        propertiesCollectionView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
        propertiesCollectionView.setHeightConstraint(130, priority: UILayoutPriority(rawValue: 999))
        mapView.pinToSuperView()
        leftArrow.sizeToFit()
        rightArrow.sizeToFit()
        leftArrow.setLeadingInSuperview(25, priority: UILayoutPriority(rawValue: 999))
        leftArrow.centerVertically(inView: propertiesCollectionView)
        rightArrow.setTrailingInSuperview(-25, priority: UILayoutPriority(rawValue: 999))
        rightArrow.centerVertically(inView: propertiesCollectionView)
        exploreFlipControl.tintColor = UIColor.darkerGold
        exploreFlipControl.selectedSegmentIndex = 0
        self.navigationController?.navigationBar.topItem?.titleView = exploreFlipControl
        let tableViewCellNib = UINib(nibName: "PropertyFeedTableViewCell", bundle: nil)
        let collectionViewCellNib = UINib(nibName: "PropertyFeedCollectionViewCell", bundle: nil)
        propertiesTableView.register(tableViewCellNib, forCellReuseIdentifier: "PropertyCells")
        propertiesCollectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: "PropertyCollectionViewCells")
        Helper.navigationWithGray((navigationController?.navigationBar)!)
        properties.asObservable().bind(to:propertiesTableView.rx.items(cellIdentifier: "PropertyCells",cellType:PropertyFeedTableViewCell.self),curriedArgument: {row, property, cell in
            cell.configureCell(property: property)
        }).disposed(by: disposeBag)
        
        properties.asObservable().bind(to:propertiesCollectionView.rx.items(cellIdentifier: "PropertyCollectionViewCells"),curriedArgument: {row, property, cell in
            guard let cell = cell as? PropertyFeedCollectionViewCell else{
                return
            }
            cell.configureCell(property: property)
        }).disposed(by: disposeBag)
        
        propertiesTableView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
            let property = self.properties.value[indexPath.row]
            let propertyViewModel = PropertyViewModel(property: property.flppdProperty)
            let cell = self.propertiesTableView.cellForRow(at: indexPath) as! PropertyFeedTableViewCell
            let avatarImage = cell.avatarImageView.image ?? #imageLiteral(resourceName: "tabIconProfile")
            let portraitImage = cell.defaultImageView.image ?? #imageLiteral(resourceName: "loginBackground")
            //segue
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PropertyDetailContainerViewController") as! PropertyDetailContainerViewController
            controller.avatarImage = avatarImage
            controller.portraitImage = portraitImage
            controller.propertyViewModel = propertyViewModel
            controller.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        
        propertiesCollectionView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
            let property = self.properties.value[indexPath.row]
            let propertyViewModel = PropertyViewModel(property: property.flppdProperty)
            let cell = self.propertiesTableView.cellForRow(at: indexPath) as! PropertyFeedTableViewCell
            let avatarImage = cell.avatarImageView.image ?? #imageLiteral(resourceName: "tabIconProfile")
            let portraitImage = cell.defaultImageView.image ?? #imageLiteral(resourceName: "loginBackground")
            //segue
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "PropertyDetailContainerViewController") as! PropertyDetailContainerViewController
            controller.avatarImage = avatarImage
            controller.portraitImage = portraitImage
            controller.propertyViewModel = propertyViewModel
            controller.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        
        propertiesCollectionView.rx.didScroll.subscribe(onNext:{[unowned self] Void in
            guard let indexPath = self.propertiesCollectionView.indexPathsForVisibleItems.first,let index = self.annotationData.index(where: { (annotation) -> Bool in
                return annotation.index == indexPath.row
            }) else{
                return
            }
            let region = MKCoordinateRegion(center: self.annotationData[index].coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
            self.leftArrow.isHidden = index == 0
            self.rightArrow.isHidden = index > self.properties.value.count-1
            
        }).disposed(by: disposeBag)
        exploreFlipControl.rx.selectedSegmentIndex.subscribe(onNext:{[unowned self](index)->Void in
            if index == 0 {
                self.exploreFlipControl.selectedSegmentIndex = 0
                self.propertiesTableView.isHidden = false
                self.propertiesCollectionView.isHidden = true
                self.mapView.isHidden = true
                self.leftArrow.isHidden = true
                self.rightArrow.isHidden = true
            }else{
                self.exploreFlipControl.selectedSegmentIndex = 1
                self.propertiesTableView.isHidden = true
                self.propertiesCollectionView.isHidden = false
                self.mapView.isHidden = false
                guard let indexPath = self.propertiesCollectionView.indexPathsForVisibleItems.first,let index = self.annotationData.index(where: { (annotation) -> Bool in
                    return annotation.index == indexPath.row
                }) else{
                    return
                }
                self.leftArrow.isHidden = index == 0
                self.rightArrow.isHidden = index > self.properties.value.count-1

            }
        }).disposed(by: disposeBag)
        
        properties.asObservable().subscribe(onNext:{[unowned self](properties)->Void in
            self.annotationData.removeAll()
            for (index,property) in properties.enumerated(){
                if let street = property.flppdProperty.street,let city = property.flppdProperty.city,let state = property.flppdProperty.state,let zipCode = property.flppdProperty.zip_code{
                    let address = street + " " + city + " " + state + " " + String(zipCode)
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address, completionHandler: {(placemarks,error) -> Void in
                        if let placemark = placemarks?[0]{
                            let mkPlaceMark = MKPlacemark(placemark: placemark)
                            let region = MKCoordinateRegion(center: mkPlaceMark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                            let data = PropertyAnnotationData(coordinate: mkPlaceMark.coordinate, index: index)
                            self.annotationData.append(data)
                            self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                            if index == 0 {
                                self.mapView.setRegion(region, animated: true)
                            }
                        }
                    })
                }
            }
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
            DispatchQueue.main.async(execute: {[unowned self]()->Void in
                self.getProperties()
                self.refreshControl.endRefreshing()
            })
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("newProperties")).subscribe(onNext:{[unowned self] Void in
            self.getProperties()
        }).disposed(by: disposeBag)
        mapView.delegate = self
        propertiesTableView.separatorStyle = .none
        propertiesTableView.tableFooterView = UIView()
        propertiesTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        propertiesTableView.rowHeight = 130
        getProperties()
        mapView.bringSubview(toFront: self.leftArrow)
        mapView.bringSubview(toFront: self.rightArrow)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.bringSubview(toFront: self.leftArrow)
        mapView.bringSubview(toFront: self.rightArrow)
    }
    //MARK: - call propertu network
    func getProperties(){
        self.leftArrow.isHidden = true
        self.rightArrow.isHidden = true
        self.properties.value.removeAll()
        guard let observable = getPropertiesObservable(nil, filters.getFilterString()) else{
            return
        }
        observable.subscribe(onNext:{viewModel in
            self.properties.value.append(viewModel)
            DispatchQueue.main.async {
                if self.exploreFlipControl.selectedSegmentIndex == 0 {
                    self.rightArrow.isHidden = true
                }
                else {
                    self.rightArrow.isHidden = false
                }
            }
            
        }).disposed(by: disposeBag)
    }
}

extension ExploreViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //self.propertiesCollectionView.isHidden = true
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let index = self.annotationData.index(where: { (data) -> Bool in
            return data.coordinate.latitude == view.annotation?.coordinate.latitude && data.coordinate.longitude == view.annotation?.coordinate.longitude ? true : false
        }) else{
            return
        }
        self.propertiesCollectionView.isHidden = false
        self.propertiesCollectionView.scrollToItem(at: IndexPath(row: self.annotationData[index].index, section: 0), at: .centeredHorizontally, animated: false)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation){
            return nil
        }
        guard let index = self.annotationData.index(where: { (data) -> Bool in
            return data.coordinate.latitude == annotation.coordinate.latitude && data.coordinate.longitude == annotation.coordinate.longitude ? true : false
        }) else{
            return nil
        }
        let property = self.properties.value[self.annotationData[index].index]
        let annotationView = ExplorePropertyAnnotationView()
        annotationView.image = property.flppdProperty.property_type_id == 2 ? #imageLiteral(resourceName: "greenDot") : #imageLiteral(resourceName: "purpleDot")
        annotationView.detailBackgroundColor = property.flppdProperty.property_type_id == 2 ? UIColor.darkgreen : UIColor.darkpurple
        if let price = property.flppdProperty.price{
            annotationView.price = price.dollarFormat()
        }
        
        if let arv = property.flppdProperty.arv{
            annotationView.arv = arv.dollarFormat()
        }
        return annotationView
    }
}
