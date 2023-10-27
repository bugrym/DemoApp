//
//  PlayerView.swift
//  DemoApp
//
//  Created by vbugrym on 25.10.2023.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @StateObject private var viewModel = AudioPlayerViewModel()
    @State private var presentProductView = true
    
    var body: some View {
        ZStack {
            VStack {
                Image(viewModel.bookCover)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(viewModel.chapterTitle)
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .padding(.top)
                
                Text(viewModel.author)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                if $viewModel.player != nil {
                    HStack {
                        Text(viewModel.formatTime(viewModel.currentTime))
                            .font(.footnote)
                            .foregroundStyle(.gray.opacity(0.8))
                        
                        Slider(value: $viewModel.currentTime,
                               in: 0...viewModel.duration,
                               onEditingChanged: viewModel.sliderEditingChanged)
                        .accentColor(.blue)
                        .frame(height: 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        
                        Text(viewModel.formatTime(viewModel.duration))
                            .font(.footnote)
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                    .padding()
                    
                    Button(action: viewModel.togglePlaybackSpeed) {
                        Text("Speed x\(viewModel.playbackSpeed, specifier: "%.1f")")
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .tint(.gray.opacity(0.7))
                    .padding(.bottom)
                    
                    HStack(spacing: 16) {
                        Button(action: viewModel.previousSong) {
                            Image(systemName: "backward.end.fill")
                        }
                        Button(action: viewModel.rewindBackward) {
                            Image(systemName: "gobackward.5")
                            
                        }
                        Button(action: viewModel.togglePlayPause) {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            
                        }
                        Button(action: viewModel.rewindForward) {
                            Image(systemName: "goforward.10")
                            
                        }
                        Button(action: viewModel.nextSong) {
                            Image(systemName: "forward.end.fill")
                            
                        }
                    }
                    .padding()
                    .font(.title)
                    .foregroundColor(.black)
                    
                    ModeView()
                }
            }
        }
        .modifier(ProductViewModifier(isPresented: $presentProductView))
    }
}

#Preview {
    PlayerView()
}
