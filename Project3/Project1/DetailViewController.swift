//
//  DetailViewController.swift
//  Project1
//
//  Created by Ashraf on 12/12/19.
//  Copyright © 2019 Ashraf Dewan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage : String?
    //1
    var sharedList = [UIImage]()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
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
        //1
        guard let selectedImage = selectedImage else { return }
        guard let LoadedImage = UIImage(named: selectedImage) else { return }
        //P27 -> 3
        let renderer = UIGraphicsImageRenderer(size: LoadedImage.size)
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            LoadedImage.draw(at: CGPoint(x: 0, y: 0))
            attributedString.draw(with: CGRect(x: 20, y: 20, width: 360, height: 360), options: .usesLineFragmentOrigin, context: nil)
        }
        //
        sharedList.append(image)
        let vc = UIActivityViewController(activityItems: sharedList, applicationActivities: [])
        //
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
        sharedList.removeAll()
    }
    
}
