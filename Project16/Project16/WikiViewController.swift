//
//  WikiViewController.swift
//  Project16
//
//  Created by Ashraf Dewan on 5/4/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit
import WebKit

class WikiViewController: UIViewController {
    var webView: WKWebView!
    var wikiSite: String!

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: wikiSite)!
        webView.load(URLRequest(url: url))
    }
}
