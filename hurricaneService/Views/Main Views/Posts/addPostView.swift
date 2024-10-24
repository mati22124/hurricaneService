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
            ZStack {
                Color.darkPurp.ignoresSafeArea(.all)
                ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                // Title Section
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Title")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    TextField("Enter your post title...", text: $postTitle)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                // Content Section
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Content")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    TextEditor(text: $postContent)
                                        .scrollContentBackground(.hidden)
                                        .frame(minHeight: 150)
                                        .padding(10)
                                        .background(Color.darkPurp.opacity(0.3))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )
                                }
                                
                                // Image Section
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Image")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    AddImageView(selectedItem: $selectedPhoto)
                                        .environmentObject(postsViewModel)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.darkPurp.opacity(0.5))
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal)
                        }
                        .task {
                            do {
                                try await postsViewModel.loadCurrentUser()
                            } catch {
                                print("couldn't get user")
                            }
                        }
                .navigationTitle("New Post")
                .navigationBarItems(
                    leading: Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "cross")
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(45))
                    },
                    trailing: Button(action: {
                        submitPost()
                    }, label: {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.white)
                    })
                    .disabled(postTitle.isEmpty || postContent.isEmpty)
                )
                .navigationBarTitleTextColor(.textColo)
            }
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
                    .onChange(of: selectedItem, { _, newItem in
                        Task {
                            await loadTransferable(from: newItem)
                        }
                    })
                
            }
            else {
                
                Image(systemName: "photo")
                    .resizable()
                    .frame(width:90,height:75)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.textColo)
                    .onChange(of: selectedItem, { _, newItem in
                        Task {
                            await loadTransferable(from: newItem)
                        }
                    })
                
                
                
                
                
                
                
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


// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.darkPurp.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
    }
}

// Preview provider for SwiftUI canvas
struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
