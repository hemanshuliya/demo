//
//  NewFeedVC.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit
import AlamofireImage


class NewFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrFeeds : Array<NewsFeedM> = [NewsFeedM]()
    var myNews : NewsFeedM?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
//            if let data = UserDefaults.standard.objectForKey("customArray") as? NSData
//            {
//                custom = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [customData]
//            }
        }
        
        self.collectionView.register(UINib(nibName: "NewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
        
        
        
        

        let apiKey = "d3b2a3e3c2504bd6bd217e07adfcf53e"

        
        let nam = NewsAPIManager() // Initialize News API Manager
        
//        var currentArticles = UserDefaults.standard.object(forKey: "NewsAPI-Swift Articles")
        
        nam.getArticles(source: .CNN, key: apiKey){data in // Getting articles from CNN
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let jsonArray = json as? [String: AnyObject] {
                            print("\(jsonArray)")
                    
                    if let articles = jsonArray["articles"] as? NSArray {
                        for article in articles { // Get each article
                            print("\(article)")
                    
                            let disc : NSDictionary = article as! NSDictionary
                            
                            let feedM = NewsFeedM()
                            feedM.title = disc.value(forKey: "title") as? String
                            feedM.image = disc.value(forKey: "urlToImage") as? String
                            feedM.desc = disc.value(forKey: "description") as? String
                            feedM.date = disc.value(forKey: "publishedAt") as? String
                            self.arrFeeds.append(feedM)
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
        }
    }
    
    fileprivate lazy var layout: UICollectionViewFlowLayout? = {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.sectionInset = UIEdgeInsets.zero
        // Calculate and change |itemSize| here
        
        let width = UIScreen.main.bounds.size.width
        _ = UIScreen.main.bounds.size.height
        layout?.itemSize = CGSize.init(width: width, height: 150)
        return layout
    }()
    
    
    
    func getArticles(source:NewsSources, key:String, completionHandler: @escaping (Data) -> ()) {
        let site = "https://newsapi.org/v1/articles?source=\(source.rawValue)&sortBy=top&apiKey=\(key)"
        let url = URL(string: site)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            
            if (err != nil) {
                completionHandler(Data())
            } else {
                completionHandler(data!)
            }
            
            
            
            }.resume()
        
    }

    
    //Mark :- UICollectionView
    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsegue" {
//            let vc = segue.destination as! NewsDetailPageVC
//            vc.feedM = self.myNews
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.myNews = arrFeeds[indexPath.row]
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "detailsegue") as! NewsDetailPageVC
        
        viewController.feedM = self.myNews

        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
