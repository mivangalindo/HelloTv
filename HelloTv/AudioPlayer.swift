//
//  AudioPlayer.swift
//  HelloTv
//
//  Created by Mario Iván Galindo Guevara on 08/05/23.
//

import Foundation

import Foundation
import AVFoundation
import Combine

class AudioPlayer: ObservableObject {
    private var audioPlayer: AVQueuePlayer?

    func playWinningSound() throws {
        try playSound(named: "victory")
    }

    func playButtonClick() throws {
        try playSound(named: "click")
    }

    private func playSound(named name: String) throws {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            throw NSError(domain: "AudioPlayerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se encontró el archivo de sonido '\(name).mp3'."])
        }

        let asset = AVAsset(url: soundURL)
        let playerItem = AVPlayerItem(asset: asset)

        if audioPlayer == nil {
            audioPlayer = AVQueuePlayer()
        } else {
            audioPlayer?.removeAllItems()
        }

        audioPlayer?.insert(playerItem, after: nil)

        let looper = AVPlayerLooper(player: audioPlayer!, templateItem: playerItem)
        audioPlayer?.play()

        audioPlayer?.actionAtItemEnd = .advance

        let _ = looper
    }

    deinit {
        audioPlayer?.pause()
        audioPlayer = nil
    }
}
