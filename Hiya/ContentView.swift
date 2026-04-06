//
//  ContentView.swift
//  Hiya
//
//  Created by Jasmine Kaur on 31/03/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    
    private var largeLanguageModel = SystemLanguageModel.default
    private var session = LanguageModelSession()
    
    @State private var response: String = ""
    @State private var isLoading: Bool = false
    var body: some View {
        VStack {
            
            Spacer()
            
            switch largeLanguageModel.availability {
            case .available:
                if response.isEmpty {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Tap the button to get fun response")
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                            .font(.title)
                    }
                } else {
                    Text(response)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                }
            case .unavailable(.appleIntelligenceNotEnabled):
                Text("Please enable Apple Intelligence in settings")
            case .unavailable(.deviceNotEligible):
                Text("Your device is not eligible for Apple Intelligence")
            case .unavailable(.modelNotReady):
                Text("AI model is not ready ")
            case .unavailable(_):
                Text("AI feature is not available due to unknown reason")
            }
            
            Spacer()
            
            Button {
                // action
                Task {
                    isLoading = true
                    defer { isLoading = false }
                    
                    let prompt = "Say hi in a fun way"
                    
                    do {
                        let replay = try await session.respond(to: prompt)
                        response = replay.content
                    } catch {
                        response = "Failed to get response: \(error.localizedDescription)"
                    }
                }
            } label: {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonSizing(.flexible)
            .glassEffect(.regular.interactive())
        }
        .padding()
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
