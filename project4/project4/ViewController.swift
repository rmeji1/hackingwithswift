//
//  ViewController.swift
//  project4
//
//  Created by robert on 1/23/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
  var webView : WKWebView!
  var progressView: UIProgressView!
  var websites = ["apple.com", "hackingwithswift.com"]
  
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let url = URL(string:"https://\(websites[0])")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    
    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
    
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

  }
  
  @objc func openTapped(){
    let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
    
    for website in websites {
      ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    // needed for ipad to know where to pin popover.
    ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(ac, animated: true)
  }
  
  func openPage(alert: UIAlertAction){
    let url = URL(string: "https://\(alert.title!)")!
    webView.load(URLRequest(url: url))
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
}

extension ViewController: WKNavigationDelegate{
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url
    
    if let host = url?.host {
      for website in websites {
        if host.contains(website) {
          decisionHandler(.allow)
          return
        }
      }
    }
    
    decisionHandler(.cancel)
  }
}

