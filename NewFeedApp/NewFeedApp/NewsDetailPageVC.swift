//
//  NewsDetailPageVC.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit

class NewsDetailPageVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFavPressed: UIButton!
    var feedM : NewsFeedM?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = feedM?.title;
        self.lblDesc.text = feedM?.desc
        self.lblDate.text = feedM?.date
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnFavPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if !appDelegate.arrFeeds.contains(feedM!) {
                    appDelegate.arrFeeds.append(feedM!)
//        }
    
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
