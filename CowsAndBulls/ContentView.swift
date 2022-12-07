//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Zaid Neurothrone on 2022-11-05.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("maximumGuesses") var maximumGuesses = 100
  @AppStorage("answerLength") var answerLength = 4
  
  @AppStorage("enableHardMode") var enableHardMode = false
  @AppStorage("showGuessCount") var showGuessCount = false
  
  @State private var guess = ""
  @State private var guesses: [String] = []
  @State private var answer = ""
  
  @State private var isGameOver = false
  
  var body: some View {
    content
      .navigationTitle("Cows and Bulls")
      .onAppear(perform: startNewGame)
      .onChange(of: answerLength, perform: { _ in startNewGame() })
      .alert("You win!", isPresented: $isGameOver) {
        Button("OK", action: startNewGame)
      } message: {
        Text("Congratulations! Click OK to play again.")
      }
  }
  
  private var content: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Enter a guess...", text: $guess)
          .disabled(guesses.count == 100)
          .onSubmit(submitGuess)
        
        Button("Go", action: submitGuess)
      }
      .padding()
      
      List(0..<guesses.count, id: \.self) { index in
        let guess = guesses[index]
        let shouldShowResult = enableHardMode == false || enableHardMode && index == 0
        
        HStack {
          Text(guess)
          Spacer()
          
          if shouldShowResult {
            Text(result(for: guess))
          }
        }
      }
      .listStyle(.sidebar)
      
      if showGuessCount {
        Text("Guesses: \(guesses.count) / \(maximumGuesses)")
          .padding()
      }
    }
    .frame(width: 250)
    .frame(minHeight: 300)
    .touchBar {
      HStack {
        Text("Guesses: \(guesses.count)")
          .touchBarItemPrincipal()
        
        Spacer(minLength: 200)
      }
    }
  }
}

extension ContentView {
  private func submitGuess() {
    // Unique and length is 4
    guard Set(guess).count == answerLength else { return }
    // Length is 4
    guard guess.count == answerLength else { return }
    
    let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
    guard guess.rangeOfCharacter(from: invalidCharacters) == nil else { return }
    
    guesses.insert(guess, at: .zero)
    
    // Did the player win?
    if result(for: guess).contains("\(answerLength)b") {
      isGameOver.toggle()
    }
    
    // Clear the guess string
    guess = ""
  }
  
  func result(for guess: String) -> String {
    var bulls: Int = .zero
    var cows: Int = .zero
    
    let answerLetters = Array(answer)
    
    for (index, letter) in guess.enumerated() {
      if letter == answerLetters[index] {
        bulls += 1
      } else if answer.contains(letter) {
        cows += 1
      }
    }
    
    return "\(bulls)b \(cows)c"
  }
  
  func startNewGame() {
    guard answerLength >= 3 && answerLength <= 8 else { return }
    
    guess = ""
    guesses.removeAll()
    answer = ""
    
    let numbers = (0...9).shuffled()
    
    for i in 0..<answerLength {
      answer.append(String(numbers[i]))
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
