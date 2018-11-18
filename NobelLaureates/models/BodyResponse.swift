//
//  BodyResponse.swift
//  NobelLaureates
//
//  Created by Herbert Caller on 18/11/2018.
//  Copyright © 2018 hacaller. All rights reserved.
//

import Foundation

struct BodyResponse {
    
    let _embedded: String?
    let nobels: [LaureateResponse]?
    let page: PageNode?
    let _links: LinkCollection?
    
}
