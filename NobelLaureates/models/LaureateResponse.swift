//
//  LaureateResponse.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 16/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import Foundation

extension LaureateResponse {
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let year = json["year"] as? Int,
            let country = json["country"] as? String,
            let rationale = json["rationale"] as? String,
            let flag = json["flag"] as? String,
            let photo = json["photo"] as? String,
            let category = json["category"] as? String,
            let genre = json["genre"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.year = year
        self.country = country
        self.rationale = rationale
        self.flag = flag
        self.photo = photo
        self.category = category
        self.genre = genre
    }
}

struct LaureateResponse {
    
    let id: Int
    let name: String
    let year: Int
    let country: String
    let rationale: String
    let flag: String
    let photo: String
    let category: String
    let genre: String
    
}
