//
//  ImagePagesViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/27/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit
import Alamofire

class ImagePagesViewController: UIViewController, UIScrollViewDelegate {
    var imageURLs:[URL] = [URL]() {
        didSet {
            self.updateImages()
        }
    }
    private var imageWidth:CGFloat = 375
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    private func updateImages() {
        if let scrollView = scrollView {
            pageController.numberOfPages = imageURLs.count
            let imageWidth = self.view.frame.width
            let scrollViewContentWidth = imageWidth * CGFloat(imageURLs.count)
            let contentSize = CGSize(width: scrollViewContentWidth, height: scrollView.frame.height)
            self.imageWidth = self.scrollView.frame.width
            self.scrollView.contentSize = contentSize
            var imageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: contentSize.height)
            for i in 0..<imageURLs.count {
                let imageView = ImageViewPopup(frame: imageFrame)
                scrollView.addSubview(imageView)
                let progressView = UIProgressView(progressViewStyle: .bar)
                progressView.frame = CGRect(x: (imageWidth / 4), y: (imageFrame.height / 2) - 5, width: imageWidth / 2.0, height: 10)
                imageView.addSubview(progressView)
                imageView.contentMode = .scaleAspectFill
                imageView.af_setImage(withURL: imageURLs[i], placeholderImage: #imageLiteral(resourceName: "loginBackground"), filter: nil, progress: { (progress) in
                    progressView.progress =  Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                    
                }, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.15), runImageTransitionIfCached: false, completion: { [weak self](responce) in
                    progressView.removeFromSuperview()
                    self?.scrollView.backgroundColor = UIColor.black
                    self?.scrollView.isOpaque = true
                })
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageFrame.origin.x += imageWidth
                
            }
            if imageURLs.count < 2 {
                pageController.isHidden = true
            }
        }
    }
    override func viewDidLayoutSubviews() {
        updateImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    func updateCurrentPage(){
        pageController.currentPage = Int(floor(scrollView.contentOffset.x / imageWidth))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
