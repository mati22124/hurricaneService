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
                VStack {
                    Text("Posted by \(post.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    HStack {
                        Text("Topic - \(post.topic)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("•")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(timeAgoSince(post.timeposted))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Title
                Text(post.title)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .lineLimit(3)
                //Body
                Text(post.body)
                    .foregroundStyle(.black)
                    .font(.footnote)
                    .lineLimit(3)
                
                // Photo
                AsyncImage(url:URL(string:post.photoURL)) { image in
                    image
                        .resizable()
                        .frame(width:280,height:280)
                        .aspectRatio(contentMode: .fit)
                    
                    
                } placeholder: {
                    ProgressView()
                        .frame(width:280,height:280)
                        .shadow(radius: 4,y:4)
                }.frame(maxWidth: .infinity, alignment: .center)
                
                // DM Button
            }
            .padding()
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .padding(.top, 20)
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
                .padding(.horizontal,30)
            }
            .navigationTitle("Posts")
            .navigationBarItems(trailing:
                                    NavigationLink(destination:AddPostView().navigationBarBackButtonHidden(true)){
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                }
                
            )
            .navigationBarTitleTextColor(.white)
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
