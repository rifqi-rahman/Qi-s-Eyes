import SpriteKit

public protocol HUDDelegate: AnyObject {
    func didChangeBet(to amount: Int)
    func didConfirmBet()
    func didRequestNewGame()
}

public class HUD: SKNode {
    
    // MARK: - Delegate
    public weak var delegate: HUDDelegate?
    
    // MARK: - UI Elements
    private var balanceLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var betLabel: SKLabelNode!
    private var messageLabel: SKLabelNode!
    
    // Betting Controls
    private var betMinus: SKLabelNode!
    private var betPlus: SKLabelNode!
    private var confirmBet: SKLabelNode!
    private var bettingContainer: SKNode!
    
    // Game Over Controls
    private var newGameButton: SKLabelNode!
    
    // MARK: - Properties
    private let sceneSize: CGSize
    private var currentBet: Int = 1
    
    public init(size: CGSize) {
        self.sceneSize = size
        super.init()
        setupHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupHUD() {
        setupTopBar()
        setupBettingControls()
        setupMessageArea()
        setupNewGameButton()
    }
    
    private func setupTopBar() {
        // Background for top bar
        let topBarBG = SKSpriteNode(color: SKColor(red: 0.2, green: 0.1, blue: 0.05, alpha: 0.8), 
                                   size: CGSize(width: sceneSize.width, height: 100))
        topBarBG.position = CGPoint(x: sceneSize.width/2, y: sceneSize.height - 50)
        topBarBG.zPosition = 100
        addChild(topBarBG)
        
        // Balance Label
        balanceLabel = SKLabelNode(fontNamed: "Chalkduster")
        balanceLabel.fontSize = 24
        balanceLabel.fontColor = .yellow
        balanceLabel.text = "Coins: $3"
        balanceLabel.position = CGPoint(x: 100, y: sceneSize.height - 60)
        balanceLabel.zPosition = 101
        addChild(balanceLabel)
        
        // Level Label
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.fontSize = 24
        levelLabel.fontColor = .white
        levelLabel.text = "Level: 1"
        levelLabel.position = CGPoint(x: sceneSize.width - 100, y: sceneSize.height - 60)
        levelLabel.zPosition = 101
        addChild(levelLabel)
        
        // Current Bet Label
        betLabel = SKLabelNode(fontNamed: "Chalkduster")
        betLabel.fontSize = 20
        betLabel.fontColor = .orange
        betLabel.text = "Bet: $1"
        betLabel.position = CGPoint(x: sceneSize.width/2, y: sceneSize.height - 60)
        betLabel.zPosition = 101
        addChild(betLabel)
    }
    
    private func setupBettingControls() {
        bettingContainer = SKNode()
        bettingContainer.zPosition = 102
        addChild(bettingContainer)
        
        // Betting background
        let bettingBG = SKSpriteNode(color: SKColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.9),
                                    size: CGSize(width: 300, height: 80))
        bettingBG.position = CGPoint(x: sceneSize.width/2, y: 150)
        bettingContainer.addChild(bettingBG)
        
        // Bet Minus Button
        betMinus = createButton(text: "- $1", color: .red)
        betMinus.position = CGPoint(x: sceneSize.width/2 - 80, y: 150)
        bettingContainer.addChild(betMinus)
        
        // Bet Plus Button
        betPlus = createButton(text: "+ $1", color: .green)
        betPlus.position = CGPoint(x: sceneSize.width/2 + 80, y: 150)
        bettingContainer.addChild(betPlus)
        
        // Confirm Bet Button
        confirmBet = createButton(text: "PLACE BET", color: .blue)
        confirmBet.position = CGPoint(x: sceneSize.width/2, y: 100)
        bettingContainer.addChild(confirmBet)
    }
    
    private func setupMessageArea() {
        messageLabel = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel.fontSize = 28
        messageLabel.fontColor = .white
        messageLabel.text = "Place your bet!"
        messageLabel.position = CGPoint(x: sceneSize.width/2, y: sceneSize.height/2 + 100)
        messageLabel.zPosition = 103
        addChild(messageLabel)
    }
    
