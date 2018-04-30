//
//  Request.swift
//  youtube2
//
//  Created by Victor QUESNEL on 4/27/18.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

final class RequestService {
    
    static let shared = RequestService()
    let cache = NSCache<NSString, UIImage>()
    
    func get<T: Decodable>(req: URLRequest, for type: T.Type, completion: @escaping(T?) -> Void) {
        URLSession.shared.dataTask(with: req) { data, res, err in
            guard err == nil else {
                self.printError(error: "DataService : \(String(describing: err))", completion: completion)
                return
            }
            guard let getData = data else {
                self.printError(error: "DataService : Data Not Recieved", completion: completion)
                return
            }
            guard let JSONData = try? JSONDecoder().decode(T.self, from: getData) else {
                self.printError(error: "DataService : Fetching From Data to Model failed", completion: completion)
                return
            }
            DispatchQueue.main.async { completion(JSONData) }
            }.resume()
    }
    
    func imageDownloader(url : String, completion: @escaping(UIImage?) -> Void) {
        guard let requestUrl = URL(string: url) else { return }
        let qos = DispatchQoS.background.qosClass
        if let cached = cache.object(forKey: NSString(string: url)) { completion(cached); return }
        
        DispatchQueue.global(qos: qos).async{ [unowned self] in
            guard let data = try? Data(contentsOf: requestUrl), let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self.cache.setObject(image, forKey: NSString(string: url))
            DispatchQueue.main.async { completion(image) }
        }
    }
    
    func printError<T>(error: String, completion: @escaping(T?) -> Void) {
        print(error)
        DispatchQueue.main.async { completion(nil) }
        return
    }
}
