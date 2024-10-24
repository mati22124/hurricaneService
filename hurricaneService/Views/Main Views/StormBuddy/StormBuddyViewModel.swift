//
//  StormBuddyViewModel.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/24/24.
//

import Foundation
import SwiftUI
import OpenAI


struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

@MainActor
final class StormBuddyViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = [ChatMessage(content: "Hi there! I'm Storm Buddy, your weather companion! How can I help you today?", isUser: false, timestamp: Date())]
    
    let openAI = OpenAI(apiToken:  "sk-proj-slbExAngIYdaX2V1G0G9T3BlbkFJ1Ge1NPqo00tmGtaYJ5BA")
   
}


extension StormBuddyViewModel {
    
    func sendNewCommentToAI(content: String) async throws {
        try await StormChat(content: content)
    }
    
    
    
    func StormChat(content: String) async throws {
        
        
        //! aborts execution if value is equal to nil
        
        
        let query = ChatQuery(
                   messages:
                    [.init(role: .system, content:"You are now an ai that is designed to help with natural disastours. Your main mission is to help answer questions to people in need, like information on latest events, future weather plans, escape routes, and how to survive.")!] + self.messages.map({
                       .init(role: .user, content: $0.content)!
                   }),
                   model: .gpt4,
                   maxTokens: 200,
                   temperature: 1
                                    
               )
            
        
        
        let result = try await openAI.chats(query: query)
        
        //change these to specific errors for error handling
        guard let choice = result.choices.first else {
            return
        }
        
        guard let message = choice.message.content?.string else { return }
      
        self.messages.append(ChatMessage(content: message, isUser: false,timestamp: Date()))
        
        
    }

    
    
 
}
