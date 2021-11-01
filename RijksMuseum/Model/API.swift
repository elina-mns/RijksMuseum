//
//  API.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import Foundation

class API {
    static let apiKey = "LazakTr7"
    
    enum EndPoints {
        case listAllCollection
        case requestCollectionDetails
        case requestCollectionImage
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .listAllCollection:
                return "https://www.rijksmuseum.nl/api/en/collection?key=\(apiKey)"
            case .requestCollectionDetails:
                return "https://www.rijksmuseum.nl/api/en/collection/SK-C-5?key=\(apiKey)"
            case .requestCollectionImage:
                return "https://www.rijksmuseum.nl/api/en/collection/SK-C-5/tiles?key=\(apiKey)"
            }
        }
    }
    
    func requestRijksCollection(completionHandler: @escaping (RijksData?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.listAllCollection.url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let downloadedImageData = try! decoder.decode(RijksData.self, from: data)
            completionHandler(downloadedImageData, nil)
        })
        task.resume()
    }
}
