//
//  ListingsCollectionViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/17/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import RxSwift

class ListingsCollectionViewController: UIViewController {
    var user:User? = nil {
        didSet {
            getProperties()
        }
    }
    private let disposeBag = DisposeBag()
    
    fileprivate let properties: Variable<[FLPPDPropertyViewModel]> = Variable([])
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(propertiesCollectionView)
        propertiesCollectionView.pinToSuperView()
        let collectionViewCellNib = UINib(nibName: "PropertyFeedCollectionViewCell", bundle: nil)
        propertiesCollectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: "PropertyCollectionViewCells")
        properties.asObservable().bind(to:propertiesCollectionView.rx.items(cellIdentifier: "PropertyCollectionViewCells"),curriedArgument: {row, property, cell in
            guard let cell = cell as? PropertyFeedCollectionViewCell else{
                return
            }
            cell.configureCell(property: property)
            
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(Notification.Name("newProperties")).subscribe(onNext:{[unowned self] Void in
            self.getProperties()
        }).disposed(by: disposeBag)
        propertiesCollectionView.rx.itemSelected.subscribe(onNext:{[unowned self](indexPath)->Void in
            let property = self.properties.value[indexPath.row]
            let propertyViewModel = PropertyViewModel(property: property.flppdProperty)
            let cell = self.propertiesCollectionView.cellForItem(at: indexPath) as! PropertyFeedCollectionViewCell
            let avatarImage = cell.avatarImageView.image ?? #imageLiteral(resourceName: "tabIconProfile")
            let portraitImage = cell.defaultImageView.image ?? #imageLiteral(resourceName: "loginBackground")
            //segue
            let controller = UIStoryboard(name: "PropertyFeed", bundle: nil)
                .instantiateViewController(withIdentifier: "PropertyDetailContainerViewController") as! PropertyDetailContainerViewController
            controller.avatarImage = avatarImage
            controller.portraitImage = portraitImage
            controller.propertyViewModel = propertyViewModel
            controller.navigationController?.isNavigationBarHidden = false
            controller.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(controller, animated: true)

        }).disposed(by: disposeBag)
    }
    //MARK: - call propertu network
    func getProperties(){
        self.properties.value.removeAll()
        guard let user = self.user else {
            return
        }
        guard let observable = getPropertiesObservable(user.user_id) else{
            return
        }
        observable.subscribe(onNext:{viewModel in
            self.properties.value.append(viewModel)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
