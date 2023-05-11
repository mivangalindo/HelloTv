//
//  TicTacToeGame.swift
//  HelloTv
//
//  Created by Mario Iván Galindo Guevara on 08/05/23.
//

import Foundation

import SwiftUI
import Combine

class TicTacToeGame: ObservableObject {
    enum Player {
           case none, x, o
       }

       @Published private(set) var board: [[Player]] = Array(repeating: Array(repeating: .none, count: 3), count: 3)
       @Published private(set) var currentPlayer: Player = .x
       @Published private(set) var winner: Player = .none
       private var buttonEnabled: [[Bool]] = Array(repeating: Array(repeating: true, count: 3), count: 3) // matriz de variables booleanas para rastrear si un botón está habilitado o no

       func play(at row: Int, _ column: Int) {
           guard buttonEnabled[row][column] else { return } // salir si el botón está deshabilitado
           guard board[row][column] == .none else { return }

           board[row][column] = currentPlayer
           buttonEnabled[row][column] = false // deshabilitar el botón
           if checkWin(for: currentPlayer, at: row, column) {
               winner = currentPlayer
               reset()
           } else if checkDraw() {
               winner = .none
               reset()
           } else {
               currentPlayer = (currentPlayer == .x) ? .o : .x
           }
       }

    func playComputerTurn() {
        guard currentPlayer == .o else { return }

        var availableSpaces = [(Int, Int)]()
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i][j] == .none {
                    availableSpaces.append((i, j))
                }
            }
        }

        guard availableSpaces.count > 0 else { return }

        let randomIndex = Int.random(in: 0..<availableSpaces.count)
        let (row, column) = availableSpaces[randomIndex]
        play(at: row, column)
    }
    
    private func checkWin(for player: Player, at row: Int, _ column: Int) -> Bool {
        func checkLine(using transform: (Int) -> (Int, Int)) -> Bool {
            return (0..<3).allSatisfy { i in
                let (row, col) = transform(i)
                return board[row][col] == player
            }
        }
        
        return checkLine(using: { i in (i, column) }) || checkLine(using: { i in (row, i) }) || checkLine(using: { i in (i, i) }) || checkLine(using: { i in (i, 2 - i) })
    }

    private func checkDraw() -> Bool {
        return board.allSatisfy { row in row.allSatisfy { $0 != .none } }
    }

    func reset() {
           board = Array(repeating: Array(repeating: .none, count: 3), count: 3)
           currentPlayer = .x
           winner = .none
           buttonEnabled = Array(repeating: Array(repeating: true, count: 3), count: 3) // reiniciar los botones habilitados
       }
    func isButtonEnabled(at row: Int, _ column: Int) -> Bool {
           return buttonEnabled[row][column]
       }
}
/*import Foundation
import SwiftUI
import Combine

class TicTacToeGame: ObservableObject {
    enum Player {
        case none, x, o
    }

    @Published private(set) var board: [[Player]] = Array(repeating: Array(repeating: .none, count: 3), count: 3)
    @Published private(set) var currentPlayer: Player = .x
    @Published private(set) var winner: Player = .none

    func play(at row: Int, _ column: Int) {
        guard board[row][column] == .none else { return }
        
        board[row][column] = currentPlayer
        if checkWin(for: currentPlayer, at: row, column) {
            winner = currentPlayer
            reset()
        } else if checkDraw() {
            winner = .none
            reset()
        } else {
            currentPlayer = (currentPlayer == .x) ? .o : .x
        }
    }

    func playComputerTurn() {
        guard currentPlayer == .o else { return }

        var availableSpaces = [(Int, Int)]()
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i][j] == .none {
                    availableSpaces.append((i, j))
                }
            }
        }

        guard availableSpaces.count > 0 else { return }

        let randomIndex = Int.random(in: 0..<availableSpaces.count)
        let (row, column) = availableSpaces[randomIndex]
        play(at: row, column)
    }

    private func checkWin(for player: Player, at row: Int, _ column: Int) -> Bool {
        func checkLine(using transform: (Int) -> (Int, Int)) -> Bool {
            return (0..<3).allSatisfy { i in
                let (row, col) = transform(i)
                return board[row][col] == player
            }
        }
        
        return checkLine(using: { i in (i, column) }) || checkLine(using: { i in (row, i) }) || checkLine(using: { i in (i, i) }) || checkLine(using: { i in (i, 2 - i) })
    }

    private func checkDraw() -> Bool {
        return board.allSatisfy { row in row.allSatisfy { $0 != .none } }
    }

    func reset() {
        board = Array(repeating: Array(repeating: .none, count: 3), count: 3)
        currentPlayer = .x
        winner = .none
    }
}
*/
