//
//  ProductView.swift
//  DemoApp
//
//  Created by vbugrym on 26.10.2023.
//

import SwiftUI

struct ProductView: View {
    @State private var isShowingOverlay = true

    var body: some View {
        ZStack {
            if isShowingOverlay {
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
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.white, .red]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .opacity(1)
                    )
                }
            }
        }
    }
}

#Preview {
    ProductView()
}
