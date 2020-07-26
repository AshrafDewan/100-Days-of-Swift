//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Ashraf on 12/23/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var flagView: UIImageView!
    var selectedFlag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedFlag?.uppercased()
        navigationItem.largeTitleDisplayMode = .never
        
        flagView.backgroundColor = UIColor.lightGray
        //P30 -> 2
        if let flagToLoad = selectedFlag {
            if let path = Bundle.main.path(forResource: flagToLoad, ofType: "png") {
                if let flag = UIImage(contentsOfFile: path) {
                    flagView.image = flag
                }
            }
        }
        //
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let flag = flagView.image?.jpegData(compressionQuality: 0.8) else {
            print("No flag found")
            return
        }
        let vc = UIActivityViewController(activityItems: [flag], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