    private func setupNewGameButton() {
        newGameButton = createButton(text: "NEW GAME", color: .purple)
        newGameButton.position = CGPoint(x: sceneSize.width/2, y: 200)
        newGameButton.zPosition = 104
        newGameButton.isHidden = true
        addChild(newGameButton)
    }
    
    private func createButton(text: String, color: SKColor) -> SKLabelNode {
        let button = SKLabelNode(fontNamed: "Chalkduster")
        button.fontSize = 18
        button.fontColor = color
        button.text = text
        
        // Add button background
        let buttonBG = SKSpriteNode(color: SKColor(white: 0.2, alpha: 0.8),
                                   size: CGSize(width: button.frame.width + 20, height: button.frame.height + 10))
        buttonBG.zPosition = -1
        button.addChild(buttonBG)
        
        return button
    }
    
    // MARK: - Public Interface
    public func updateBalance(_ balance: Int) {
        balanceLabel.text = "Coins: $\(balance)"
        
        // Animate balance change
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        balanceLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }
    
    public func updateLevel(_ level: Int) {
        levelLabel.text = "Level: \(level)"
        
        // Animate level change
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        levelLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }
    
    public func updateBet(_ bet: Int) {
        currentBet = bet
        betLabel.text = "Bet: $\(bet)"
    }
    
    public func showBettingControls() {
        bettingContainer.isHidden = false
        messageLabel.text = "Place your bet!"
        messageLabel.fontColor = .white
    }
    
    public func hideBettingControls() {
        bettingContainer.isHidden = true
    }
    
    public func showGuessingPrompt() {
        messageLabel.text = "Tap a cup to guess!"
        messageLabel.fontColor = .cyan
        
        // Pulse animation
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let pulse = SKAction.sequence([fadeOut, fadeIn])
        messageLabel.run(SKAction.repeatForever(pulse))
    }
    
    public func showResult(won: Bool, amount: Int) {
        messageLabel.removeAllActions()
        messageLabel.alpha = 1.0
        
        if won {
            messageLabel.text = "YOU WON $\(amount)!"
            messageLabel.fontColor = .green
        } else {
            messageLabel.text = "YOU LOST $\(amount)"
            messageLabel.fontColor = .red
        }
        
        // Flash animation
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        messageLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }
    
    public func showGameOver() {
        messageLabel.removeAllActions()
        messageLabel.alpha = 1.0
        messageLabel.text = "GAME OVER!"
        messageLabel.fontColor = .red
        
        newGameButton.isHidden = false
        
        // Game over animation
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let gameOverPulse = SKAction.sequence([fadeOut, fadeIn])
        messageLabel.run(SKAction.repeatForever(gameOverPulse))
    }
    
    // MARK: - Touch Handling
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !bettingContainer.isHidden {
            if betMinus.contains(location) {
                AudioManager.shared.playTap()
                decreaseBet()
            } else if betPlus.contains(location) {
                AudioManager.shared.playTap()
                increaseBet()
            } else if confirmBet.contains(location) {
                AudioManager.shared.playTap()
                delegate?.didConfirmBet()
            }
        }
        
        if !newGameButton.isHidden && newGameButton.contains(location) {
            AudioManager.shared.playTap()
            newGameButton.isHidden = true
            delegate?.didRequestNewGame()
        }
    }
    
    private func decreaseBet() {
        if currentBet > 1 {
            delegate?.didChangeBet(to: currentBet - 1)
            
            // Button press animation
            let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            betMinus.run(SKAction.sequence([scaleDown, scaleUp]))
        }
    }
    
    private func increaseBet() {
        delegate?.didChangeBet(to: currentBet + 1)
        
        // Button press animation
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.1)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
        betPlus.run(SKAction.sequence([scaleDown, scaleUp]))
    }
}