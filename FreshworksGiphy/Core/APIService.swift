//
//  APIService.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation

class APIService {
    
    static let shared:APIService = APIService()
    private let delayInTyping = 30
    private var workItem:DispatchWorkItem?
    private var urlSession:URLSessionDataTask?
    
    private init() {}
        
    func getTrending(completion: @escaping (Trending?, Error?) -> ()) {
        API.trending.request(objectType: Trending.self) { object, error in
            if let trending = object {
                DispatchQueue.main.async {
                    completion(trending, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func searchGIF(searchText:String, with delay:Int? = nil, completion:@escaping (Trending?, Error?) -> ()) {
        if let delays = delay {
            workItem?.cancel()
            self.urlSession?.cancel()
            let networkItem = DispatchWorkItem { [weak self] in
                print("\n\nSearch for: \(searchText)\n\n")
                self?.urlSession = self?.searchGIFAPI(searchText: searchText, completion: completion)
            }
            
            //This method, the WorkItem will be executed only after the user hasn’t typed anything for 30 milliseconds
            self.workItem = networkItem
            DispatchQueue.global().asyncAfter(deadline: .now() + .microseconds(delays), execute: networkItem)
            print("\n\nSearch for query for: \(searchText) WAITING\n\n")
        } else {
            self.searchGIFAPI(searchText: searchText, completion: completion)
        }        
    }
    
    @discardableResult private func searchGIFAPI(searchText:String,completion:@escaping (Trending?, Error?) -> ()) -> URLSessionDataTask? {
        return API.search.request(with: ["q":searchText], objectType: Trending.self) { object, error in
            if let trending = object {
                DispatchQueue.main.async {
                    completion(trending, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func download(gifURL:String, completion: @escaping (Data?, Error?) -> ()) {
        API.customURL.loadImage(fromURL: gifURL) { data, error in
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
