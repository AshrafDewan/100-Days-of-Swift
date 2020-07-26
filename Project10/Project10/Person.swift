//
//  Person.swift
//  Project10
//
//  Created by Ashraf on 1/18/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
