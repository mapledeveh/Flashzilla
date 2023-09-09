//
//  ContentView-ViewModel.swift
//  Flashzilla
//
//  Created by Alex Nguyen on 2023-09-05.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var timeRemaining = 100
        @Published var showingEditScreen = false
        @ObservedObject var deck = Deck()
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        func removeCard(_ card: Card) {
            //        guard index >= 0 else { return }
            guard let index = deck.cards.firstIndex(of: card) else { return }
            deck.cards.remove(at: index)
            
            if deck.cards.isEmpty {
                isActive = false
            }
        }
        
        func resetCards() {
            deck.loadData()
            timeRemaining = 100
            isActive = true
        }
        
        func countdown() {
            guard isActive else { return }
            
            if deck.cards.count >= 1 {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
        
        func changePhase(_ newPhase: ScenePhase) {
            if newPhase == .active {
                if deck.cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
    }
}
