//
//  DetailViewController.swift
//  Project7
//
//  Created by robert on 2/7/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
  var webView: WKWebView!
  var detailItem: Petition?
  
  
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // creates an early return if critical data isn't meant or avaible which is
    // required to contiune.
    guard let detailItem = detailItem else { return }
    let html = """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style> body { font-size: 150%; } </style>
    </head>
    <body>
    \(detailItem.body)
    </body>
    </html>
    """
    
    webView.loadHTMLString(html, baseURL: nil)
  }
}
