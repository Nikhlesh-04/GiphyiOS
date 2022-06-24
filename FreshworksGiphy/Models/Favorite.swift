//
//  Favorite.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import Combine
import SwiftUI

class Favorite {
    var id: String                = ""
    var url: URL?                 = nil
    var data: Data?               = nil
    var storageType: StorageType  = .fileSystem
    
    init(id: String, url: URL?, data: Data?, storageType: StorageType) {
        self.id = id
        self.url = url
        self.data = data
        self.storageType = storageType
    }
    
    var isFavorate:Bool {
        return FileManagerHelper.shared.isFileExits(forKey: id, fileExtension: Giphy.fileExtension)
    }
    
}
