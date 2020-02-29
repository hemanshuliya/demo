//
//  FavouriteVC.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit

class FavouriteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrFeeds : Array<NewsFeedM> = [NewsFeedM]()
    var myNews : NewsFeedM?

    override func viewDidLoad() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self;
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        
        self.collectionView.register(UINib(nibName: "NewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.arrFeeds = appDelegate.arrFeeds;
        self.collectionView.reloadData()

    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFeeds.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewCell
        
        let feedM = self.arrFeeds[indexPath.row]
        cell.newsTitle.text = feedM.title
        cell.imgView.af_setImage(withURL: URL.init(string:feedM.image!)! )
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width
        _ = UIScreen.main.bounds.size.height
        
        
        return CGSize(width: width, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.myNews = arrFeeds[indexPath.row]
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "detailsegue") as! NewsDetailPageVC
        
        viewController.feedM = self.myNews
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
