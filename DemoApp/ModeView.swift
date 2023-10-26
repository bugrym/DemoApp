//
//  ModeView.swift
//  DemoApp
//
//  Created by vbugrym on 25.10.2023.
//

import SwiftUI

import SwiftUI

struct ListeningReadingToggle: View {
    @Binding var isListeningMode: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 100, height: 40)
                .foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 36)
                        .foregroundColor(isListeningMode ? Color.blue : Color.white)
                    
                    Image(systemName: "headphones")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(isListeningMode ? .white : .black)
                }
                .onTapGesture {
                    isListeningMode = true
                }
                
                ZStack {
                    Circle()
                        .frame(width: 40, height: 36)
                        .foregroundColor(isListeningMode ? Color.white : Color.blue)
                    
                    Image(systemName: "text.alignleft")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(isListeningMode ? .black : .white)
                }
                .onTapGesture {
                    isListeningMode = false
                }
            }
        }
    }
}

struct ModeView: View {
    @State private var isListeningMode = false

    var body: some View {
        VStack {
            ListeningReadingToggle(isListeningMode: $isListeningMode)
                .padding()
                .foregroundColor(.white)
                .font(.title)
        }
    }
}

struct ModeView_Previews: PreviewProvider {
    static var previews: some View {
        ModeView()
    }
}
