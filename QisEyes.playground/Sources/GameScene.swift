import SpriteKit
import GameplayKit

public class GameScene: SKScene {
    
    // MARK: - Game State Properties
    private var gameState: GameState = .betting
    private var playerBalance: Int = 3
    private var currentBet: Int = 1
    private var currentLevel: Int = 1
    private var numberOfCups: Int = 3
    private var correctCupIndex: Int = 0
    
    // MARK: - Node Properties
    private var cups: [Cup] = []
    private var tableBackground: SKSpriteNode!
    private var coinNode: SKSpriteNode!
    private var hud: HUD!
    
    // MARK: - Animation Properties
    private var isShuffling: Bool = false
    private var shuffleCount: Int = 0
    private let maxShuffleCount: Int = 8
    
    public override func didMove(to view: SKView) {
        setupScene()
        setupHUD()
        AudioManager.shared.playBackgroundAmbience()
        startNewRound()
    }
    
    // MARK: - Scene Setup
    private func setupScene() {
        // Add tavern atmosphere background
        backgroundColor = SKColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 1.0)
        
        // Create wooden tavern table background
        let woodColor = SKColor(red: 0.4, green: 0.25, blue: 0.1, alpha: 1.0)
        tableBackground = SKSpriteNode(color: woodColor, size: CGSize(width: size.width * 0.9, height: size.height * 0.7))
        tableBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        tableBackground.zPosition = -5
        addChild(tableBackground)
        
        // Add wood grain effect with overlays
        for i in 0..<5 {
            let grainLine = SKSpriteNode(color: SKColor(red: 0.3, green: 0.2, blue: 0.08, alpha: 0.3), 
                                        size: CGSize(width: tableBackground.size.width, height: 4))
            grainLine.position = CGPoint(x: tableBackground.position.x, 
                                       y: tableBackground.position.y - 50 + CGFloat(i * 25))
            grainLine.zPosition = -4
            addChild(grainLine)
        }
        
