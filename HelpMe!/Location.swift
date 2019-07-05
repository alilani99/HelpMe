//
//  Location.swift
//  HelpMe!
//
//  Created by Aidan on 6/26/19.
//  Copyright © 2019 Aidan Lilani. All rights reserved.
//

import Foundation


class Location: Codable {
    
    var name = ""
    var coordinates = ""
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}
