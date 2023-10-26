//
//  AudiPlayerViewModel.swift
//  DemoApp
//
//  Created by vbugrym on 26.10.2023.
//

import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    @Published var audioPlayerService = AudioPlayerService()
    
    var bookCover: String { "cover" }
    var chapterTitle: String { "Chapter \(audioPlayerService.currentSongIndex + 1) of \(audioPlayerService.mp3Files.count)" }
    var author: String { "Charles Dickens" }
    
    var speedButtonTitle: String {
        return "Speed: \(audioPlayerService.playbackSpeed)x"
    }
    
    init() { }
    
    func togglePlayPause() {
        audioPlayerService.togglePlayPause()
    }
    
    func rewindBackward() {
        audioPlayerService.rewindBackward()
    }
    
    func rewindForward() {
        audioPlayerService.rewindForward()
    }
    
    func previousSong() {
        audioPlayerService.previousSong()
    }
    
    func nextSong() {
        audioPlayerService.nextSong()
    }
    
    func togglePlaybackSpeed() {
        audioPlayerService.togglePlaybackSpeed()
    }
    
    func sliderEditingChanged(editing: Bool) {
        audioPlayerService.sliderEditingChanged(editing: editing)
    }
}
