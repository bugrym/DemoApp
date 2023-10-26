//
//  ContentView.swift
//  DemoApp
//
//  Created by vbugrym on 25.10.2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    @State private var mp3Files: [String] = ["dickens_oliver_twist_01_64kb",
                                             "dickens_oliver_twist_02_64kb",
                                             "dickens_oliver_twist_03_64kb"]
    @State private var currentSongIndex = 0
    @State private var playbackSpeed: Double = 1.0

    var body: some View {
        VStack {
            Image("cover")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Chapter \(currentSongIndex + 1) of \(mp3Files.count)")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.top)
            
            Text("Charles Dickens")
                .font(.footnote)
                .foregroundStyle(.gray)
                .padding(.bottom)

            if let player {
                HStack {
                    Text(formatTime(currentTime))
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.8))
                    
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: sliderEditingChanged)
                                            .accentColor(.blue)
                                            .frame(height: 5)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(5)
                    
                    Text(formatTime(duration))
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.8))
                }
                .padding()
                
                Button(action: togglePlaybackSpeed) {
                    Text("Speed x\(playbackSpeed, specifier: "%.1f")")
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.black)
                .font(.headline)
                .tint(.gray.opacity(0.7))
                .padding(.bottom)
                
                HStack(spacing: 16) {
                    Button(action: previousSong) {
                        Image(systemName: "backward.end.fill")
                    }
                    Button(action: rewindBackward) {
                        Image(systemName: "gobackward.5")
                            
                    }
                    Button(action: togglePlayPause) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")

                    }
                    Button(action: rewindForward) {
                        Image(systemName: "goforward.10")
                            
                    }
                    Button(action: nextSong) {
                        Image(systemName: "forward.end.fill")
                            
                    }
                }
                .padding()
                .font(.title)
                .foregroundColor(.black)
                
                ModeView()

               
            } else {
                Text("No audio loaded")
            }
        }
        .onAppear {
            loadAudio()
        }
    }

    private func loadAudio() {
        if currentSongIndex >= 0 && currentSongIndex < mp3Files.count {
            let mp3FileName = mp3Files[currentSongIndex]
            if let mp3URL = Bundle.main.url(forResource: mp3FileName, withExtension: "mp3") {
                player = AVPlayer(url: mp3URL)
                player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                    currentTime = time.seconds
                    duration = player?.currentItem?.asset.duration.seconds ?? 0
                }
                playAudio()
            }
        }
    }
    
   
    private func sliderEditingChanged(editing: Bool) {
        if !editing, let player = player {
            player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1))
        }
    }

    private func playAudio() {
        player?.play()
        isPlaying = true
    }

    private func pauseAudio() {
        player?.pause()
        isPlaying = false
    }

    private func togglePlayPause() {
        if isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }

    private func rewindBackward() {
        let newTime = currentTime - 5
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }

    private func rewindForward() {
        let newTime = currentTime + 10
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }

    private func previousSong() {
        currentSongIndex = max(0, currentSongIndex - 1)
        player?.replaceCurrentItem(with: nil)
        loadAudio()
    }

    private func nextSong() {
        currentSongIndex = min(mp3Files.count - 1, currentSongIndex + 1)
        player?.replaceCurrentItem(with: nil)
        loadAudio()
    }

    private func formatTime(_ time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func togglePlaybackSpeed() {
        switch playbackSpeed {
        case 1.0:
            playbackSpeed = 1.5
        case 1.5:
            playbackSpeed = 2.0
        case 2.0:
            playbackSpeed = 1.0
        default:
            break
        }
        
        player?.rate = Float(playbackSpeed)
    }
}

#Preview {
    ContentView()
}
