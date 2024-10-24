//
//  MessageView.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/24/24.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}

struct InstagramDMView: View {
    @State private var messageText = ""
    @State private var messages: [Message] = []
    
    @Environment(\.dismiss) var dismiss
    
    var name: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar
            HStack {
                HStack(spacing: 12) {
                    Button(action: {dismiss()}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("SN")
                                .foregroundColor(.primary)
                                .font(.system(size: 14, weight: .medium))
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                        Text("Active now")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
               
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 1, y: 1)
            
            // Messages
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message input
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "camera")
                        .foregroundColor(.primary)
                        .font(.system(size: 24))
                }
                
                TextField("Message...", text: $messageText)
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                
                if messageText.isEmpty {
                    Button(action: {}) {
                        Image(systemName: "mic")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    }
                } else {
                    Button(action: sendMessage) {
                        Text("Send")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
    }
    
    private func sendMessage() {
        let newMessage = Message(content: messageText, isFromCurrentUser: true, timestamp: Date())
        messages.append(newMessage)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(message.isFromCurrentUser ? Color.blue : Color(UIColor.systemGray6))
                    .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                    .cornerRadius(20)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isFromCurrentUser ? .trailing : .leading)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromCurrentUser {
                Spacer()
            }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

