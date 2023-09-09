//
//  Card.swift
//  Flashzilla
//
//  Created by Alex Nguyen on 2023-08-21.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played Deadpool in Dealpool 1 & 2?", answer: "Ryan Reynolds")
}

@MainActor class Deck: ObservableObject {
    @Published var cards: [Card]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards.json")
    
    init() {
        do {
            let encoded = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: encoded)
        } catch {
            cards = []
        }
    }   
    
    func loadData() {
        
        do {
            let encoded = try Data(contentsOf: savePath)
            cards = try JSONDecoder().decode([Card].self, from: encoded)
        } catch {
            cards = []
        }
    }
        
    func saveData() {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards.json")
        
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
