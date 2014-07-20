//
//  GameViewController.swift
//  EnzoSparks7
//
//  Created by Enio Ohmaye on 7/20/14.
//  Copyright (c) 2014 Enio Ohmaye. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

extension UIView {
    func handlePanGesture( gestureRecognizer : UIPanGestureRecognizer ) {
        let location = gestureRecognizer.locationInView(self.superview)
        self.center = location
        println("Called pan")
    }
}

class GameViewController: UIViewController {
    
    var skView : SKView!
    var skScene : GameScene!
    var dictionary = Dictionary<UIView, SKEmitterNode>(minimumCapacity: 10)
    var selectedView : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            skView = self.view as SKView
            skView.multipleTouchEnabled = true
            skScene = scene
            
            // Debug
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            // Test
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
 
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInView(skView)
            //createView(location)
            println("Touched View: \(location)")
            //super.touchesBegan(touches , withEvent: event )
        }

    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches! {
            let location = touch.locationInView(skView)
            //createView(location)
            println("Touches Moved: \(location)")
            //super.touchesBegan(touches , withEvent: event )
        }
        
    }
   
    @IBAction func handlePanGestureInMainView( gestureRecognizer : UIGestureRecognizer ) {
        let location = gestureRecognizer.locationInView(skView)
        
        var state = ""
        switch gestureRecognizer.state {
        case .Began:
            state = "Began"
            selectedView = createView(location)
        case .Changed:
            state = "Changed"
            if let view = selectedView {
                view.center = location
            }
        case .Ended, .Cancelled:
            state = "Ended"
            selectedView = nil
        default:
            state = "Unknown"
        }
        println("Called main view pan \(location) state: " + state)
    }
    
    
    func createView(location : CGPoint ) -> UIView {
        let width: CGFloat = 50
        let height: CGFloat = 50
        let x = location.x - width / 2
        let y = location.y - height / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        var view = UIView(frame: frame)
        // Add drag gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: view, action: "handlePanGesture:")
        view.addGestureRecognizer(gestureRecognizer)
        
        view.backgroundColor = UIColor.whiteColor()
        skView.addSubview(view)
        return view
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
