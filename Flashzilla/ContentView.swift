//
//  ContentView.swift
//  Flashzilla
//
//  Created by Alex Nguyen on 2023-08-19.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
//    @State private var viewModel.deck.cards = Array<Card>(repeating: Card.example, count: 5)
    @Environment(\.scenePhase) var scenePhase
        
    @StateObject var deck = Deck()
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Time: \(viewModel.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(viewModel.deck.cards) { card in
                        CardView(card: card) { correctAnswer in
                            withAnimation {
                                if correctAnswer {
                                    viewModel.removeCard(card)
                                } else {
                                    let newCard = Card(prompt: card.prompt, answer: card.answer)
                                    viewModel.deck.cards.insert(newCard, at: 0)
                                    viewModel.removeCard(card)
                                }
                            }
                        }
                        .stacked(at: viewModel.deck.cards.firstIndex(of: card) ?? 0, in: viewModel.deck.cards.count)
                        .allowsHitTesting(viewModel.deck.cards.firstIndex(of: card) ?? 0 == viewModel.deck.cards.count - 1)
                        .accessibilityHidden(viewModel.deck.cards.firstIndex(of: card) ?? 0 < viewModel.deck.cards.count - 1)
                    } 
                }
                .allowsTightening(viewModel.timeRemaining > 0)
                
                if viewModel.deck.cards.isEmpty {
                    Button("Start Again") {
                        Task {
                            viewModel.resetCards()
                        }
                    }
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                let card = viewModel.deck.cards.last!
                                let newCard = Card(prompt: card.prompt, answer: card.answer)
                                viewModel.deck.cards.insert(newCard, at: 0)
                                viewModel.removeCard(card)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                viewModel.removeCard(viewModel.deck.cards.last!)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
                .disabled(viewModel.deck.cards.count == 0)
            }
        }
        .onReceive(viewModel.timer) { _ in viewModel.countdown() }
        .onChange(of: scenePhase, perform: viewModel.changePhase)
        .sheet(isPresented: $viewModel.showingEditScreen, onDismiss: viewModel.resetCards, content: EditCards.init)
        .onAppear(perform: viewModel.resetCards)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
