//
//  Picture.swift
//  Challenge4
//
//  Created by Ashraf on 2/19/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class Picture: NSObject {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}
