//
// MotivationalQuotesView.swift
// TrackWorkoutTracker
//
// Written by Claude Code on January 12, 2026
// User prompt: Add motivational quotes tab with daily quote feature
//

import SwiftUI

struct MotivationalQuotesView: View {
    @State private var currentQuote: Quote

    // Collection of motivational quotes for track and field athletes
    private let quotes: [Quote] = [
        Quote(text: "The will to win means nothing without the will to prepare.", author: "Juma Ikangaa"),
        Quote(text: "Run when you can, walk if you have to, crawl if you must; just never give up.", author: "Dean Karnazes"),
        Quote(text: "It's not about the shoes. It's about what you do in them.", author: "Michael Jordan"),
        Quote(text: "The only one who can tell you 'you can't win' is you and you don't have to listen.", author: "Jessica Ennis-Hill"),
        Quote(text: "If you want to run, run a mile. If you want to experience a different life, run a marathon.", author: "Emil Zátopek"),
        Quote(text: "Don't dream of winning, train for it.", author: "Mo Farah"),
        Quote(text: "Ask yourself: 'Can I give more?' The answer is usually: 'Yes'.", author: "Paul Tergat"),
        Quote(text: "Your body will argue that there is no justifiable reason to continue. Your only recourse is to call on your spirit.", author: "Tim Noakes"),
        Quote(text: "Running is nothing more than a series of arguments between the part of your brain that wants to stop and the part that wants to keep going.", author: "Unknown"),
        Quote(text: "The race is not always to the swift, but to those who keep running.", author: "Unknown"),
        Quote(text: "Pain is temporary. Pride is forever.", author: "Unknown"),
        Quote(text: "You have a choice. You can throw in the towel, or you can use it to wipe the sweat off your face.", author: "Gatorade"),
        Quote(text: "The miracle isn't that I finished. The miracle is that I had the courage to start.", author: "John Bingham"),
        Quote(text: "Every morning in Africa, a gazelle wakes up knowing it must outrun the fastest lion. It doesn't matter whether you're the lion or gazelle—when the sun comes up, you'd better be running.", author: "Unknown"),
        Quote(text: "The hardest step is the first one out the door.", author: "Unknown"),
        Quote(text: "Rest when you're done, not when you're tired.", author: "Unknown"),
        Quote(text: "A runner must run with dreams in their heart.", author: "Emil Zátopek"),
        Quote(text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis"),
        Quote(text: "The body achieves what the mind believes.", author: "Unknown"),
        Quote(text: "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.", author: "Christian D. Larson"),
        Quote(text: "Success isn't given. It's earned on the track, in the gym, and in the ring. It's earned with blood, sweat, and tears.", author: "Unknown"),
        Quote(text: "Champions keep playing until they get it right.", author: "Billie Jean King"),
        Quote(text: "The difference between the impossible and the possible lies in determination.", author: "Tommy Lasorda"),
        Quote(text: "It always seems impossible until it's done.", author: "Nelson Mandela"),
        Quote(text: "Your legs are not giving out. Your head is giving up. Keep going.", author: "Unknown")
    ]

    init() {
        // Get quote based on current day of year
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let quoteIndex = (dayOfYear - 1) % 25 // 25 quotes
        _currentQuote = State(initialValue: [
            Quote(text: "The will to win means nothing without the will to prepare.", author: "Juma Ikangaa"),
            Quote(text: "Run when you can, walk if you have to, crawl if you must; just never give up.", author: "Dean Karnazes"),
            Quote(text: "It's not about the shoes. It's about what you do in them.", author: "Michael Jordan"),
            Quote(text: "The only one who can tell you 'you can't win' is you and you don't have to listen.", author: "Jessica Ennis-Hill"),
            Quote(text: "If you want to run, run a mile. If you want to experience a different life, run a marathon.", author: "Emil Zátopek"),
            Quote(text: "Don't dream of winning, train for it.", author: "Mo Farah"),
            Quote(text: "Ask yourself: 'Can I give more?' The answer is usually: 'Yes'.", author: "Paul Tergat"),
            Quote(text: "Your body will argue that there is no justifiable reason to continue. Your only recourse is to call on your spirit.", author: "Tim Noakes"),
            Quote(text: "Running is nothing more than a series of arguments between the part of your brain that wants to stop and the part that wants to keep going.", author: "Unknown"),
            Quote(text: "The race is not always to the swift, but to those who keep running.", author: "Unknown"),
            Quote(text: "Pain is temporary. Pride is forever.", author: "Unknown"),
            Quote(text: "You have a choice. You can throw in the towel, or you can use it to wipe the sweat off your face.", author: "Gatorade"),
            Quote(text: "The miracle isn't that I finished. The miracle is that I had the courage to start.", author: "John Bingham"),
            Quote(text: "Every morning in Africa, a gazelle wakes up knowing it must outrun the fastest lion. It doesn't matter whether you're the lion or gazelle—when the sun comes up, you'd better be running.", author: "Unknown"),
            Quote(text: "The hardest step is the first one out the door.", author: "Unknown"),
            Quote(text: "Rest when you're done, not when you're tired.", author: "Unknown"),
            Quote(text: "A runner must run with dreams in their heart.", author: "Emil Zátopek"),
            Quote(text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis"),
            Quote(text: "The body achieves what the mind believes.", author: "Unknown"),
            Quote(text: "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.", author: "Christian D. Larson"),
            Quote(text: "Success isn't given. It's earned on the track, in the gym, and in the ring. It's earned with blood, sweat, and tears.", author: "Unknown"),
            Quote(text: "Champions keep playing until they get it right.", author: "Billie Jean King"),
            Quote(text: "The difference between the impossible and the possible lies in determination.", author: "Tommy Lasorda"),
            Quote(text: "It always seems impossible until it's done.", author: "Nelson Mandela"),
            Quote(text: "Your legs are not giving out. Your head is giving up. Keep going.", author: "Unknown")
        ][quoteIndex])
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // Icon
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)
                        .padding(.bottom, 10)

                    // Quote card
                    VStack(spacing: 20) {
                        Text(currentQuote.text)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.horizontal, 24)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("— \(currentQuote.author)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 20)

                    // Daily indicator
                    VStack(spacing: 8) {
                        Text("Today's Motivation")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        Text(Date.now.formatted(date: .long, time: .omitted))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Motivation")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Quote model
struct Quote {
    let text: String
    let author: String
}

#Preview {
    MotivationalQuotesView()
}
