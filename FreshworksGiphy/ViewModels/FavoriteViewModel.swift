//
//  FavoriteViewModel.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import Combine
import SwiftUI
import Foundation
import SDWebImageSwiftUI

final class FavoriteViewModel: ObservableObject, AnimitedView {
        
    @Published var hudVisible:Bool = true
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published private(set)var favorite:[Favorite] = []
    
    init() {fetch()}

    private func fetch() {
        self.hudVisible = false
        if let data = FileManagerHelper.shared.fetchAllData() {
            self.favorite = data
        } else {
            self.isErrorShown = true
            self.errorMessage = CustomError.sometingWentWrong.localizedDescription
        }
    }
    
    func refreshView() {
        DispatchQueue.main.async {
            self.hudVisible = true
            self.fetch()
        }
    }
    
    var favoriteCount:Int {
        return self.favorite.count
    }
    
    func getFavorite(index: Int) -> Favorite? {
        if favorite.count > index {
            return favorite[index]
        }
        return nil
    }
    
    
    func favorate(index:Int, isFavorate:Bool) {
        if favorite.count > index {
            let trend = favorite[index]
            if isFavorate {
                self.makeFavorate(trend: trend)
            } else {
                self.makeUNFavorate(trend: trend)
            }
        }
    }
    
    private func makeFavorate(trend:Favorite) {
    }
    
    private func makeUNFavorate(trend:Favorite) {
        FileManagerHelper.shared.removeFile(forKey: trend.id, fileExtension: Giphy.fileExtension)
        self.refreshView()
    }
    
    func fetchView(index: Int) -> AnyView {
        if let fav = getFavorite(index: index) {
            switch Giphy.fileStorage {
            case .fileSystem:
                if let url = fav.url {
                    return AnyView(AnimatedImage(url: url)
                        .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill))
                }
            case .userDefaults:
                if let data = fav.data {
                    return AnyView(AnimatedImage(data: data)
                        .placeholder {
                        ProgressView()
                    }
                    .resizable()
                   .aspectRatio(contentMode: .fill))
                }
            }
        }
        return AnyView(EmptyView())
        
    }

}
