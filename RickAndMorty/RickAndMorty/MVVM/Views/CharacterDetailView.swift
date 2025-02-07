//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Vitaliy on 07.02.2025.
//
import SwiftUI

struct CharacterDetailView: View {
   
    let viewModel: CharacterDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    struct RoundedCornersShape: Shape {
        var radius: CGFloat = 24
        var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Top Image
                    topImageSection
                    
                    // MARK: - Info Section
                    infoSection
                }
            }
            
            // MARK: - Back Button
            backButton
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
    
    // MARK: - Top Image
    private var topImageSection: some View {
        ZStack(alignment: .topLeading) {
            if let url = URL(string: viewModel.character.image) {
                AsyncImage(url: url) { imagePhase in
                    switch imagePhase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedCornersShape(radius: 24))
                            .clipped()
                    case .failure(_):
                        Color.gray
                            .frame(height: 300)
                            .overlay(Text("No image").foregroundColor(.white))
                            .clipShape(RoundedCornersShape(radius: 24))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray
                    .frame(height: 300)
                    .overlay(Text("No image").foregroundColor(.white))
                    .clipShape(RoundedCornersShape(radius: 24))
            }
        }
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
           
            HStack {
                Text(viewModel.character.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            Text(viewModel.character.status)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(#colorLiteral(red: 0.1123906001, green: 0.8079059124, blue: 0.9750773311, alpha: 1)))
                .clipShape(Capsule())
            }
            
            HStack {
                Text("\(viewModel.character.species) •")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.3195140064, green: 0.2850551903, blue: 0.4672753811, alpha: 1)))
                
                Text("\(viewModel.character.gender)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.1017063335, green: 0.007614701521, blue: 0.2666857541, alpha: 1)))
            }
            
            if !viewModel.character.location.isEmpty {
                HStack {
                    Text("Location :")
                        .font(.system(size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.1017063335, green: 0.007614701521, blue: 0.2666857541, alpha: 1)))
                Text("\(viewModel.character.location.name)")
                    .font(.system(size: 16))
                    .foregroundColor(Color(#colorLiteral(red: 0.3195140064, green: 0.2850551903, blue: 0.4672753811, alpha: 1)))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
                .padding()
        }
        .background(
            Circle()
                .fill(Color.white)
                .shadow(radius: 4)
        )
        .padding(.leading, 16)
        .padding(.top, 50) 
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModel(character: Character(id: 1, name: "Character", status: "status", species: "species", type: "type", gender: "gender", origin: Location(name: "location name", url: "url"), location: Location(name: "Location name", url: "url"), image: "Image", episode: ["episodes"], url: "url", created: "Created")))
}
