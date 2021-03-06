//
//  ViewController.swift
//  project25
//
//  Created by robert on 2/19/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
  var images = [UIImage]()
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    
    peerID = MCPeerID(displayName: UIDevice.current.name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = self
  }
  
  
  @objc func showConnectionPrompt(){
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
    ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }

  @objc func importPicture(){
    // create picker, allows editing, set delegate, present
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @objc func startHosting(action: UIAlertAction){
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant.start()
  }
  @objc func joinSession(action: UIAlertAction){
    let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  // datasoure
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    
    if let imageView = cell.viewWithTag(1000) as? UIImageView{
      imageView.image = images[indexPath.item]
    }
    
    return cell
  }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate,MCSessionDelegate, MCBrowserViewControllerDelegate{
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case MCSessionState.connected:
      print("Connected: \(peerID.displayName)")
      
    case MCSessionState.connecting:
      print("Connecting: \(peerID.displayName)")
      
    case MCSessionState.notConnected:
      print("Not Connected: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let image = UIImage(data: data) {
      DispatchQueue.main.async { [unowned self] in
        self.images.insert(image, at: 0)
        self.collectionView?.reloadData()
      }
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // get image, dismiss pickerController, insert image to array, reload collection view
    guard let image = info[.editedImage] as? UIImage else { return }
    picker.dismiss(animated: true)
    
    images.insert(image, at: 0)
    collectionView.reloadData()
  }
}
