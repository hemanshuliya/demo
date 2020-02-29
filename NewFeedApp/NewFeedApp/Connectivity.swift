//
//  Connectivity.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity: NSObject {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
