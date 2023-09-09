//
//  EditCards.swift
//  Flashzilla
//
//  Created by Alex Nguyen on 2023-08-27.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var prompt = ""
    @State private var answer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $prompt)
                    TextField("Answer", text: $answer)
                    Button("Add card", action: addCard)
                }
                
                Section("Existing cards") {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            //            .listStyle(.grouped)
            .onAppear(perform: loadData)
        }
    }
    
//    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decodedCards = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decodedCards
//                return
//            }
//        }
//    }
    
//    func saveData() {
//        if let encoded = try? JSONEncoder().encode(cards) {
//            UserDefaults.standard.set(encoded, forKey: "Cards")
//        }
//    }
    
    func loadData() {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards.json")
        
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
    
    func addCard() {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        answer = ""
        prompt = ""
        saveData()
    }
    
    func deleteCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
