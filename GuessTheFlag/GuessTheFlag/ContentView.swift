//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Furkan İSLAM on 13.01.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Turkiye","Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var selectedFlag: Int? = nil
    
    @State private var animationAmounts = [0.0, 0.0, 0.0]  // Her bayrak için ayrı animasyon
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .rotation3DEffect(
                                    .degrees(animationAmounts[number]),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .blur(radius: selectedFlag != nil && selectedFlag != number ? 5 : 0) // seçilemeyenler bulanık yap
                        }
                        
                        .animation(.easeInOut(duration: 1), value: animationAmounts[number])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Restart", action: restartGame)
        } message: {
                Text("Your score is : \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                animationAmounts[number] += 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                askQuestion()
            }
        } else {
            scoreTitle = "Game Over!"
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmounts = [0.0, 0.0, 0.0]  // Yeni soru için animasyonu sıfırla
        selectedFlag = nil
    }
    
    func restartGame() {
        score = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
