# XenonAI

XenonAI is a SwiftUI-based Apple platform app that provides an elegant interface for composing prompts and interacting with AI features. The UI focuses on a lightweight, glass-effect input field and system iconography to deliver a modern experience consistent with Apple design guidelines.

## Features
- Clean, minimal prompt input with submit handling
- SwiftUI-first architecture with state-driven updates
- System iconography and adaptive colors (e.g., secondary tint)
- Glass background effect for a contemporary look and feel

## Tech Stack
- Swift 6 / SwiftUI
- Apple platform UI patterns (e.g., `glassBackgroundEffect()`)
- Xcode 26+

## Architecture Overview
XenonAI follows a modular SwiftUI approach composed of small, focused views. A key component is `PromptUI`, a reusable view that encapsulates user input and submission behavior.

### PromptUI
`PromptUI` is a SwiftUI view that renders a compact prompt field with a sparkles icon. It exposes an `onSubmit` closure to pass the user's text to upstream logic.

Key behaviors:
- Maintains local input state via `@State var promptText: String`
- Calls `onSubmit(promptText)` when the user presses Return or submits the field
- Uses `glassBackgroundEffect()` for a subtle translucent background
- Designed to fit compact layouts (`frame(width: 320, height: 36)`) and embed in toolbars or footers

Example usage:
```swift
PromptUI { text in
    // Handle submitted text here, e.g., send to your view model or AI service
}
