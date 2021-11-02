//
//  RijksData.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import UIKit

struct RijksData: Codable, Hashable {
    let count: Int
    let artObjects: [ArtObject]
    
    enum CodingKeys: String, CodingKey {
        case count
        case artObjects
    }
}

struct ArtObject: Codable, Hashable {
    
    static func == (lhs: ArtObject, rhs: ArtObject) -> Bool {
        lhs.objectNumber == rhs.objectNumber &&
        lhs.longTitle == rhs.longTitle &&
        lhs.principalOrFirstMaker == rhs.principalOrFirstMaker &&
        lhs.webImage == rhs.webImage &&
        lhs.productionPlaces == rhs.productionPlaces
    }
    
    let objectNumber: String
    let longTitle: String
    let principalOrFirstMaker: String
    let webImage: WebImage
    let productionPlaces: [String]
    
    enum CodingKeys: String, CodingKey {
        case objectNumber
        case longTitle
        case principalOrFirstMaker
        case webImage
        case productionPlaces
    }
}

struct WebImage: Codable, Hashable {
    let url: URL?
}

struct ArtObjectDetails: Codable {
    let objectNumber: String
    let webImage: WebImage
    let principalMakers: PrincipalMakers
    let plaqueDescriptionEnglish: String
    let subtitle: String
    
    enum CodingKeys: String, CodingKey {
        case objectNumber
        case webImage
        case principalMakers
        case plaqueDescriptionEnglish
        case subtitle
    }
}

struct PrincipalMakers: Codable {
    let name: String
    let placeOfBirth: String
    let dateOfBirth: String
    let dateOfDeath: String
    let placeOfDeath: String
    let nationality: String
}
