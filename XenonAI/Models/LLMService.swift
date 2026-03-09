//
//  LLMService.swift
//  XenonAI
//
//  Created by Dre Smith on 1/7/26.
//

import Foundation
import FoundationModels

class LLMService {
    
    let session: LanguageModelSession
    
    init(session: LanguageModelSession) {
        self.session = session
    }
    
//    func response(to prompt: String) async -> String? {
//        if session.isResponding { return nil }
//        let response = try? await session.respond(to: prompt)
//        return response?.content
//    }
    
    func response(to prompt: String) async -> String? {
        let model = await SystemLanguageModel.default
        guard case .available = model.availability else {
            print("Model is not ready: \(model.availability)")
            return nil
        }
        
        if session.isResponding { return nil }
        
        do {
            let response = try await session.respond(to: prompt)
            return response.content
        } catch {
            print("LLM Error: \(error.localizedDescription)")
            return nil
        }
    }
}
