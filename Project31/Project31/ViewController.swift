//
//  ViewController.swift
//  Project31
//
//  Created by robert on 3/1/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
  @IBOutlet weak var addressBar: UITextField!
  @IBOutlet weak var stackView: UIStackView!
  
  weak var activeWebView: WKWebView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDefaultTitle()
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
    let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
    navigationItem.rightBarButtonItems = [delete,add]
    
  }
  
  private func updateUI(for webView: WKWebView) {
    title = webView.title
    addressBar.text = webView.url?.absoluteString ?? ""
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.horizontalSizeClass == .compact{
      stackView.axis = .vertical
    }else{
      stackView.axis = .horizontal
    }
  }
  @objc private func deleteWebView(){
    if let webView = activeWebView{
      if let index = stackView.arrangedSubviews.index(of: webView){
        stackView.removeArrangedSubview(webView)
        webView.removeFromSuperview() // this is important
        
        if stackView.arrangedSubviews.count == 0 {
          setDefaultTitle()
        }else{
          var currentIndex = Int(index)
          if currentIndex == stackView.arrangedSubviews.count {
            currentIndex = stackView.arrangedSubviews.count - 1
          }
          if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
            selectWebView(newSelectedWebView)
          }
        }
      }
    }
  }
  
  @objc private func addWebView(){
    let webView = WKWebView()
    webView.navigationDelegate = self
    
    stackView.addArrangedSubview(webView)

    let url = URL(string: "https://www.hackingwithswift.com")!
    webView.load(URLRequest(url: url))
    
    webView.layer.borderColor = UIColor.blue.cgColor
    selectWebView(webView)
    
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
    recognizer.delegate = self
    webView.addGestureRecognizer(recognizer)
  }
  
  @objc private func webViewTapped(_ recognizer: UITapGestureRecognizer){
    if let selectedWebView = recognizer.view as? WKWebView{
      selectWebView(selectedWebView)
    }
  }
  
  private func selectWebView(_ webView: WKWebView){
    stackView.arrangedSubviews.forEach {
      $0.layer.borderWidth = 0
    }
    
    webView.layer.borderWidth = 3
    activeWebView = webView
    updateUI(for: webView)
  }
  
  private func setDefaultTitle(){
    title = "Multi Browser"
  }
}

extension ViewController: UIGestureRecognizerDelegate{
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

extension ViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let activeWebView = activeWebView, let address = textField.text{
      if let url = URL(string: address){
        activeWebView.load(URLRequest(url: url))
      }
    }
    
    textField.resignFirstResponder()
    return true
  }
}

extension ViewController: WKNavigationDelegate{
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView == activeWebView {
      updateUI(for: webView)
    }
  }
}
