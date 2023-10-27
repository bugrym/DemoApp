//
//  ProductView.swift
//  DemoApp
//
//  Created by vbugrym on 26.10.2023.
//

import SwiftUI

struct ProductViewModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                ProductView(isPresented: $isPresented)
            }
        }
    }
}


struct ProductView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Unlock Learning")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Text("Grow on the go by listening and reading the world's best ideas")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                    
                    Task {
                        do {
                            try await viewModel.purchase()
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Text("Start Listening • $89,99")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    
                }
            }
            .padding()
            .background(LinearGradient(colors: [.clear, .white.opacity(0.5), .white],
                                       startPoint: .center,
                                       endPoint: .bottom))
        }
        .task {
            do {
                try await viewModel.loadProducts()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ProductView(isPresented: Binding(get: { return true }, set: { _ in }))
}
