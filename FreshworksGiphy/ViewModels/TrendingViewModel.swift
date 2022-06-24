//
//  TrendingViewModel.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Combine
import SwiftUI
import Foundation
import SDWebImageSwiftUI

final class TrendingViewModel: ObservableObject, AnimitedView {
    
    @Published var hudVisible:Bool = true
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published private var trending = Trending()
    private(set) var trendingArray:[TrendingData]  = []
    @Published private(set) var searchArray:[TrendingData]  = []
    
    private var searchText = ""
    private let delayInTyping = 30 // 0.30 second
    private var lastURL:String = ""
    
    init() {fetch()}

    private func fetch() {
        APIService.shared.getTrending { trendingObject, error in
            self.hudVisible = false
            if let trending = trendingObject {
                self.trending = trending
                self.trendingArray = trending.data
            } else if let error = error {
                self.isErrorShown = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func refreshView() {
        DispatchQueue.main.async {
            self.hudVisible = true
            self.fetch()
        }
    }
    
    var trendingCount:Int {
        return self.trendingArray.count
    }
    
    func getTrending(index: Int) -> TrendingData {
        let array = searchResults(searchText: self.searchText, completion: nil)
        return array[index]
    }
    
    @discardableResult func searchResults(searchText:String, searchType:SearchType = Giphy.searchType, completion:(([TrendingData]) -> ())?) -> [TrendingData] {
        if searchText.isEmpty {
            self.trendingArray = trending.data
            return trendingArray
        } else if self.searchText != searchText {
            switch searchType {
            case .api:
                self.apiSearch(searchText: searchText) { searchData in
                    self.trendingArray = searchData
                }
            case .local:
                self.localSearch(searchText: searchText) { searchData in
                    self.trendingArray = searchData
                }
            }
        }
        self.searchText = searchText
        return trendingArray
    }
    
    func favorate(index:Int, isFavorate:Bool) {
        if trendingArray.count > index {
            let trend = getTrending(index: index)
            if isFavorate {
                self.makeFavorate(trend: trend)
            } else {
                self.makeUNFavorate(trend: trend)
            }
        }
    }
    
    private func makeFavorate(trend:TrendingData) {
        let url = trend.images.downsized.url
        if self.lastURL != url {
            self.lastURL = url
            DispatchQueue.global(qos: .background).async {
                APIService.shared.download(gifURL: url) { data, error in
                    self.lastURL = ""
                    if let imageData = data {
                        FileManagerHelper.shared.store(data: imageData, forKey: trend.id, fileExtension: Giphy.fileExtension)
                        DispatchQueue.main.async {
                            self.searchArray = self.trendingArray
                        }
                    }
                }
            }
        }
    }
    
    private func makeUNFavorate(trend:TrendingData) {
        FileManagerHelper.shared.removeFile(forKey: trend.id, fileExtension: Giphy.fileExtension)
        DispatchQueue.main.async {
            self.searchArray = self.trendingArray
        }
    }
    
    func fetchView(index: Int) -> AnyView {
        let trend = getTrending(index: index)
        return AnyView(WebImage(url: URL(string: trend.images.downsized.url))
            .resizable()
            .placeholder {
                ProgressView()
            })
    }
    
    private func apiSearch(searchText:String, completion:(([TrendingData]) -> ())?) {
        APIService.shared.searchGIF(searchText: searchText, with: self.delayInTyping, completion: { trendingObject, error in
            if let trending = trendingObject {
                self.searchArray = trending.data
                self.trendingArray = self.searchArray
                completion?(self.searchArray)
            } else if let error = error {
                self.errorMessage = error.localizedDescription
            }
        })
    }
    
    private func localSearch(searchText:String, completion:(([TrendingData]) -> ())?) {
        self.searchArray = trending.data.filter { $0.title.contains(searchText) }
        completion?(self.searchArray)
    }
}
