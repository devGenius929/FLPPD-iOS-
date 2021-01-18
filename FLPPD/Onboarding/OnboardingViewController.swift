//
//  OnboardingViewController.swift
//  FLPPD
//
//  Created by Vlad Konon on 12/24/17.
//  Copyright © 2017 New Centuri Properties LLC. All rights reserved.
//

import UIKit
struct OnboadingContent {
    let image:UIImage
    let title:String
    let text:String
}

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    let content:[OnboadingContent] = [
        OnboadingContent(image: #imageLiteral(resourceName: "on_boarding1"), title: "Search for Investment Properties", text: "Find off market deals with ease whether you are searching for Flips, Rehabs or Rentals."),
        OnboadingContent(image: #imageLiteral(resourceName: "on_boarding2"), title: "Add your own listings", text: "List your own property deals instantly in front of thousands of investors that are scanning for their next potential investment."),
        OnboadingContent(image: #imageLiteral(resourceName: "on_boarding3"), title: "Fast Valuation Tool", text: "Evaluate Real Estate Property deals, analyze your financing and determine your exit strategy with ease."),
        OnboadingContent(image: #imageLiteral(resourceName: "on_boarding4"), title: "Connect with Investors around the Globe", text: "Potentially find your next JV Partner or simply connect with other investors in our FLPPD Community. Relieve yourself from the Clutter of Social Media and focus on building with like minded people."),
        OnboadingContent(image: #imageLiteral(resourceName: "on_boarding5"), title: "Investor Pro Membership", text: "Becoming an Investor Pro Member for only $9.99 gives Full Access to Exclusive Off Market Deals and All Customized Report Features. Want Maximum Exposure for your Off Market Deals? Turn them into Platinum Listings for Top Ranking"),
        
    ]
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    var pages = [OnboardingPageViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = content.map { _ in self.storyboard?.instantiateViewController(withIdentifier: "page") as! OnboardingPageViewController}
        _ = zip(pages, content).map { (page,content) -> Void in
            _ = page.view
            page.imageView.image = content.image
            page.titleLabel.text = content.title
            page.text.text = content.text
            self.addChildViewController(page)
            scrollView.addSubview(page.view)
            page.view.alpha = 0
        }
        pageControl.numberOfPages = pages.count
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var size = self.view.frame.size
        size.height = scrollView.frame.height
        scrollView.contentSize = CGSize(width: size.width*CGFloat(pages.count), height: size.height)
        for (index,page) in pages.enumerated() {
            let frame = CGRect(x: CGFloat(index) * size.width, y: 0, width: size.width, height: size.height)
            page.view.frame = frame
        }
        UIView.animate(withDuration: 0.1) {
            _ = self.pages.map {$0.view.alpha = 1.0}
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
        AppDelegate.current.continueAfterTutorial()
    }
    
    @IBAction func pageAction(_ sender: UIPageControl) {
        let page = sender.currentPage
        let width = self.view.frame.width
        let scroll_rect = CGRect(x: width * CGFloat(page), y: 0, width: width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(scroll_rect, animated: true)
        updateButton(forPageNumber: page)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        let page = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = page
        updateButton(forPageNumber: page)
    }
    func updateButton(forPageNumber page:Int) {
        if page < content.count-1 {
            skipButton.backgroundColor = UIColor(hex: 0xB8B08D)
            skipButton.setTitle("SKIP", for: .normal)
        }
        else {
            skipButton.backgroundColor = UIColor(hex: 0x388E3C)
            skipButton.setTitle("NEXT", for: .normal)
        }
    }
    @IBAction func tapTable(_ sender: Any) {
        self.view.endEditing(true)
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
