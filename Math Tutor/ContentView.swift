//
//  ContentView.swift
//  Math Tutor
//
//  Created by Aimee Hong on 9/26/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @FocusState private var textFieldIsFocused: Bool
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var message = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var guessButtonIsDisabled = false
    @State private var hiddenButton = true
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪", "🧸", "🐼", "🍰", "🍭", "🌭"]
    
    var body: some View {
        VStack {
            Text(firstNumberEmojis)
                .font(.system(size: 80))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            Text("+")
                .font(.largeTitle)
            Text(secondNumberEmojis)
                .font(.system(size: 80))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
            
            TextField("", text: $answer)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .keyboardType(.numberPad)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess") {
                textFieldIsFocused = false
                let result = firstNumber + secondNumber
                if let answerValue = Int(answer) {
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "Sorry, the correct answer is \(result)"
                    }
                } else {
                    playSound(soundName: "wrong")
                }
                textFieldIsDisabled = true
                guessButtonIsDisabled = true
                hiddenButton = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || guessButtonIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green : .red)
            
            if guessButtonIsDisabled {
                Button("Play Again?") {
                    answer = ""
                    guessButtonIsDisabled = false
                    textFieldIsDisabled = false
                    message = ""
                    generateNewEquation()
                }
            }
        }
        .padding()
        .onAppear {
            generateNewEquation()
        }
    }
    func generateNewEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
    func playSound(soundName: String) {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioplayer.")
        }
    }
    
}

#Preview {
    ContentView()
}
