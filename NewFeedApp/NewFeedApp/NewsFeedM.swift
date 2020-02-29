//
//  NewsFeedM.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit

class NewsFeedM: NSObject {
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.title, forKey: "title")
//        aCoder.encode(self.title, forKey: "desc")
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.title = aDecoder.decodeObject(forKey: "title") as? String
//        self.desc = aDecoder.decodeObject(forKey: "desc") as? String
//    }
    
    var title : String?
    var desc : String?
    var image : String?
    var date : String?
    var isFavourite : Bool?
    
    func initWithArticle(title: String, desc : String, image: String, date: String, isFavourite: Bool) {
        
        self.title = title;
        self.desc = desc
        self.image = image
        self.date = date
        self.isFavourite = isFavourite
    }
    
    
}
