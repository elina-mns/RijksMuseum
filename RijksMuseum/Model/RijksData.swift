//
//  RijksData.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import UIKit

struct RijksData: Codable {
    let count: String
    let artObjects: [ArtObjects]
    
    enum CodingKeys: String, CodingKey {
        case count
        case artObjects
    }
}

struct ArtObjects: Codable {
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

struct WebImage: Codable {
    let url: URL?
}
