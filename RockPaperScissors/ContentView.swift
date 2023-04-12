//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Farhad Bagherzadeh on 3/11/2022.
//

import SwiftUI

enum Option: String, CaseIterable {
  case rock
  case paper
  case scissors

  var winningChoice: Option {
    switch self {
    case .rock:
      return .paper
    case .paper:
      return .scissors
    case .scissors:
      return .rock
    }
  }

  var losingChoice: Option {
    switch self {
    case .rock:
      return .scissors
    case .paper:
      return .rock
    case .scissors:
      return .paper
    }
  }
}

struct ContentView: View {
  private let options: [Option] = Option.allCases
  @State private var appOption: Option
  @State private var shouldWin: Bool

  private let maxNumberOfGame: Int = 5
  @State private var didGameFinished: Bool = false
  @State private var numberOfGame: Int = 0
  @State private var score: Int = 0

  init() {
    _appOption = State(wrappedValue: Option.allCases.randomElement() ?? .rock)
    _shouldWin = State(wrappedValue: Bool.random())
  }

  var body: some View {
    VStack(spacing: 40) {
      Spacer()
      questionView
      Spacer()
      guessAnswerView
      Spacer()
      Spacer()
      Spacer()
      Text("Score: \(score)")
        .padding(.bottom, 50)
    }
    .alert(isPresented: $didGameFinished) {
      Alert(title: Text("Game over"), message: Text("Your score is \(score) out of \(maxNumberOfGame)"), dismissButton:. default(Text("Reset"), action: didReset))
    }
  }


}

// MARK: -SubViews
private extension ContentView {
  var questionView: some View {
    VStack(spacing: .zero) {
      Image(appOption.rawValue)
        .resizable()
        .frame(width: 100, height: 100)
      HStack(spacing: .zero) {
        Text(attributedString)
      }
    }
  }

  var guessAnswerView: some View {
    VStack(spacing: 10) {
      Text("What's your guess?")
      HStack(spacing: 10) {
        ForEach(options.shuffled(), id: \.self) { option in
          Button {
            didSelectAnOption(option)
          } label: {
            Image(option.rawValue)
              .resizable()
              .frame(width: 100, height: 100)
              .overlay {
                RoundedRectangle(cornerRadius: 5)
                  .stroke(.black, lineWidth: 1)
              }
          }
        }
      }
      .frame(maxWidth: .infinity)
    }
  }
}

// MARK: -Logic
private extension ContentView {
  var attributedString: AttributedString {
    let aimedResult: String = shouldWin ? "win" : "lose"
    var string = AttributedString("Try to \(aimedResult) against \(appOption.rawValue)!")

    guard let resultRange = string.range(of: aimedResult),
          let appOptionRange = string.range(of: appOption.rawValue) else {
      return string
    }

    string[resultRange].font = Font.system(.body).bold()
    string[appOptionRange].font = Font.system(.body).bold()
    return string
  }

  func didSelectAnOption(_ option: Option) {
    let correctAnswer: Option = shouldWin ? appOption.winningChoice : appOption.losingChoice
    if correctAnswer == option {
      score += 1
    } else {
      score -= 1
    }

    appOption = Option.allCases.randomElement() ?? .rock
    shouldWin = Bool.random()
    numberOfGame += 1
    didGameFinished = numberOfGame == maxNumberOfGame
  }

  private func didReset() {
    appOption = Option.allCases.randomElement() ?? .rock
    shouldWin = Bool.random()
    numberOfGame = 0
    score = 0
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
