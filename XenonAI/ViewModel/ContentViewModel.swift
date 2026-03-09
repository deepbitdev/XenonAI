//
//  ContentViewModel.swift
//  XenonAI
//
//  Created by Dre Smith on 1/8/26.
//

import Foundation
import Combine
import FoundationModels
import AVFoundation

enum AnimationState: String {
    case idle = "idle"
    case thinking = "thinking"
    case talking = "talking"
}

class ContentViewModel: ObservableObject {
    
    let llmService: LLMService
    let textToSpeechService: TextToSpeechService
    
    @Published var animationState: AnimationState = .idle
    
    init(
        llmService: LLMService = .init(
            session: LanguageModelSession(instructions: String.modelInstructions)
        ),
        textToSpeechService: TextToSpeechService = .init(synthesizer: .init()))
    {
        self.llmService = llmService
        self.textToSpeechService = textToSpeechService
        
        // Observer for being notified when speech ends
        textToSpeechService.finishedSpeaking
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // Gets called when the speech ends
                self?.animationState = .idle
            }
    }
    
    func respondToPrompt(prompt: String) {
        
        Task {
            animationState = .thinking
            // Brain: Process the prompt and generate a response
            guard let aiOutputText = await llmService.response(to: prompt) else {
                animationState = .idle
                return
            }
            
            // Voice: Convert the response to speech
            textToSpeechService.speak(text: aiOutputText)
            animationState = .talking
        }
    }
}
