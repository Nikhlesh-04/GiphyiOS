//
//  API.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation

enum API:String {
    
    case trending                 = "trending"
    case search                   = "search"
    case customURL                = ""
}

extension API : APIRequirement {
    
    static var baseURL: String {
        return "https://api.giphy.com/v1/gifs/"
    }
    
    var apiHeader: [String : String] {
        return Constants.kHeaders
    }
    
    var defaultParams: [String : String] {
        return ["api_key":Giphy.apiKey]
    }
    
    var apiPath: String {
        return "\(API.baseURL)"
    }
    
    var methodPath: String {
        return self.rawValue
    }
}
