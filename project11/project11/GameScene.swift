//
//  GameScene.swift
//  project11
//
//  Created by robert on 2/8/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  var scoreLabel: SKLabelNode!
  var editLabel: SKLabelNode!
  
  var score = 0{
    didSet{
      scoreLabel.text = "Score \(score)"
    }
  }
  
  var editingMode = false {
    didSet{
      if editingMode{
        editLabel.text = "Done"
      }else{
        editLabel.text = "Edit"
      }
    }
  }
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background.jpg")
    background.blendMode = .replace
    background.position = CGPoint(x: 512, y: 384)
    background.zPosition = -1 // tells it to draw behind everything else
    addChild(background)
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    
    for x in 0...4{
      makeBouncer(at: CGPoint(x: x*256, y:0))
    }
    
    makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
    makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    
    physicsWorld.contactDelegate = self
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.position = CGPoint(x: 980, y: 700)
    addChild(scoreLabel)
    
    editLabel = SKLabelNode(fontNamed:"Chalkduster")
    editLabel.text = "Edit"
    editLabel.position = CGPoint(x: 80, y: 700)
    addChild(editLabel)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.location(in: self)
      let objects = nodes(at: location)
      
      if objects.contains(editLabel){
        editingMode = !editingMode
      }else{
        if editingMode {
          //creates box
          let size = CGSize(width: Int.random(in: 16...128), height: 16)
          let boxColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
          let box = SKSpriteNode(color: boxColor, size: size)
          box.zRotation = CGFloat.random(in: 0...3)
          box.position = location
          
          box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
          box.physicsBody?.isDynamic = false
          addChild(box)
        }else{
          let ball = SKSpriteNode(imageNamed: "ballRed")
          ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
          ball.physicsBody?.restitution = 0.4
          ball.position = location
          ball.name = "ball"
          ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
          addChild(ball)
        }
      }
    }
  }
  
  func makeBouncer(at position: CGPoint){
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
    bouncer.physicsBody?.isDynamic = false // when true object will be moved based on gravity and collions
    addChild(bouncer)
  }
  
  /// Loads slot base graphic, positions, and add to screen
  func makeSlot(at position: CGPoint, isGood: Bool){
    let slotBase: SKSpriteNode
    let slotGlow: SKSpriteNode

    if isGood{
      slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotBase.name = "good"
    }else{
      slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotBase.name = "bad"
    }
    
    slotBase.position = position
    slotGlow.position = position
    
    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false
    
    addChild(slotBase)
    addChild(slotGlow)
    
    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForver = SKAction.repeatForever(spin)
    slotGlow.run(spinForver)
  }
  
}

extension GameScene: SKPhysicsContactDelegate{
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }

    if contact.bodyA.node?.name == "ball"{
      collisionBetween(ball: nodeA, object: nodeB)
    }else if contact.bodyB.node?.name == "ball"{
      collisionBetween(ball: nodeB, object: nodeA)
    }
  }
  
  func collisionBetween(ball: SKNode, object: SKNode) {
    if object.name == "good"{
      destroy(ball:ball)
      score += 1
    }else if object.name == "bad"{
      destroy(ball:ball)
      score -= 1
    }
  }
  
  func destroy(ball: SKNode){
    if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
      fireParticles.position = ball.position
      addChild(fireParticles)
    }
    ball.removeFromParent()
  }
}
