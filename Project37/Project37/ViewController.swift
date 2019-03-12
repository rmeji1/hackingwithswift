//
//  ViewController.swift
//  Project37
//
//  Created by robert on 3/6/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity

class ViewController: UIViewController {
  
  @IBOutlet weak var graidentView: GradientView!
  @IBOutlet weak var cardContainer: UIView!
  
  var allCards = [CardViewController]()
  var music: AVAudioPlayer!
  
  var lastMessage: CFAbsoluteTime = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    createParticles()
    loadCards()
    view.backgroundColor = UIColor.red
    
    UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
      self.view.backgroundColor = UIColor.blue
    })
    
    playMusic()
    
    if WCSession.isSupported(){
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let instructions = "Please ensure your Apple Watch is configured correctly. On your iPhone, launch Apple's 'Watch' configuration app then choose General > Wake Screen. On that screen, please disable Wake Screen On Wrist Raise, then select Wake For 70 Seconds. On your Apple Watch, please swipe up on your watch face and enable Silent Mode. You're done!"
    let ac = UIAlertController(title: "Adjust your settings", message: instructions, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "I'm Ready", style: .default))
    present(ac, animated: true)
  }
  
  @objc func loadCards(){
    for card in allCards{
      card.view.removeFromSuperview()
      card.removeFromParent()
    }
    allCards.removeAll(keepingCapacity: true)
    view.isUserInteractionEnabled = true
    
    let positions = [
      CGPoint(x: 75, y: 135),
      CGPoint(x: 185, y: 135),
      CGPoint(x: 295, y: 135),
      CGPoint(x: 405, y: 135),
      CGPoint(x: 75, y: 285),
      CGPoint(x: 185, y: 285),
      CGPoint(x: 295, y: 285),
      CGPoint(x: 405, y: 285),
      ]
    
    let circle = UIImage(named: "cardCircle")
    let cross = UIImage(named: "cardCross")
    let lines = UIImage(named: "cardLines")
    let square = UIImage(named: "cardSquare")
    let star = UIImage(named: "cardStar")
    
    var images = [circle, circle, cross, cross, lines, lines, square, star]
    
    for (index, position) in positions.enumerated(){
      let card = CardViewController()
      card.delegate = self
      
      // setups up view controller containment addChild and didMove
      addChild(card)
      cardContainer.addSubview(card.view)
      card.didMove(toParent: self)
      
      card.view.center = position
      card.front.image = images[index]
      
      if card.front.image == star{
        card.isCorrect = true
      }
      
      allCards.append(card)
    }
  }
  
  func cardTapped(_ tapped: CardViewController) {
    guard view.isUserInteractionEnabled == true else { return }
    view.isUserInteractionEnabled = false
    
    for card in allCards {
      if card == tapped {
        card.wasTapped()
        card.perform(#selector(card.wasntTapped), with: nil, afterDelay: 1)
      } else {
        card.wasntTapped()
      }
    }
    
    perform(#selector(loadCards), with: nil, afterDelay: 2)
  }
  
  func createParticles(){
    let emitter = CAEmitterLayer()
    emitter.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
    emitter.emitterShape = .line
    emitter.emitterSize = CGSize(width: view.frame.width, height: 1)
    emitter.renderMode = .additive
    
    let cell = CAEmitterCell()
    cell.birthRate = 2
    cell.lifetime = 5.0
    cell.velocity = 100
    cell.velocityRange = 50
    cell.emissionLongitude = .pi
    cell.spinRange = 5
    cell.scale = 0.5
    cell.scaleRange = 0.25
    cell.color = UIColor(white: 1, alpha: 0.1).cgColor
    cell.alphaSpeed = -0.025
    cell.contents = UIImage(named: "particle")?.cgImage
    emitter.emitterCells = [cell]
    
    graidentView.layer.addSublayer(emitter)
  }
  
  func playMusic() {
    if let musicURL = Bundle.main.url(forResource: "PhantomFromSpace", withExtension: "mp3"){
      if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL){
        music = audioPlayer
        music.numberOfLoops = -1 // continues to loop
        music.play()
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: cardContainer)
    
    for card in allCards{
      if card.view.frame.contains(location){
        if view.traitCollection.forceTouchCapability == .available{
          if touch.force == touch.maximumPossibleForce{
            card.front.image = UIImage(named: "cardStar")
            card.isCorrect = true
          }
        }
        if card.isCorrect {
          sendWatchMessage()
        }
      }
    }
  }
}

extension ViewController: WCSessionDelegate{
  func sendWatchMessage(){
    // current time since 1/1/2001
    let currentTime = CFAbsoluteTimeGetCurrent()
    
    // if less than half a second has passed, bail out
    if lastMessage + 0.5 > currentTime {
      return
    }
    
    // send a message to the watch if it's reachable
    if (WCSession.default.isReachable) {
      // this is a meaningless message, but it's enough for our purposes
      let message = ["Message": "Hello"]
      WCSession.default.sendMessage(message, replyHandler: nil)
    }
    
    // update our rate limiting property
    lastMessage = CFAbsoluteTimeGetCurrent()
  }
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
}
