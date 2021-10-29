//
//  API.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import Foundation

class API {
    static let apiKey = "LazakTr7"
    
    enum EndPoint {
        case listAllWorks
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .listAllWorks:
                return "https://www.rijksmuseum.nl/api/en/collection?key=[\(apiKey)]"
            }
        }
    }
    
    func requestRijksCollection(completionHandler: @escaping (RijksData?, Error?) -> Void) {
        
    }
}
