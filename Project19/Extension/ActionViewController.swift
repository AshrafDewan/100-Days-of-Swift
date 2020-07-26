//
//  ActionViewController.swift
//  Extension
//
//  Created by Ashraf Dewan on 3/17/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    //2
    var savedScripts = [String: String]()
    //3
    var writtenScriptsDict = [String: String]()
    var scriptsTitleArray = [String]()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //1
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openScripts))
        //
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    //2
                    self?.loadScript()
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        if let url = URL(string: self!.pageURL) {
                            if let host = url.host {
                                self?.script.text = self?.savedScripts[host]
                            }
                        }
                    }
                    //
                }
            }
        }
    }
    //3
    @objc func openScripts() {
        let ac = UIAlertController(title: "Choose scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Scripts Examples", style: .default) { [weak self] _ in
            self?.myScripts()
        })
        ac.addAction(UIAlertAction(title: "Save scripts", style: .default) { [weak self] _ in
            self?.saveWrittenScripts()
        })
        ac.addAction(UIAlertAction(title: "Load scripts", style: .default) { [weak self] _ in
            self?.writtenScriptsViewController()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func saveWrittenScripts() {
        let ac = UIAlertController(title: "Enter your script name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let scriptTitle = ac.textFields?[0].text else { return }
            guard let scriptText = self?.script.text else { return }
            
            self?.scriptsTitleArray.append(scriptTitle)
            self?.writtenScriptsDict[scriptTitle] = scriptText
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(self?.writtenScriptsDict, forKey: "SavedWrittenScripts")
            userDefaults.set(self?.scriptsTitleArray, forKey: "scriptsTitleArray")
        })
        ac.addAction(UIAlertAction(title: "Load scripts", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func writtenScriptsViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WrittenScriptsViewController") as? WrittenScriptsViewController {
            vc.scriptsDict = writtenScriptsDict
            vc.scriptTitleArray = scriptsTitleArray
            vc.delegate = (self as! LoaderDelegate)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    //1
    func myScripts() {
        let ac = UIAlertController(title: "Loaded scripts", message: nil, preferredStyle: .actionSheet)
        
        for (title, script) in scriptExamples {
            ac.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.script.text = script
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    //2
    func saveScript() {
        if let url = URL(string: pageURL) {
            if let host = url.host {
                savedScripts[host] = script.text
                let userDefaults = UserDefaults.standard
                userDefaults.set(savedScripts, forKey: "SavedScripts")
            }
        }
    }
    
    func loadScript() {
        let userDefaults = UserDefaults.standard
        userDefaults.object(forKey: "SavedScripts") as? [String: String] ?? [String: String]()
        writtenScriptsDict = userDefaults.object(forKey: "SavedWrittenScripts") as? [String: String] ?? [String: String]()
        scriptsTitleArray = userDefaults.object(forKey: "scriptsTitleArray") as? [String] ?? []
    }
    //
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        //2
        saveScript()
        //
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}
