//
//  test.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/22/24.
//

import SwiftUI

// Post model
struct Post: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let subreddit: String
    let upvotes: Int
    let commentCount: Int
    let timePosted: String
    let thumbnail: String?
}

// Post row view
struct PostRowView: View {
    let post: Post
    @State private var isUpvoted = false
    @State private var isDownvoted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("r/\(post.subreddit)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("• Posted by u/\(post.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(post.timePosted)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Title
            Text(post.title)
                .font(.headline)
                .lineLimit(3)
            
            // Thumbnail if exists
            if let thumbnail = post.thumbnail {
                Image(thumbnail)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            }
            
            // Bottom bar
            HStack(spacing: 16) {
                // Upvote controls
                HStack(spacing: 4) {
                    Button(action: { isUpvoted.toggle(); if isUpvoted { isDownvoted = false } }) {
                        Image(systemName: isUpvoted ? "arrow.up.circle.fill" : "arrow.up.circle")
                            .foregroundColor(isUpvoted ? .orange : .gray)
                    }
                    Text("\(post.upvotes)")
                        .foregroundColor(.gray)
                    Button(action: { isDownvoted.toggle(); if isDownvoted { isUpvoted = false } }) {
                        Image(systemName: isDownvoted ? "arrow.down.circle.fill" : "arrow.down.circle")
                            .foregroundColor(isDownvoted ? .blue : .gray)
                    }
                }
                
                // Comments
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                    Text("\(post.commentCount)")
                }
                .foregroundColor(.gray)
                
                // Share button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                }
                .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// Main posts view
struct PostsView: View {
    let posts: [Post] = [
        Post(title: "Check out this amazing SwiftUI tutorial I found!",
             author: "swiftdev",
             subreddit: "swift",
             upvotes: 1234,
             commentCount: 89,
             timePosted: "5h ago",
             thumbnail: nil),
        Post(title: "Just released my first app to the App Store!",
             author: "newdev123",
             subreddit: "iOSProgramming",
             upvotes: 532,
             commentCount: 45,
             timePosted: "2h ago",
             thumbnail: "app_screenshot")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(posts) { post in
                        PostRowView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Posts")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "plus")
            })
        }
    }
}

// Preview
struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
