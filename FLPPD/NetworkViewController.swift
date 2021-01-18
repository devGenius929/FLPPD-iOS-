//
//  NetworkViewController.swift
//  FLPPD
//
//  Created by PC on 9/26/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
struct SectionOfContactsData {
  var header: String
  var items: [Item]
}
extension SectionOfContactsData: SectionModelType {
  typealias Item = Contact
  
  init(original: SectionOfContactsData, items: [Item]) {
    self = original
    self.items = items
  }
}
class NetworkViewController:UIViewController{
    private var contactsDataSource =  RxCollectionViewSectionedReloadDataSource<SectionOfContactsData>(configureCell: {(_,_,_,_) in return UICollectionViewCell()})
    
  private let disposeBag = DisposeBag()
  private let searchBar = UISearchBar()
  private lazy var contactsCollectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.clear
    return collectionView
  }()
  private let searchTableView = UITableView()
  private let activityIndicator = UIActivityIndicatorView()
  private let searchStatusLabel = UILabel()
  private let searchContactCellViewModels:Variable<[Contact]> = Variable([])
  fileprivate let contactCellViewModels:Variable<[SectionOfContactsData]> = Variable([SectionOfContactsData(header: "Contact Request", items: []),SectionOfContactsData(header: "Contact List", items: [])])
  private let refreshControl = UIRefreshControl()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    getPendingFriendRequests()
    getContacts()
    setupSearch()
  }
  private func setupSearchBar(){
    view.addSubview(searchBar)
    searchBar.barStyle = .black
    searchBar.searchBarStyle = .minimal
    searchBar.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    searchBar.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    searchBar.setTopInSuperview(0, priority: UILayoutPriority(rawValue: 1000))
    searchBar.setHeightConstraint(44, priority: UILayoutPriority(rawValue: 1000))
    searchBar.rx.cancelButtonClicked.subscribe(onNext:{[unowned self] Void in
      self.searchContactCellViewModels.value.removeAll()
      self.activityIndicator.isHidden = true
      self.searchBar.text = nil
      self.searchTableView.isHidden = true
      self.contactsCollectionView.isHidden = false
      self.searchBar.setShowsCancelButton(false, animated: true)
      self.searchBar.resignFirstResponder()
    }).disposed(by: disposeBag)
    searchBar.rx.textDidBeginEditing.subscribe(onNext:{[unowned self] Void in
      self.searchTableView.isHidden = false
      self.contactsCollectionView.isHidden = true
      self.searchBar.showsCancelButton = true
    }).disposed(by: disposeBag)
  }
  private func setupSearchTableView(){
    view.addSubview(searchTableView)
    searchTableView.register(ContactCell.self, forCellReuseIdentifier: "searchCell")
    searchTableView.rowHeight = 82
    searchTableView.isHidden = true
    searchStatusLabel.textAlignment = .center
    searchStatusLabel.text = "Nothing found"
    searchStatusLabel.backgroundColor = UIColor.clear
    searchStatusLabel.frame = .zero
    searchTableView.tableFooterView = searchStatusLabel
    searchTableView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    searchTableView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    searchTableView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    searchTableView.setTopInSuperview(44, priority: UILayoutPriority(rawValue: 999))
    searchContactCellViewModels.asObservable().bind(to: searchTableView.rx.items(cellIdentifier: "searchCell",cellType:ContactCell.self),curriedArgument: {[unowned self] row, element, cell in
      cell.nameLabel.text = element.name
      cell.avatarView.image = element.avatar
        let tap = UITapGestureRecognizer()
        cell.avatarView.gestureRecognizers = [tap]
        tap.rx.event.bind(onNext: { (gr) in
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            vc.loadUserWithId(element.user.user_id)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: self.disposeBag)
        cell.avatarView.isUserInteractionEnabled = true
      if let contactIndex = self.contactCellViewModels.value[1].items.index(where:{ (contact) -> Bool in
        return contact.userId == element.userId
      }){
        if self.contactCellViewModels.value[1].items[contactIndex].isPendingRequest{
          self.setAsPending(cell, element: element)
        }else{
          cell.setAsConnected()
          cell.connectionButtion.rx.tap.subscribe(onNext:{Void in
            let confirmUnfriend = UIAlertController(title: "Remove from contact list", message: "Are you sure you want to remove this person from your contact list?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {Void in
              createUnfriendObservable(element.userId).subscribe(onNext:{[unowned self](response)->Void in
                if response.0.statusCode == 200{
                  self.getContacts()
                }
              }).disposed(by: cell.disposeBag)
            })
            confirmUnfriend.addAction(no)
            confirmUnfriend.addAction(yes)
            self.present(confirmUnfriend, animated: true, completion: nil)
          }).disposed(by: cell.disposeBag)
        }
      }else{
        self.setAsNotConnected(cell, element: element)
      }
    }).disposed(by: disposeBag)
    let dismissKeyBoard = UITapGestureRecognizer()
    dismissKeyBoard.cancelsTouchesInView = false
    searchTableView.addGestureRecognizer(dismissKeyBoard)
    dismissKeyBoard.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
      self.searchBar.resignFirstResponder()
    }).disposed(by: disposeBag)
  }
  private func setAsPending(_ cell:ContactCell,element:Contact){
    DispatchQueue.main.async(execute: {
      cell.setAsPending()
    })
    cell.connectionButtion.rx.tap.flatMap({()->Observable<(response: HTTPURLResponse, data: Data)> in
      return createRejectFriendRequestObservable(element.userId)
    }).subscribe(onNext:{[unowned self](response)->Void in
      if response.0.statusCode == 200{
        self.getContacts()
        self.setAsNotConnected(cell, element: element)
      }
    }).disposed(by: cell.disposeBag)
  }
  private func setAsNotConnected(_ cell:ContactCell,element:Contact){
    if element.userId == UserDefaults.standard.integer(forKey: "user_id"){
      cell.connectionButtion.isHidden = true
    }else{
      DispatchQueue.main.async(execute: {
        cell.setAsConnect()
      })
      
      cell.connectionButtion.rx.tap.flatMap({()->Observable<(response: HTTPURLResponse, data: Data)> in
        if self.contactCellViewModels.value[0].items.contains(where: { (contact) -> Bool in
          return contact.userId == element.userId
        }){
          return createAcceptFriendRequestObservable(element.userId)
        }else{
          return createAddFriendObservable(element.userId)
        }
      }).subscribe(onNext:{[unowned self] response in
        if response.0.statusCode == 200{
          DispatchQueue.main.async(execute: {
            cell.setAsPending()
            self.getPendingFriendRequests()
            self.getContacts()
            cell.disposeBag = DisposeBag()
            self.setAsPending(cell, element: element)
          })
        }
      }).disposed(by: cell.disposeBag)
    }
  }
  private func setupContactsCollectionView(){
    view.addSubview(contactsCollectionView)
    contactsCollectionView.alwaysBounceVertical = true
    contactsCollectionView.addSubview(refreshControl)
    refreshControl.tintColor = UIColor.darkerGold
    contactsCollectionView.backgroundColor = UIColor.groupTableViewBackground
    contactsCollectionView.setLeadingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    contactsCollectionView.setBottomInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    contactsCollectionView.setTrailingInSuperview(0, priority: UILayoutPriority(rawValue: 999))
    contactsCollectionView.setTopInSuperview(44, priority: UILayoutPriority(rawValue: 999))
    contactsCollectionView.delegate = self
    contactsCollectionView.register(PendingContactCollectionViewCell.self, forCellWithReuseIdentifier: "PendingRequestCell")
    contactsCollectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: "ContactCell")
    
    contactsDataSource.configureCell = {[unowned self](datasource,collectionView,indexPath,contact)->UICollectionViewCell in
      if indexPath.section == 0{
        let cell = self.contactsCollectionView.dequeueReusableCell(withReuseIdentifier: "PendingRequestCell", for: indexPath) as! PendingContactCollectionViewCell
        cell.nameLabel.text = contact.name
        cell.avatarView.image = contact.avatar
        let tap = UITapGestureRecognizer()
        cell.avatarView.gestureRecognizers = [tap]
        tap.rx.event.bind(onNext: { (gr) in
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            vc.loadUserWithId(contact.userId)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: self.disposeBag)
        cell.avatarView.isUserInteractionEnabled = true
        cell.acceptButton.rx.tap.flatMap({()->Observable<(response: HTTPURLResponse, data: Data)> in
          return createAcceptFriendRequestObservable(contact.userId)
        }).subscribe(onNext:{response in
          if response.0.statusCode == 200{
            self.getPendingFriendRequests()
            self.getContacts()
          }
        }).disposed(by: cell.disposeBag)
        cell.rejectButton.rx.tap.flatMap({()->Observable<(response: HTTPURLResponse, data: Data)> in
          return createRejectFriendRequestObservable(contact.userId)
        }).subscribe(onNext:{response in
          if response.0.statusCode == 200 || response.0.statusCode == 404{
            self.getPendingFriendRequests()
            self.getContacts()
          }
        }).disposed(by: cell.disposeBag)
        return cell
      }else{
        let cell = self.contactsCollectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCollectionViewCell
        cell.nameLabel.text = contact.name
        cell.avatarView.image = contact.avatar
        let tap = UITapGestureRecognizer()
        cell.avatarView.gestureRecognizers = [tap]
        tap.rx.event.bind(onNext: { (gr) in
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            vc.loadUserWithId(contact.user.user_id)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: self.disposeBag)
        cell.avatarView.isUserInteractionEnabled = true
        cell.separatorView.isHidden = indexPath.row == 0 
        if contact.isPendingRequest{
          cell.setAsPending()
          cell.connectionButtion.rx.tap.flatMap({()->Observable<(response: HTTPURLResponse, data: Data)> in
            return createRejectFriendRequestObservable(contact.userId)
          }).subscribe(onNext:{[unowned self](response)->Void in
            if response.0.statusCode == 200{
              self.getContacts()
            }
          }).disposed(by: cell.disposeBag)
        }else{
          cell.setAsConnected()
          cell.connectionButtion.rx.tap.subscribe(onNext:{Void in
            let confirmUnfriend = UIAlertController(title: "Remove from contact list", message: "Are you sure you want to remove this person from your contact list?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {Void in
              createUnfriendObservable(contact.userId).subscribe(onNext:{[unowned self](response)->Void in
                if response.0.statusCode == 200{
                  self.getContacts()
                }
              }).disposed(by: cell.disposeBag)
            })
            confirmUnfriend.addAction(no)
            confirmUnfriend.addAction(yes)
            self.present(confirmUnfriend, animated: true, completion: nil)
          }).disposed(by: cell.disposeBag)
        }
        return cell
      }
    }
    
    contactCellViewModels.asObservable().bind(to: contactsCollectionView.rx.items(dataSource: contactsDataSource)).disposed(by: disposeBag)
    refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
      self.getPendingFriendRequests()
      self.getContacts()
      DispatchQueue.main.async(execute: {[unowned self]()->Void in
        self.refreshControl.endRefreshing()
      })
    }).disposed(by: disposeBag)
  }
  private func setupView(){
    view.addSubview(activityIndicator)
    navigationItem.title = "Network"
    Helper.navigationWithGray((navigationController?.navigationBar)!)
    self.activityIndicator.centerVerticallyInSuperview()
    self.activityIndicator.centerHorizontallyInSuperview()
    self.activityIndicator.color = UIColor.darkerGold
    self.activityIndicator.isHidden = true
    setupSearchBar()
    setupSearchTableView()
    setupContactsCollectionView()
  }
  private func getPendingFriendRequests(){
    self.contactCellViewModels.value[0].items.removeAll()
    guard let observable = createPendingFriendRequestObservable() else{
      return
    }
    observable.subscribe(onNext:{(contact)->Void in
      self.contactCellViewModels.value[0].items.append(contact)
    }).disposed(by: disposeBag)
  }
  private func getContacts(){
    self.contactCellViewModels.value[1].items.removeAll()
    guard let connectedFriendsObservable = createNetworkObservable(),let waitingFriendRequestsObservable = createWaitingFriendRequestObservable() else{
      return
    }
    let observable = Observable.merge([connectedFriendsObservable,waitingFriendRequestsObservable])
    observable.subscribe(onNext:{[unowned self] contact in
      self.contactCellViewModels.value[1].items.append(contact)
    }).disposed(by: disposeBag)
  }
  
  private func setupSearch(){
    searchBar.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).flatMapLatest({[unowned self](text)->Observable<Contact?> in
      self.searchContactCellViewModels.value.removeAll()
      self.searchStatusLabel.frame = .zero
      self.activityIndicator.stopAnimating()
      
      guard let observable = searchContacts(searchTerm:text) else{
        return Observable.just(nil)
      }
      self.activityIndicator.isHidden = false
      self.activityIndicator.startAnimating()
      return observable.catchErrorJustReturn(nil)
    }).subscribe(onNext:{[unowned self](contactCellViewModel:Contact?)->Void in
      guard let contactCellViewModel = contactCellViewModel else{
        if self.searchContactCellViewModels.value.isEmpty{
          DispatchQueue.main.async(execute: {[unowned self]()->Void in
            self.searchStatusLabel.frame = self.searchTableView.frame
            self.activityIndicator.stopAnimating()
          })
        }else{
          DispatchQueue.main.async(execute: {[unowned self]()->Void in
            self.searchStatusLabel.frame = self.searchTableView.frame
          })
        }
        return
      }
      DispatchQueue.main.async(execute: {[unowned self]()->Void in
        self.searchStatusLabel.frame = .zero
        self.activityIndicator.stopAnimating()
        self.searchContactCellViewModels.value.append(contactCellViewModel)
      })
    }).disposed(by: disposeBag)
  }
}

extension NetworkViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return indexPath.section == 0 ? CGSize(width: collectionView.bounds.width, height: 175) : CGSize(width: collectionView.bounds.width, height: 82)
  }
}

