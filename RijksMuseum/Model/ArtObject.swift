//
//  ArtObject.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-11-04.
//

import Foundation

struct DetailsResponse: Codable {
    var artObject: ArtObjectDetails
}

struct ArtObjectDetails: Codable {
    var objectNumber: String?
    let webImage: WebImage?
    let makers: Makers?
    let plaqueDescriptionEnglish: String?
    let subtitle: String?
    
    enum CodingKeys: String, CodingKey {
        case objectNumber
        case webImage
        case makers
        case plaqueDescriptionEnglish
        case subtitle
    }
}

struct Makers: Codable {
    let name: String
    let placeOfBirth: String
    let dateOfBirth: String
    let dateOfDeath: String
    let placeOfDeath: String
    let nationality: String
}
