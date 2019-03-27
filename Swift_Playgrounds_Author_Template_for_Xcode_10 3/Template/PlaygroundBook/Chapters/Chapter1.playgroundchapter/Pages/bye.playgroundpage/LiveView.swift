//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let helloNode = SKLabelNode()
    
    let background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        background.size = frame.size
        
        self.addChild(background)
        
        
        helloNode.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        helloNode.fontSize = 200
        helloNode.fontName = "Helvetica Neue"
        helloNode.text = "Bye👋"
        helloNode.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        helloNode.zPosition = 100
        
        self.addChild(helloNode)
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0),
                                           .fadeOut(withDuration: 2.0)])
        helloNode.run(.repeatForever(fadeInOut))
        
        let string = "I hope you liked my playground, hope we meet at WWDC 2019."
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
    }
    
    
    
}

class ViewController : UIViewController {
    
    override func loadView() {
        
        let view = SKView(frame: CGRect(x:0 , y:0, width: 1536, height: 2048))
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        //
        //// Present the scene
        view.presentScene(scene)
        self.view = view
        
    }
    
}



PlaygroundPage.current.liveView = ViewController()
