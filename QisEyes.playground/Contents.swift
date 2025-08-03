import UIKit
import SpriteKit
import PlaygroundSupport

// MARK: - Main Playground Setup
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
let scene = GameScene(size: CGSize(width: 768, height: 1024))
scene.scaleMode = .aspectFill

sceneView.presentScene(scene)
sceneView.ignoresSiblingOrder = true
sceneView.showsFPS = true
sceneView.showsNodeCount = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView