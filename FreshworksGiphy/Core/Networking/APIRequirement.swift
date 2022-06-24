//
//  APIRequirement.swift
//  FreshworksGiphy
//
//  Created by Nikhlesh bagdiya on 22/06/22.
//

import Foundation
import Combine
import UIKit

public typealias Params = [String: CustomStringConvertible]


public protocol APIRequirement {
    
    static var baseURL: String {get}
    var apiHeader: [String:String] {get}
    var defaultParams:[String:String] {get}
    var apiPath: String {get}
    var methodPath: String { get }
    
    
    @discardableResult func request<T: Decodable>(method: HTTPMethod, urlParameter:String?, with parameters: Params?, objectType: T.Type, completionHandler:((_ object:T?, _ error: Error?) -> Void)?) -> URLSessionDataTask?
    
    @discardableResult func loadImage(fromURL:String, completionHandler: ((_ data:Data?, _ error:Error?)->Void)?) -> URLSessionDataTask?
}

extension APIRequirement {
    
    @discardableResult func request<T: Decodable>(method: HTTPMethod = .get, urlParameter:String? = nil, with parameters: Params? = nil, objectType: T.Type, completionHandler:((_ object:T?, _ error: Error?) -> Void)?) -> URLSessionDataTask? {
        
        var parameterss = parameters
        
        for (key, value) in self.defaultParams {
            if var dict = parameterss {
                dict[key] = value
                parameterss = dict
            } else {
                parameterss = [key:value]
            }
        }
       
        var urlString = apiPath + methodPath
        
        if method == .get, let urlParam = urlParameter {
            urlString += urlParam
        }
        
        print("\n**** Request method: \(method),\(urlString)\n")
        
        if let parameters = parameterss {
            print("\n**** Parameters: \(parameters)\n")
        }
        
        guard var url = URLComponents(string: urlString) else {
            print("Get an error")
            return nil
        }
        
        if (method == .get || method == .delete), let parameters = parameterss ,parameters.count > 0 {
            url = setURLWithParams(uRLComponents: url, params: parameters)
        }
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url.url!)
        
        //MARK: HTTPMethod
        urlRequest.httpMethod = method.rawValue
        
        // MARK:- HeaderField
        let finalHeaders  = self.apiHeader
        
        for (key, value) in finalHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        //MARK: Request Timeout Time
        urlRequest.timeoutInterval = TimeInterval(ApiConstants.apiTimeoutTime)
        
        if let parameters = parameters, parameters.count > 0, method != .get {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            urlRequest.httpBody = jsonData
        }
        print("URL request :- \(urlRequest)")
        // **** Make the request **** //
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            if let httpURLResponse = response as? HTTPURLResponse {
                if !(200...299 ~= httpURLResponse.statusCode) {
                    var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                    if let datas = data, let json = try? JSONSerialization.jsonObject(with: datas, options: []) {
                        error.jsonPayload = json
                    }
                    DispatchQueue.main.async {
                        completionHandler?(nil, error)
                    }
                } else if let object = try? JSONDecoder().decode(T.self, from: data!) {
                    DispatchQueue.main.async {
                        print("\n**** Response: \(object)\n")
                        completionHandler?(object, nil)
                    }
                } else {
                    var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                    error.jsonPayload = "Something went wrong.\nTry again."
                    DispatchQueue.main.async {
                        completionHandler?(nil, error)
                    }
                }
            }
        })
        task.resume()
        return task
    }
    
    private func setURLWithParams(uRLComponents:URLComponents, params:Params) -> URLComponents {
        var urlComponents = uRLComponents
        var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
        params.forEach { param in
            // arrayParam[] syntax
            if let array = param.value as? [CustomStringConvertible] {
                array.forEach {
                    queryItems.append(URLQueryItem(name: "\(param.key)[]", value: "\($0)"))
                }
            }
            queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
        }
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    @discardableResult func loadImage(fromURL:URL, completionHandler: ((_ data:Data?, _ error:Error?)->Void)?) -> URLSessionDataTask? {
        
        // Create URL Session Configuration
        let configuration = URLSessionConfiguration.default
        
        // Define Request Cache Policy
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let session = URLSession(configuration: configuration)
        
        
        let task = session.dataTask(with: fromURL) { (data, response, error) in
                if let error = error {
                    completionHandler?(nil,error)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        completionHandler?(nil,error)
                        return
                    }
                    if let data = data {
                        if let _ = UIImage(data: data) {
                            completionHandler?(data, error)
                            return
                        }
                        if response.mimeType?.contains("text") ?? false || response.mimeType?.contains("json") ?? false {
                            completionHandler?(nil,error)
                            return
                        }
                        completionHandler?(nil,error)
                        return
                    }
                    completionHandler?(nil,error)
                    return
                }
            completionHandler?(nil,error)
            }
        task.resume()
        return task
    }
    
    @discardableResult func loadImage(fromURL:String, completionHandler: ((_ data:Data?, _ error:Error?)->Void)?) -> URLSessionDataTask? {
        if let url = URL.init(string: fromURL) {
            return self.loadImage(fromURL: url, completionHandler: completionHandler)
        }
        return nil
    }
}
