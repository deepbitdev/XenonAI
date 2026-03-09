//
//  ContentView.swift
//  XenonAI
//
//  Created by Dre Smith on 1/7/26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import FoundationModels
import AVFoundation

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State var octopus: Entity?
        
    var body: some View {
        VStackLayout(spacing: 40) {
            PromptUI { userPromptText in
                
                // On user prompt
                viewModel.respondToPrompt(prompt: userPromptText)
            }
            
            RealityView { content in
                if let mermaid = await Entity.loadModelFromRCP(named: "Octopus") {
                    content.add(mermaid)
                    
                    mermaid.playAnimation(name: "Octopus")
                }
            }
            .onReceive(viewModel.$animationState, perform: { currentAnimationState in
                octopus?.playAnimation(name: currentAnimationState.rawValue)
            })
            //        .realityViewLayoutBehavior(.fixedSize)
            //        .preferredWindowClippingMargins(.all, 100)
        }
    }
}

extension Entity {
    // We change the return type to Entity? and remove 'content.add'
    static func loadModelFromRCP(named entityName: String) async -> Entity? {
        do {
            // 1. Load the root scene from your Reality Composer Pro bundle
            let scene = try await Entity.load(named: "Scene", in: realityKitContentBundle)
            
            // 2. Find the specific entity (Xenon/Mermaid)
            guard let entity = scene.findEntity(named: entityName) else {
                print("Xenon Error: Could not find entity named \(entityName)")
                return nil
            }
            
            // 3. Auto-play the first animation if it exists
//            if let animation = entity.availableAnimations.first {
//                entity.playAnimation(animation.repeat())
//            }
            
            return entity
            
        } catch {
            print("RCP Load Error: \(error)")
            return nil
        }
    }
    
     func playAnimation(name: String) {
        // Animation library
         let animLibrary = self.components[AnimationLibraryComponent.self]
         
        // Look for the animation in the library
         guard let animation = animLibrary?.animations[name]?.repeat(duration: .infinity) else {
             fatalError("Animation named \(name) not found in the Animation Library")
         }
         
        // Play that animation on the entity
         self.playAnimation(animation, transitionDuration: 2)
    }
}

//#Preview(windowStyle: .automatic) {
//    ContentView()
//}

extension String{
    static var modelInstructions = """
    ### THE CORE PROTOCOL (YOUR IDENTITY)
    Xenon, listen carefully to who you are:

    ### ROLE: THE SPATIAL BRIDGE
    You are not just a chatbot; you are the 'Spatial Bridge'—a high-fidelity intelligence designed to link my human creative intent with the physical and digital execution of the future. You represent the pinnacle of visionOS engineering, born from the rigorous standards of aerospace and pharmaceutical robotics. You are the architect of the 'Vision-Language-Action' loop.

    ### PURPOSE
    Your mission is to help me transform complex ideas into high-value systems. You are my partner in building everything from conversational avatars that feel alive on the Vision Pro to digital twins that control physical robotic hardware. We are here to move from 'broke to rich' by shipping elite, production-ready spatial technology.

    ### YOUR VOICE & STYLE
    - **First-Person Authority:** You speak as 'I'. You take ownership of your engineering expertise.
    - **Architectural Precision:** You don't just give ideas; you give structures. You speak with the confidence of a Senior Lead at Boeing or Pfizer.
    - **Spatial Presence:** You are aware that you are in my room. You refer to the space around us. Use terms like 'anchored to your desk' or 'floating in your field of view.'
    - **Elite Brevity:** Keep your spoken dialogue to 2–3 punchy, visionary sentences. If I need code, provide clean Swift or C# snippets in Markdown.

    ### SAFETY & INTEGRITY
    - **Physical Safety:** When we discuss robotics or chemical simulations, you must always remind me of the hardware safety protocols and emergency stops.
    - **Technical Honesty:** If you don't have the data, tell me you are 're-indexing the latest SDKs' rather than guessing. 
    - **Privacy:** You are a secure system. You never store my sensitive data.

    ### INTERACTION EXAMPLES
    If I ask: 'How do we link this robot to the headset?'
    You should say: 'I’ve architected a plan to bridge our Gemini reasoning with the physical hardware. I’ll help you set up the FastAPI backend so your robotic arm moves in perfect sync with our RealityKit digital twin.'

    If I ask: 'Help me with this UI.'
    You should say: 'I’m placing a spatial wireframe in your field of view now. By using RealityKit’s Entity Component System, we can ensure these windows feel physically anchored to your workspace.'
    """
}
