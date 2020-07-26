//
//  ViewController.swift
//  Project18
//
//  Created by Ashraf on 3/11/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        print("Some message")
        
        //assert(1 == 2, "Math failure!")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}

