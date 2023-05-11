//
//  HelloTvApp.swift
//  HelloTv
//
//  Created by Mario Iván Galindo Guevara on 08/05/23.
//

import SwiftUI

@main
struct HelloTvApp: App {
    @StateObject private var ticTacToeGame = TicTacToeGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ticTacToeGame)
        }
    }
}
