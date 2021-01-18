//
//  AreaEditViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/22/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AreaEditViewController: UICollectionViewController   {
    var areas = [String](){
        didSet {
            collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.scrollDirection = .vertical
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return areas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AreaCell.cellID(), for: indexPath) as! AreaCell
    
        cell.area = areas[indexPath.row]
        cell.delButton?.removeTarget(nil, action: nil, for: .allEvents)
        cell.delButton?.addTarget(self, action: #selector(AreaEditViewController.delAction(_:)), for: .touchUpInside)
        cell.delButton?.tag = indexPath.row
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        return cell
    }
    @objc
    func delAction(_ sender:UIButton){
        let text = areas[sender.tag]
        self.areas = self.areas.filter{ $0 != text }
        collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
 

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

class AreaEditViewControllerWOButtons: AreaEditViewController{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AreaCell.cellID(), for: indexPath) as! AreaCellWOButton
        
        cell.area = areas[indexPath.row]
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        return cell
    }
}
