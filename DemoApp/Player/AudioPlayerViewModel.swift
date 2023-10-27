//
//  AudioPlayerViewModel.swift
//  DemoApp
//
//  Created by vbugrym on 26.10.2023.
//

import SwiftUI
import AVFoundation

public class AudioPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var mp3Files: [String] = ["dickens_oliver_twist_01_64kb",
                                         "dickens_oliver_twist_02_64kb",
                                         "dickens_oliver_twist_03_64kb"]
    @Published var currentSongIndex = 0
    @Published var playbackSpeed: Double = 1.0
    
    var bookCover: String { "cover" }
    var chapterTitle: String { "Chapter \(currentSongIndex + 1) of \(mp3Files.count)" }
    var author: String { "Charles Dickens" }
    
    var speedButtonTitle: String {
        return "Speed: \(playbackSpeed)x"
    }
    
    init() {
        loadAudio()
    }
    
    func loadAudio() {
        guard currentTime >= 0 && currentSongIndex < mp3Files.count else {
            return
        }
        
        let mp3FileName = mp3Files[currentSongIndex]
        guard let mp3URL = Bundle.main.url(forResource: mp3FileName, withExtension: "mp3") else {
            return
        }
        player = AVPlayer(url: mp3URL)
        player?.rate = Float(playbackSpeed)
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            if !self.isEditingSlider {
                self.currentTime = time.seconds
            }
            self.duration = self.player?.currentItem?.asset.duration.seconds ?? 0
        }
//        playAudio()
    }
    
    private var isEditingSlider = false
    
    func togglePlayPause() {
        if isPlaying {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    func pauseAudio() {
        player?.pause()
        isPlaying = false
    }
    
    func rewindBackward() {
        let newTime = currentTime - 5
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    func rewindForward() {
        let newTime = currentTime + 10
        player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    func previousSong() {
        currentSongIndex = max(0, currentSongIndex - 1)
        player?.replaceCurrentItem(with: nil)
        loadAudio()
    }
    
    func nextSong() {
        currentSongIndex = min(mp3Files.count - 1, currentSongIndex + 1)
        player?.replaceCurrentItem(with: nil)
        loadAudio()
    }
    
    func togglePlaybackSpeed() {
        // Toggle between three playback speeds: 1.0x, 1.5x, and 2.0x.
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
        
        // Set the new playback speed for the AVPlayer.
        player?.rate = Float(playbackSpeed)
    }
    
    func sliderEditingChanged(editing: Bool) {
        isEditingSlider = editing
        if !editing, let player {
            player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1))
        }
    }
    
    func formatTime(_ time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
