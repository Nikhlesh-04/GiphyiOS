//
//  Constants.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import SwiftUI

public struct Constants {
    
    static let kUserDefaults        = UserDefaults.standard

    static let kScreenWidth         = UIScreen.main.bounds.width
    static let kScreenHeight        = UIScreen.main.bounds.height
    
    static let kHeaders = ["Content-Type": "application/json"]
    
    static let typeSizes: [DynamicTypeSize] = [
        .xSmall,
        .large,
        .xxxLarge
    ]
    
    static func setupAppearance(colorScheme:ColorScheme) {
        ColourStyle.shared.colorScheme = colorScheme
    }
    
    static let appName = "FreshworksGiphy"
}

public struct Giphy {
    static let apiKey                   = "nxOODH8j0th9tQWXMxIU8QNW6YN0e4nx"
    static let fileStorage:StorageType  = .fileSystem
    static let fileExtension:String     = "gif"
    static var searchType:SearchType    = .api
}

public struct UserDefaultsConstants {
    static let userState = "UserState"
}

// MARK: - Web Service Constans Objects.
public struct ApiConstants {
    static let apiTimeoutTime =  60 //Seconds.
}

// MARK: - Error Messages Objects.
public struct ConstantsMessages {
    
    static let welcomeText                  = "Welcome to Giphy"
    static let navigationTrendingTitle      = "Trending"
    static let navigationFavoriteTitle      = "Favorite"
    static let noFavourites                 = "Sorry you don't have any favourites"
}

public struct Identifiers {
    
    static let trendingTable            = "trending_table_view"
    static let favoriteButton           = "favorite_button"
    static let favoriteButtonImageView  = "favorite_button_imageview"
    static let cellImageView            = "cell_imageView"
}

public struct ConstantImage {
    
    static let personCircle     = "person.circle.fill"
    static let heart            = "heart.fill"
    static let gallery          = "photo.on.rectangle"
    static let favorite         = "favorite"
    static let unfavorite       = "unfavorite"
    
}

public enum CustomError: Error {
    case sometingWentWrong
}

public enum SearchType {
    case api
    case local
}

public enum StorageType {
    case userDefaults
    case fileSystem
}
