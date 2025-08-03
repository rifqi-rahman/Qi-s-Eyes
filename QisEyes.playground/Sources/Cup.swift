import SpriteKit

public class Cup: SKNode {
    
    // MARK: - Properties
    public var cupIndex: Int = 0
    private var cupState: CupState = .closed
    private var cupBody: SKSpriteNode!
    private var coinSprite: SKSpriteNode?
    
    // MARK: - Visual Properties
    private let cupSize = CGSize(width: 80, height: 80)
    
    public override init() {
        super.init()
        setupCup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCup() {
        // Create the cup body (closed state)
        cupBody = SKSpriteNode(color: .gray, size: cupSize)
        cupBody.zPosition = 2
        
        // Add medieval cup styling
        let cupColor = SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // Bronze-like color
        cupBody.color = cupColor
        
        // Add a border to make it look more cup-like
        let border = SKShapeNode(rect: CGRect(x: -cupSize.width/2, y: -cupSize.height/2, 
                                            width: cupSize.width, height: cupSize.height))
        border.strokeColor = SKColor(red: 0.4, green: 0.2, blue: 0.1, alpha: 1.0)
        border.lineWidth = 3
        border.fillColor = .clear
        border.zPosition = 3
        
        addChild(cupBody)
        addChild(border)
        
        // Add subtle shadow
        let shadow = SKSpriteNode(color: .black, size: CGSize(width: cupSize.width + 4, height: cupSize.height + 4))
        shadow.alpha = 0.3
        shadow.position = CGPoint(x: 2, y: -2)
        shadow.zPosition = 1
        addChild(shadow)
    }
    
    // MARK: - Cup Actions
    public func reveal(withCoin: Bool) {
        cupState = withCoin ? .openWithCoin : .open
        
        // Animate cup opening
        let liftAction = SKAction.moveBy(x: 0, y: 30, duration: 0.3)
        let scaleAction = SKAction.scale(to: 0.9, duration: 0.3)
        let combinedAction = SKAction.group([liftAction, scaleAction])
        
        cupBody.run(combinedAction)
        
        if withCoin {
            showCoin()
        }
        
        // Change cup appearance to show it's open
        cupBody.color = SKColor(red: 0.5, green: 0.3, blue: 0.15, alpha: 0.8)
    }
    
    private func showCoin() {
        if coinSprite == nil {
            coinSprite = SKSpriteNode(color: .yellow, size: CGSize(width: 35, height: 35))
            coinSprite!.zPosition = 2
            
            // Make coin look more coin-like
            let goldColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
            coinSprite!.color = goldColor
            
            // Add coin border
            let coinBorder = SKShapeNode(circleOfRadius: 17.5)
            coinBorder.strokeColor = SKColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0)
            coinBorder.lineWidth = 2
            coinBorder.fillColor = .clear
            coinBorder.zPosition = 3
            coinSprite!.addChild(coinBorder)
            
            addChild(coinSprite!)
            
            // Animate coin appearance
            coinSprite!.setScale(0)
            let scaleUpAction = SKAction.scale(to: 1.0, duration: 0.4)
            let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.4)
            let combinedAction = SKAction.group([scaleUpAction, rotateAction])
            
            coinSprite!.run(combinedAction)
        }
    }
    
    public func reset() {
        cupState = .closed
        
        // Reset cup position and appearance
        cupBody.position = CGPoint.zero
        cupBody.setScale(1.0)
        cupBody.color = SKColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        
        // Remove coin if present
        coinSprite?.removeFromParent()
        coinSprite = nil
    }
    
    // MARK: - Touch Detection
    public override func contains(_ point: CGPoint) -> Bool {
        let cupFrame = CGRect(x: position.x - cupSize.width/2, 
                             y: position.y - cupSize.height/2,
                             width: cupSize.width, 
                             height: cupSize.height)
        return cupFrame.contains(point)
    }
    
    // MARK: - Animation Effects
    public func playHoverEffect() {
        guard cupState == .closed else { return }
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let hoverAction = SKAction.sequence([scaleUp, scaleDown])
        
        cupBody.run(hoverAction)
    }
}

// MARK: - Cup States
enum CupState {
    case closed
    case open
    case openWithCoin
}