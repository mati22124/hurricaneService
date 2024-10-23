//
//  addPostView.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/23/24.
//

import SwiftUI
import PhotosUI


struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var isLoading = false
    
    @StateObject var postsViewModel = PostsViewModel()
    
    //user profile image data holder
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $postTitle)
                        .padding(.vertical, 8)
                    
                    TextEditor(text: $postContent)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    //Post
                    AddImageView(selectedItem: $selectedPhoto)
                        .environmentObject(postsViewModel)
                }
                .task {
                    do {
                        //dont need to just safe
                        try await postsViewModel.loadCurrentUser()
                        
                    }catch {
                        print("couldn't get user")
                    }
                }
            }
            .navigationTitle("New Post")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Post") {
                    submitPost()
                }
                .disabled(postTitle.isEmpty || postContent.isEmpty)
            )
            
            
        }
    }
    
    private func submitPost() {
        Task {
          
            
            do {
                if let photo = selectedPhoto {
                    try await postsViewModel.createPost(title: postTitle, body: postContent, topic: "nil",photo: photo)
                }
                dismiss()
              
            }catch {
                print("couldnt add post")
            }
            
          
        }
        
    }
}



struct AddImageView: View {
    
    @Binding var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage? = nil
    @EnvironmentObject var viewModel: PostsViewModel
    
    var body: some View {
        
        PhotosPicker( selection: $selectedItem, matching: .images) {
            
            //make sure the user has a urlimage
            
            if let photo = selectedImage {
                
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .onChange(of: selectedItem) { newItem in
                        
                        Task {
                            await loadTransferable(from: newItem)
                        }
                        
                    }
                
            }
            //if user doesnt sign in with google
            else {
                
                Image("addImage")
                    .resizable()
                    .frame(width:180,height:180)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            await loadTransferable(from: newItem)
                        }
                        
                        
                    }
                
                
                
                
                
                
                
            }
            
        }
    }
    
    @MainActor
        private func loadTransferable(from item: PhotosPickerItem?) async {
            do {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                        return
                    }
                }
                print("Failed to load image")
            }
        }
    
}


// Preview provider for SwiftUI canvas
struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
