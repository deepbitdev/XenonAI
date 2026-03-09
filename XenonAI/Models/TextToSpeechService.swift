//
//  TextToSpeechService.swift
//  XenonAI
//
//  Created by Dre Smith on 1/8/26.
//

import Foundation
import AVFoundation
import Combine

class TextToSpeechService: NSObject {
    
    let synthesizer: AVSpeechSynthesizer
    let finishedSpeaking = PassthroughSubject<Void, Never>()
    
    init(synthesizer: AVSpeechSynthesizer) {
        self.synthesizer = synthesizer
        super.init()
        self.synthesizer.delegate = self
    }
    
    var superStarVoice: AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.voiceTraits == .isNoveltyVoice }
        print("Available voices: \(voices.map { $0.name })")
        let superStarvoice = voices.filter { $0.name == "Superstar" }.first
        return superStarvoice
    }
    
    func speak(text: String) {
        // 1. Filter Text
        let filteredText = text.cleanUpForSpeech // concerts raw string into cleaned string
        
        
        // 2. Speech utterance (voice, rate, pitch)
        let utterance = AVSpeechUtterance(string: filteredText)
        utterance.pitchMultiplier = 0.05
        utterance.voice = superStarVoice
        utterance.rate = 0.53
        
        // 3. Speak
        synthesizer.speak(utterance)
        
    }
}

extension TextToSpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Finished speaking")
        finishedSpeaking.send()
    }
}
extension String {
    var cleanUpForSpeech: String {
        var newString = ""
        for char in self {
            //Replace colons and dashes with commas
            if char == ":" || char == "-" {
                newString += ", "
            // Letters, numberss, whitespaces, comma, period, and apostrophe are kept
            } else if char.isLetter || char.isNumber || char.isWhitespace || char == "." || char == "'" {
                newString.append(char)
            }
            // All other characters are skipped/removed
        }
        return newString
    }
}
