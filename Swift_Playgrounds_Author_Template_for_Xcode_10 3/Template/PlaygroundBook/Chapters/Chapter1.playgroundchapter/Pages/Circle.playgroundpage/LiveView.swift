//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


class GameScene: SKScene {
    
    var mainBall = SKSpriteNode()
    let background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        mainBall.size = CGSize(width: 100, height: 100)
        mainBall.position = CGPoint(x: frame.width / 2, y: frame.height / 7)
        mainBall.color = .random()
        mainBall.zPosition = 3
        self.addChild(mainBall)
        
        background.size = CGSize(width: frame.width, height: frame.height)
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.zPosition = -1
        background.color = .random()
        
        self.addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            background.color = .random()
            mainBall.color = .random()
            
            let smallBall = SKSpriteNode()
            smallBall.color = .random()
            smallBall.position = mainBall.position
            smallBall.size = CGSize(width: 30, height: 30)
            smallBall.physicsBody = SKPhysicsBody(circleOfRadius: smallBall.size.width / 2)
            smallBall.physicsBody?.affectedByGravity = true
            smallBall.zPosition = 1
            
            self.addChild(smallBall)
            
            var dx = CGFloat(location.x - mainBall.position.x)
            var dy = CGFloat(location.y - mainBall.position.y)
            
            let magnitude = sqrt(dx * dx + dy * dy)
            
            dx /= magnitude
            dy /= magnitude
            
            let vector = CGVector(dx: 70.0 * dx, dy: 70.0 * dy)
            
            smallBall.physicsBody?.applyImpulse(vector)
            
        }
    }
    
    
}

class ViewController : UIViewController {
    
    override func loadView() {
        
        let view = SKView(frame: CGRect(x:0 , y:0, width: 1536, height: 2048))
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        self.view = view
        
    }
    
}


PlaygroundPage.current.liveView = ViewController()

