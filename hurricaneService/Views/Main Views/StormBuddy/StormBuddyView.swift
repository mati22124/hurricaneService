//
//  StormBuddyView.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/24/24.
//

import SwiftUI



struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(.white/*message.isUser ? .white : .primary*/)
                    .cornerRadius(16)
                
                Text(formatDate(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StormBuddyChatView: View {
    
    @StateObject var viewModel = StormBuddyViewModel()
    
    @State private var messageText = ""
    @State private var tempMessage = ""
    
    @State var gettingMessage = false

    
    var body: some View {
        VStack {
            // Navigation bar
            HStack {
                Image(systemName: "cloud.bolt.fill")
                    .foregroundColor(.white)
                    .font(.title2)
                Text("Storm Buddy")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            .background(Color.darkPurp)
            .shadow(radius: 1)
            
            // Chat messages
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message)
                        
                    }
                }
            }
            
            // Message input
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.light)
                    .padding(.horizontal)
                
                Button {
                 
                    tempMessage = messageText
                    sendMessage()
                    
           
                   
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.trailing)
                .disabled(messageText.isEmpty)
            }
            .padding(.vertical)
            .background(Color.darkPurp)
            .shadow(radius: 1)
        }
    }
    
    private func sendMessage() {
    
        let userMessage = ChatMessage(content: messageText, isUser: true, timestamp: Date())
        viewModel.messages.append(userMessage)
        messageText = ""
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                gettingMessage = true
                    try? await viewModel.sendNewCommentToAI(content: tempMessage)
                    tempMessage = ""
                gettingMessage = false
                }
            }
        
    }
        
    
   
    
}


#Preview {
  StormBuddyChatView()
}
