import AVFoundation
import SpriteKit

public class AudioManager {
    
    // MARK: - Singleton
    public static let shared = AudioManager()
    
    // MARK: - Audio Engine
    private var audioEngine: AVAudioEngine
    private var audioPlayerNode: AVAudioPlayerNode
    
    // MARK: - Audio Buffers (Programmatically Generated)
    private var shuffleSoundBuffer: AVAudioPCMBuffer?
    private var tapSoundBuffer: AVAudioPCMBuffer?
    private var winSoundBuffer: AVAudioPCMBuffer?
    private var loseSoundBuffer: AVAudioPCMBuffer?
    
    private init() {
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        setupAudioEngine()
        generateSounds()
    }
    
    // MARK: - Setup
    private func setupAudioEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    // MARK: - Programmatic Sound Generation
    private func generateSounds() {
        let sampleRate: Double = 44100
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        // Generate shuffle sound (swoosh/wind effect)
        shuffleSoundBuffer = generateSwooshSound(format: format, duration: 0.3)
        
        // Generate tap sound (click)
        tapSoundBuffer = generateClickSound(format: format, duration: 0.1)
        
        // Generate win sound (ascending chime)
        winSoundBuffer = generateWinSound(format: format, duration: 0.8)
        
        // Generate lose sound (descending thud)
        loseSoundBuffer = generateLoseSound(format: format, duration: 0.5)
    }
    
    private func generateSwooshSound(format: AVAudioFormat, duration: Double) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        
        buffer.frameLength = frameCount
        let samples = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            let time = Double(i) / format.sampleRate
            let envelope = sin(Double.pi * time / duration) * exp(-time * 3)
            
            // White noise with filtering
            let noise = Float.random(in: -1...1)
            let frequency = 200 + (1000 * Float(1 - time / duration))
            let wave = sin(2 * Double.pi * Double(frequency) * time)
            
            samples[i] = Float(envelope * wave * 0.3) + (noise * Float(envelope) * 0.1)
        }
        
        return buffer
    }
    
    private func generateClickSound(format: AVAudioFormat, duration: Double) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        
        buffer.frameLength = frameCount
        let samples = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            let time = Double(i) / format.sampleRate
            let envelope = exp(-time * 20)
            let frequency = 800.0
            let wave = sin(2 * Double.pi * frequency * time)
            
            samples[i] = Float(envelope * wave * 0.5)
        }
        
        return buffer
    }
    
    private func generateWinSound(format: AVAudioFormat, duration: Double) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        
        buffer.frameLength = frameCount
        let samples = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            let time = Double(i) / format.sampleRate
            let progress = time / duration
            
            // Ascending chord progression
            let baseFreq = 440.0 + (220.0 * progress) // A4 to A5
            let envelope = sin(Double.pi * time / duration) * exp(-time * 1.5)
            
            let fundamental = sin(2 * Double.pi * baseFreq * time)
            let harmonic2 = sin(2 * Double.pi * baseFreq * 1.25 * time) * 0.5
            let harmonic3 = sin(2 * Double.pi * baseFreq * 1.5 * time) * 0.3
            
            samples[i] = Float(envelope * (fundamental + harmonic2 + harmonic3) * 0.4)
        }
        
        return buffer
    }
    
    private func generateLoseSound(format: AVAudioFormat, duration: Double) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        
        buffer.frameLength = frameCount
        let samples = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            let time = Double(i) / format.sampleRate
            let progress = time / duration
            
            // Descending frequency
            let frequency = 220.0 - (120.0 * progress) // A3 descending
            let envelope = sin(Double.pi * time / duration) * exp(-time * 2)
            
            let wave = sin(2 * Double.pi * frequency * time)
            let subharmonic = sin(2 * Double.pi * frequency * 0.5 * time) * 0.3
            
            samples[i] = Float(envelope * (wave + subharmonic) * 0.5)
        }
        
        return buffer
    }
    
    // MARK: - Public Sound Methods
    public func playShuffle() {
        playSound(buffer: shuffleSoundBuffer)
    }
    
    public func playTap() {
        playSound(buffer: tapSoundBuffer)
    }
    
    public func playWin() {
        playSound(buffer: winSoundBuffer)
    }
    
    public func playLose() {
        playSound(buffer: loseSoundBuffer)
    }
    
    private func playSound(buffer: AVAudioPCMBuffer?) {
        guard let buffer = buffer, audioEngine.isRunning else { return }
        
        // Stop current sound if playing
        if audioPlayerNode.isPlaying {
            audioPlayerNode.stop()
        }
        
        audioPlayerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        audioPlayerNode.play()
    }
    
    // MARK: - Background Music (Simple Ambience)
    public func playBackgroundAmbience() {
        // Generate a subtle crackling fire sound for tavern atmosphere
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        let frameCount = AVAudioFrameCount(format.sampleRate * 10) // 10 seconds
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount
        let samples = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            // Generate crackling noise
            let noise = Float.random(in: -1...1)
            let filtered = noise * 0.05 * Float.random(in: 0.5...1.0)
            samples[i] = filtered
        }
        
        // Loop the ambience
        audioPlayerNode.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
        if !audioPlayerNode.isPlaying {
            audioPlayerNode.play()
        }
    }
    
    public func stopAllSounds() {
        audioPlayerNode.stop()
    }
}