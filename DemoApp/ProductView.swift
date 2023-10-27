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
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProductView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
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
                    // Show in-app purchase view (you can implement this part)
                    // Call your StoreKit functionality here
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
        }
        .padding()
        .background(LinearGradient(colors: [.clear, .white.opacity(0.5), .white, .red],
                                   startPoint: .top,
                                   endPoint: .bottom))
    }
}

#Preview {
    ProductView(isPresented: Binding(get: { return true }, set: { _ in }))
}
