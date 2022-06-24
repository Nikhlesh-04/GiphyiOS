//
//  FileManager.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.

import Foundation
import UIKit

final class FileManagerHelper:ObservableObject {
    
    static let shared:FileManagerHelper = FileManagerHelper()
    
    private let folderPath:String = Constants.appName + "/"
    
    private init() {}
    
    @discardableResult func store(data:Data, forKey key:String, fileExtension:String, withStorageType storageType: StorageType =  Giphy.fileStorage) -> Bool {
        switch storageType {
        case .fileSystem:
            return FileManager.saveFile(data: data, name: folderPath + key, fileExtension: fileExtension)
        case .userDefaults:
            return self.saveToUserDefalut(data: data, name: key)
        }
    }
    
    @discardableResult private func saveToUserDefalut(data:Data, name:String) -> Bool {
        if var imageDict = UserDefaults.standard.object(forKey: Constants.appName) as? [String:Data] {
            if self.retriveFromUserDefalut(name: name) == nil {
                imageDict[name] = data
                UserDefaults.standard.set(imageDict,
                                          forKey: Constants.appName)
                UserDefaults.standard.synchronize()
                return true
            } else {
                print("File already exists !!!")
                return false
            }
        } else {
            let dict = [name:data]
            UserDefaults.standard.set(dict,
                                      forKey: Constants.appName)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    func store(image: UIImage,
                       forKey key: String,
                       withStorageType storageType: StorageType =  Giphy.fileStorage) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                FileManager.saveFile(data: pngRepresentation, name: folderPath + key, fileExtension: "png")
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                          forKey: key)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func retrieveImage(forKey key: String,
                               inStorageType storageType: StorageType =  Giphy.fileStorage) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let fileData = FileManager.getFile(name: folderPath + key, fileExtension: "png"),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    func retrieve(forKey key: String, fileExtension:String, inStorageType storageType: StorageType = Giphy.fileStorage) -> Data? {
        switch storageType {
        case .fileSystem:
            if let fileData = FileManager.getFile(name: folderPath + key, fileExtension: fileExtension) {
                return fileData
            }
        case .userDefaults:
            return retriveFromUserDefalut(name: key)
        }
        
        return nil
    }
    
    private func retriveFromUserDefalut(name:String) -> Data? {
        if let imageDict = UserDefaults.standard.object(forKey: Constants.appName) as? [String:Data], let imageData = imageDict[name] {
            return imageData
        }
        return nil
    }
    
    func fetchAllData(inStorageType storageType: StorageType = Giphy.fileStorage) -> [Favorite]? {
        switch storageType {
        case .fileSystem:
            let fileData = FileManager.getAllFilesNamesExtension(nameDirectory: Constants.appName, extensionWanted: "gif")
            var array:[Favorite] = []
            for item in 0..<fileData.names.count {
                array.append(Favorite(id: fileData.names[item], url: fileData.paths[item], data: nil, storageType: storageType))
            }
            return array
        case .userDefaults:
            if let imageDict = UserDefaults.standard.object(forKey: Constants.appName) as? [String:Data] {
                var array:[Favorite] = []
                for item in 0..<imageDict.count {
                    array.append(Favorite(id: Array(imageDict.keys)[item], url: nil, data: Array(imageDict.values)[item], storageType: storageType))
                }
                return array
            }
        }
        return nil
    }
    
    @discardableResult func removeFile(forKey key: String, fileExtension:String, inStorageType storageType: StorageType = Giphy.fileStorage) -> Bool {
        switch storageType {
        case .fileSystem:
            if let path = FileManager.filePath(forKey: folderPath + key, fileExtension: fileExtension) {
                return FileManager.deleteFileWithPath(path.path)
            }
        case .userDefaults:
            return removeFromUserDefalut(name: key)
        }
        
        return false
    }
    
    private func removeFromUserDefalut(name:String) -> Bool {
        if var imageDict = UserDefaults.standard.object(forKey: Constants.appName) as? [String:Data] {
            imageDict.removeValue(forKey: name)
            UserDefaults.standard.set(imageDict,
                                      forKey: Constants.appName)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    func deleteAllFiles(inStorageType storageType: StorageType =  Giphy.fileStorage) -> Bool {
        switch storageType {
        case .fileSystem:
            if let path = FileManager.filePath(forKey: Constants.appName, fileExtension: "") {
                FileManager.deleteFileWithPath(path.path)
                return true
            } else {
                return false
            }
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: Constants.appName)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    func isFileExits(forKey key: String, fileExtension:String, inStorageType storageType: StorageType = Giphy.fileStorage) -> Bool {
        switch storageType {
        case .fileSystem:
            if let filePath = FileManager.filePath(forKey: folderPath + key, fileExtension: fileExtension) {
                return FileManager.default.fileExists(atPath: filePath.path)
            }
        case .userDefaults:
            return retriveFromUserDefalut(name: key) != nil
        }
        return false
    }
    
    /*
    private func save(name:String) {
        if let buildingImage = UIImage(named: name) {
            DispatchQueue.global(qos: .background).async {
                self.store(image: buildingImage,
                           forKey: name,
                           withStorageType: .fileSystem)
            }
        }
    }*/
    
}
