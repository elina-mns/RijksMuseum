//
//  RijksData.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import UIKit

struct RijksData: Codable, Hashable {
    let count: Int
    let artObjects: [ArtObjects]
    
    enum CodingKeys: String, CodingKey {
        case count
        case artObjects
    }
}

struct ArtObjects: Codable, Hashable {
    
    static func == (lhs: ArtObjects, rhs: ArtObjects) -> Bool {
        lhs.longTitle == rhs.longTitle &&
        lhs.principalOrFirstMaker == rhs.principalOrFirstMaker &&
        lhs.webImage == rhs.webImage &&
        lhs.productionPlaces == rhs.productionPlaces
    }
    
    let longTitle: String
    let principalOrFirstMaker: String
    let webImage: WebImage
    let productionPlaces: [String]
    
    enum CodingKeys: String, CodingKey {
        case longTitle
        case principalOrFirstMaker
        case webImage
        case productionPlaces
    }
}

struct WebImage: Codable, Hashable {
    let url: URL?
}
