//
//  postsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI


// Post row view
struct PostRowView: View {
    let post: DBPost
    
    var body: some View {
        NavigationLink(destination:InstagramDMView(name: post.author).navigationBarBackButtonHidden(true)) {
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Text("Topic - \(post.topic)")
                        .foregroundStyle(.black)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        
                    Text("• Posted by u/\(post.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(timeAgoSince(post.timeposted))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Title
                Text(post.title)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .lineLimit(3)
                //Body
                Text(post.title)
                    .foregroundStyle(.black)
                    .font(.footnote)
                    .lineLimit(3)
                
                // Photo
                AsyncImage(url:URL(string:post.photoURL)) { image in
                    image
                        .resizable()
                        .frame(width:180,height:180)
                        .aspectRatio(contentMode: .fit)
                    
                    
                } placeholder: {
                    ProgressView()
                        .frame(width:180,height:180)
                        .shadow(radius: 4,y:4)
                }
                
                // DM Button
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }
    
    func timeAgoSince(_ date: Date) -> String {
           let formatter = RelativeDateTimeFormatter()
           formatter.unitsStyle = .full  // Options: .short, .full, etc.
           return formatter.localizedString(for: date, relativeTo: Date())
    }
    
}




// Main posts view
struct PostsView: View {
    
    @StateObject var postsViewModel = PostsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(postsViewModel.posts) { post in
                        PostRowView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Posts")
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(trailing:
            NavigationLink(destination:AddPostView().navigationBarBackButtonHidden(true)){
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                }
                
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.darkPurp)
            
            .task {
                do {
                   
                    try await postsViewModel.getAllPosts()
                }catch {
                    print("didn't get posts")
                }
            }
        }
    }
}



#Preview {
    PostsView()
}



/*
VStack {
    Button {
       
    try? postViewModel.createPost(title: "Hello World", body: "This is a test post", author: "Mayank Tiku")
        
    }label: {
        Text("Create Post")
    }
  
} */
