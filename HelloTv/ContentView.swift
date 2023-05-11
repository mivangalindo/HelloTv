//
//  ContentView.swift
//  HelloTv
//
//  Created by Mario Iván Galindo Guevara on 08/05/23.
//
import SwiftUI
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var game: TicTacToeGame
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var mensaje = "Bienvenido a Tic Tac Toe"
    @State private var showAlert = false
    @State private var winner: TicTacToeGame.Player = .none

    var body: some View {
        VStack {
            Text(mensaje)
                .font(.largeTitle)
            Text("Turno del jugador: \(game.currentPlayer.description)")
                .font(.headline)
                .padding(.bottom)

            VStack(spacing: 10) {
                
                ForEach(0 ..< 3) { row in
                    HStack(spacing: 10) {
                        ForEach(0 ..< 3) { column in
                            Button(action: {
                                game.play(at: row, column)
                                game.playComputerTurn()
                            }) {
                                Text(game.board[row][column].description)
                                    .font(.system(size: 50))
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.white)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                            .background(game.isButtonEnabled(at: row, column) ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()

            Button("Reiniciar juego") {
                game.reset()
                mensaje = "Bienvenido a Tic Tac Toe"
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("¡Tenemos un ganador!"),
                message: Text("El jugador \(winner.description) ha ganado."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onReceive(game.$winner) { gameWinner in
            if gameWinner != .none {
                mensaje = "Ganador: \(gameWinner.description)"
                showAlert = true
                winner = gameWinner
                do {
                    try audioPlayer.playWinningSound()
                } catch {
                    print("Error al reproducir el sonido: \(error.localizedDescription)")
                }
            }
        }
    }
}
extension TicTacToeGame.Player: CustomStringConvertible {
    var description: String {
        switch self {
        case .none:
            return ""
        case .x:
            return "X"
        case .o:
            return "O"
        }
    }
}
