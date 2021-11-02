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
        case requestCollectionDetails(artObject: String)
        case requestCollectionImage(artObject: String)
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .listAllCollection:
                return "https://www.rijksmuseum.nl/api/en/collection?key=\(apiKey)"
            case let .requestCollectionDetails(artObject):
                return "https://www.rijksmuseum.nl/api/en/collection/\(artObject)?key=\(apiKey)"
            case let .requestCollectionImage(artObject):
                return "https://www.rijksmuseum.nl/api/en/collection/\(artObject)/tiles?key=\(apiKey)"
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
    
    func requestCollectionDetails(with artObject: String, completionHandler: @escaping (ArtObject?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.requestCollectionImage(artObject: artObject).url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let downloadedImageData = try! decoder.decode(ArtObject.self, from: data)
            completionHandler(downloadedImageData, nil)
        })
        task.resume()
    }
}
