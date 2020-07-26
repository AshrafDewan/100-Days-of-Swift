//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Ashraf Dewan on 5/13/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var notesDict = [String: String]()
    var notesNames = [String]()
    var body = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        navigationItem.leftBarButtonItems = [back, save]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote))
        
        textView.text = body
    }
    
    @objc func backButtonTapped() {
        body = textView.text
        notesDict[title!] = body
        
        let defaults = UserDefaults.standard
        defaults.set(notesDict, forKey: "Notes")
        
        presentViewController()
    }
    
    @objc func saveNote() {
        body = textView.text
        notesDict[title!] = body
        
        let defaults = UserDefaults.standard
        defaults.set(notesDict, forKey: "Notes")
    }
    
    @objc func removeNote() {
        notesNames.remove(at: notesNames.firstIndex(of: title!)!)
        notesDict.removeValue(forKey: title!)
        textView.text = notesDict[title!]
        
        let defaults = UserDefaults.standard
        defaults.set(notesDict, forKey: "Notes")
        defaults.set(notesNames, forKey: "NotesNames")
        
        presentViewController()
    }
    
    func presentViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            vc.notesNames = notesNames
            vc.notesDict = notesDict
            vc.tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
