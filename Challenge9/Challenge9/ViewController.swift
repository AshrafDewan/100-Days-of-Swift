//
//  ViewController.swift
//  Challenge9
//
//  Created by Ashraf Dewan on 5/18/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    var sharedList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(importImage))
        
        importImage()
    }
    
    @objc func importImage() {
        let ac = UIAlertController(title: "Import Image", message: "Select an image from your library", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Import", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareImage() {
        guard let selectedImage = imageView.image else { return }
        sharedList.append(selectedImage)
        
        let vc = UIActivityViewController(activityItems: sharedList, applicationActivities: [])
        present(vc, animated: true)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        sharedList.removeAll()
    }
    
    @objc func topCaptionTapped() {
        let ac = UIAlertController(title: "Add Top Caption", message: nil, preferredStyle: .alert)
        ac.addTextField() { placeHolderText in
            placeHolderText.placeholder = "Write a caption"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let selectedImage = self?.selectedImage else { return }
            guard let text = ac?.textFields?[0].text else { return }
            let x = (selectedImage.size.width / 2) - 600
            self?.captionTapped(x, 50, text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func buttomCaptionTapped() {
        let ac = UIAlertController(title: "Add Buttom Caption", message: nil, preferredStyle: .alert)
        ac.addTextField() { placeHolderText in
            placeHolderText.placeholder = "Write a caption"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let selectedImage = self?.selectedImage else { return }
            guard let text = ac?.textFields?[0].text else { return }
            let x = (selectedImage.size.width / 2) - 600
            let y = (selectedImage.size.height) - 200
            self?.captionTapped(x, y, text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func captionTapped(_ x: CGFloat, _ y: CGFloat, _ text: String) {
        guard let selectedImage = selectedImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: selectedImage.size)
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 120),
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            selectedImage.draw(at: CGPoint(x: 0, y: 0))
            attributedString.draw(with: CGRect(x: x, y: y, width: 1200, height: 1200), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = image
        self.selectedImage = image
    }
    
    func activateButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareImage))
        
        let topCaption = UIBarButtonItem(title: "Top Caption", style: .plain, target: self, action: #selector(topCaptionTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let buttomCaption = UIBarButtonItem(title: "Buttom Caption", style: .plain, target: self, action: #selector(buttomCaptionTapped))
        
        toolbarItems = [topCaption, spacer, buttomCaption]
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true)
        imageView.image = image
        
        if imageView.image != nil {
            activateButtons()
            selectedImage = image
        }
    }
}

