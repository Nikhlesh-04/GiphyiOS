//
//  Trending.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation

struct Trending: Codable {
    var data: [TrendingData]             = []
}

struct TrendingData: Codable {
    var type: String                = ""
    var id: String                  = ""
    var username: String            = ""
    var title: String               = ""
    var rating: String              = ""
    var images: Images              = Images()
    
    var isFavorate:Bool {
        return FileManagerHelper.shared.isFileExits(forKey: id, fileExtension: Giphy.fileExtension)
    }
}

struct Images:Codable {
    var original:ImageData          = ImageData()
    var downsized:ImageData         = ImageData()
}

struct ImageData: Codable {
    var height: String              = ""
    var width: String               = ""
    var size: String                = ""
    var url: String                 = ""
}