        // Add tavern wall background
        let wallBackground = SKSpriteNode(color: SKColor(red: 0.25, green: 0.2, blue: 0.15, alpha: 1.0), 
                                         size: CGSize(width: size.width, height: size.height))
        wallBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        wallBackground.zPosition = -10
        addChild(wallBackground)
    }
    
    private func setupHUD() {
        hud = HUD(size: size)
        hud.delegate = self
        hud.updateBalance(playerBalance)
        hud.updateLevel(currentLevel)
        hud.updateBet(currentBet)
        addChild(hud)
    }
    
    // MARK: - Game Flow
    private func startNewRound() {
        gameState = .betting
        hud.showBettingControls()
        setupCups()
    }
    
    private func setupCups() {
        // Reset existing cups or create new ones
        if cups.count == numberOfCups {
            // Reset existing cups
            for cup in cups {
                cup.reset()
            }
        } else {
            // Remove existing cups and create new ones
            cups.forEach { $0.removeFromParent() }
            cups.removeAll()
            
            // Calculate cup positions
            let cupSpacing: CGFloat = 120
            let startX = size.width/2 - (CGFloat(numberOfCups - 1) * cupSpacing / 2)
            let cupY = size.height * 0.6
            
            // Create cups
            for i in 0..<numberOfCups {
                let cup = Cup()
                cup.position = CGPoint(x: startX + CGFloat(i) * cupSpacing, y: cupY)
                cup.cupIndex = i
                addChild(cup)
                cups.append(cup)
            }
        }
    }
    
    private func showCoinPlacement() {
        // Randomly select which cup will have the coin
        correctCupIndex = Int.random(in: 0..<numberOfCups)
        
        // Show coin under the correct cup
        if coinNode != nil {
            coinNode.removeFromParent()
        }
        
        coinNode = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))
        coinNode.position = cups[correctCupIndex].position
        coinNode.position.y -= 40
        coinNode.zPosition = 1
        addChild(coinNode)
        
        // Show coin for 2 seconds
        let showCoinAction = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { [weak self] in
                self?.hideCoinAndStartShuffling()
            }
        ])
        run(showCoinAction)
    }
    
    private func hideCoinAndStartShuffling() {
        coinNode.removeFromParent()
        gameState = .shuffling
        hud.hideBettingControls()
        startShuffling()
    }
    
    private func startShuffling() {
        isShuffling = true
        shuffleCount = 0
        performShuffle()
    }
    
    private func performShuffle() {
        guard shuffleCount < maxShuffleCount else {
            finishShuffling()
            return
        }
        
        // Select two random cups to swap
        let cup1Index = Int.random(in: 0..<numberOfCups)
        var cup2Index = Int.random(in: 0..<numberOfCups)
        while cup2Index == cup1Index {
            cup2Index = Int.random(in: 0..<numberOfCups)
        }
        
        // Update the correct cup index if needed
        if correctCupIndex == cup1Index {
            correctCupIndex = cup2Index
        } else if correctCupIndex == cup2Index {
            correctCupIndex = cup1Index
        }
        
        // Animate the swap
        let cup1 = cups[cup1Index]
        let cup2 = cups[cup2Index]
        
        let cup1OriginalPos = cup1.position
        let cup2OriginalPos = cup2.position
        
        let moveAction1 = SKAction.move(to: cup2OriginalPos, duration: 0.3)
        let moveAction2 = SKAction.move(to: cup1OriginalPos, duration: 0.3)
        
        // Play shuffle sound
        AudioManager.shared.playShuffle()
        
        cup1.run(moveAction1)
        cup2.run(moveAction2) { [weak self] in
            self?.shuffleCount += 1
            
            // Wait a bit before next shuffle
            let waitAction = SKAction.wait(forDuration: 0.2)
            self?.run(waitAction) {
                self?.performShuffle()
            }
        }
        
        // Swap cups in array
        cups.swapAt(cup1Index, cup2Index)
    }
    
    private func finishShuffling() {
        isShuffling = false
        gameState = .guessing
        hud.showGuessingPrompt()
    }
    
    // MARK: - Touch Handling
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if gameState == .guessing && !isShuffling {
            handleCupTap(at: location)
        }
    }
    
    private func handleCupTap(at location: CGPoint) {
        for (index, cup) in cups.enumerated() {
            if cup.contains(location) {
                AudioManager.shared.playTap()
                makeGuess(cupIndex: index)
                break
            }
        }
    }
    
    private func makeGuess(cupIndex: Int) {
        gameState = .revealing
        
        let isCorrect = cupIndex == correctCupIndex
        
        // Reveal all cups
        for (index, cup) in cups.enumerated() {
            if index == correctCupIndex {
                cup.reveal(withCoin: true)
            } else {
                cup.reveal(withCoin: false)
            }
        }
        
        // Handle win/loss after a delay
        let delayAction = SKAction.wait(forDuration: 1.5)
        let resultAction = SKAction.run { [weak self] in
            self?.handleGuessResult(isCorrect: isCorrect)
        }
        run(SKAction.sequence([delayAction, resultAction]))
    }
    
    private func handleGuessResult(isCorrect: Bool) {
        if isCorrect {
            // Player wins double the bet
            playerBalance += currentBet
            AudioManager.shared.playWin()
            hud.showResult(won: true, amount: currentBet * 2)
            currentLevel += 1
            
            // Increase difficulty
            if currentLevel % 3 == 0 && numberOfCups < 6 {
                numberOfCups += 1
            }
        } else {
            // Player loses the bet
            playerBalance -= currentBet
            AudioManager.shared.playLose()
            hud.showResult(won: false, amount: currentBet)
        }
        
        hud.updateBalance(playerBalance)
        hud.updateLevel(currentLevel)
        
        // Check if game over
        if playerBalance <= 0 {
            gameState = .gameOver
            hud.showGameOver()
        } else {
            // Start new round after delay
            let waitAction = SKAction.wait(forDuration: 2.0)
            let newRoundAction = SKAction.run { [weak self] in
                self?.startNewRound()
            }
            run(SKAction.sequence([waitAction, newRoundAction]))
        }
    }
}

// MARK: - HUD Delegate
extension GameScene: HUDDelegate {
    func didChangeBet(to amount: Int) {
        currentBet = min(amount, playerBalance)
        hud.updateBet(currentBet)
    }
    
    func didConfirmBet() {
        if gameState == .betting {
            gameState = .showingCoin
            hud.hideBettingControls()
            showCoinPlacement()
        }
    }
    
    func didRequestNewGame() {
        // Reset game state
        playerBalance = 3
        currentLevel = 1
        numberOfCups = 3
        currentBet = 1
        
        hud.updateBalance(playerBalance)
        hud.updateLevel(currentLevel)
        hud.updateBet(currentBet)
        
        startNewRound()
    }
}

// MARK: - Game States
enum GameState {
    case betting
    case showingCoin
    case shuffling
    case guessing
    case revealing
    case gameOver
}