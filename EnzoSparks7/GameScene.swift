//
//  GameScene.swift
//  EnzoSparks7
//
//  Created by Enio Ohmaye on 7/20/14.
//  Copyright (c) 2014 Enio Ohmaye. All rights reserved.
//

import SpriteKit


extension SKShapeNode {
    func grow() {
        self.removeAllActions()
        let action1 = SKAction.scaleBy(2.0, duration: 0.5)
        let action2 = SKAction.scaleBy(0.5, duration: 0.5)
        let action3 = SKAction.waitForDuration(2.0)
        let action4 = SKAction.removeFromParent()
        let actions = SKAction.sequence([action1, action2, action3, action4])
        self.runAction(actions)
    }
    
    func move( toLocation : CGPoint ) {
        removeAllActions()
        position = toLocation
        let action1 = SKAction.waitForDuration(2.0)
        let action2 = SKAction.removeFromParent()
        let actions = SKAction.sequence([action1, action2])
        runAction(actions)
    }
    
    func agitate() {
        self.removeAllActions()
        if let emitter = self.children![0] as? SKEmitterNode {
            let action1 = SKAction.runBlock({ emitter.particleLifetime += 2 })
            let action2 = SKAction.runBlock({ emitter.particleBirthRate = 200 })
            let action3 = SKAction.waitForDuration(2.0)
            let action4 = SKAction.removeFromParent()
            let actions = SKAction.sequence([action1, action2, action3, action4])
            self.runAction(actions)
        }
    }
}

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.blueColor()
    }

    /* Helper functions */
    
    func loadNode<NodeClass> ( name : String) -> NodeClass?  {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "sks")
        let node = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NodeClass
        return node
    }
    
    func addEmitter(location: CGPoint) {
        if let emit = loadNode("BokehEmitter") as? SKEmitterNode {
            let node = SKShapeNode(circleOfRadius: 30)
            node.position = location
            node.addChild(emit)
            emit.position = CGPoint(x: 0, y: 0)
            emit.targetNode = self
            let action1 = SKAction.waitForDuration(2.0)
            let action2 = SKAction.removeFromParent()
            let actions = SKAction.sequence([action1, action2])
            node.runAction(actions)
            self.addChild(node)
        }
    }
    
    enum TouchType {
        case Began
        case Moved
        case Ended
        case Cancelled
    }
    
    func handleTouch( location: CGPoint, touchType: TouchType  ) {

       let node = nodeAtPoint(location) as? SKShapeNode
        var state = ""
        
        switch touchType {
        case .Began:
            state = "Began"
            if !node {
                addEmitter(location)
            } else {
                node!.grow()
            }
            
        case .Moved:
            state = "Moved"
            if node {
                let xDelta = abs( node!.position.x - location.x )
                let yDelta = abs( node!.position.y - location.y )
                if (xDelta > 3 || yDelta > 3) {
                    node!.move(location)
                } else {
                    node!.agitate()
                }
            }
        case .Ended, .Cancelled:
            state = "Ended/Cancelled"
        default:
            state = "Unknown"
        }
        println(state + " : \(location)")
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            handleTouch(location , touchType: .Began)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            handleTouch(location , touchType: .Moved)
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            handleTouch(location , touchType: .Ended)
        }
    }
    
     override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(self)
            handleTouch(location , touchType: .Cancelled)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
