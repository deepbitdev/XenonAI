//
//  PromptUI.swift
//  XenonAI
//
//  Created by Dre Smith on 1/8/26.
//

import SwiftUI

struct PromptUI: View {
    @State var promptText: String = ""
    let onSubmit: (String) -> Void
    
    var body: some View {
        HStack {
//            Image(systemName: "sparkles" .foregroundStyle(.secondary))
            
            Image(systemName: "sparkles".cleanUpForSpeech).foregroundColor(.secondary)
            TextField("Enter your thoughts...", text: $promptText)
                .onSubmit {
                    onSubmit(promptText)
                }
        }
        .padding(10)
        .glassBackgroundEffect()
        .frame(width: 320, height: 36)
    }
}

//#Preview {
//    PromptUI(onSubmit: { _ in })
//}
