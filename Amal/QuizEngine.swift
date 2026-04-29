//
//  QuizEngine.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import Foundation

enum QuizType {
    case a  // Arabic cues (romanized + phonetic + script) → pick Korean meaning
    case b  // Korean meaning + Arabic script → pick romanized pronunciation
    case c  // tap-to-match: 5 romanized chips → 5 Korean meaning rows
    case d  // hear Arabic audio → pick Korean meaning
}

struct QuizSegment {
    let type: QuizType
    let items: [WordItem]   // 1 item for Type A/B, 5 items for Type C
}

class QuizEngine {

    /// Generates a quiz from the given unlocked words.
    /// If N >= 10: includes 1–(N-5)/5 Type C segments (each uses 5 words),
    /// remainder filled with a shuffled A/B/D mix. Entire sequence is then shuffled.
    /// If N < 10: A/B/D cycle only (not enough words for Type C).
    static func generate(from words: [WordItem]) -> [QuizSegment] {
        var pool = words.shuffled()

        guard pool.count >= 10 else {
            let types: [QuizType] = [.a, .b, .d]
            return pool.enumerated().map { (i, word) in
                QuizSegment(type: types[i % types.count], items: [word])
            }
        }

        // Randomly decide how many Type C segments (at least 1, leaving ≥5 words for A/B/D)
        let maxC = (pool.count - 5) / 5
        let cCount = Int.random(in: 1...max(1, maxC))

        var segments: [QuizSegment] = []

        // Build C segments
        for _ in 0..<cCount {
            let cWords = Array(pool.prefix(5))
            pool = Array(pool.dropFirst(5))
            segments.append(QuizSegment(type: .c, items: cWords))
        }

        // Remaining words → shuffled A/B/D
        let types: [QuizType] = [.a, .b, .d]
        let abdSegments = pool.enumerated().map { (i, word) in
            QuizSegment(type: types[i % types.count], items: [word])
        }
        segments.append(contentsOf: abdSegments)
        segments.shuffle()

        return segments
    }

    /// Returns `count` distractor WordItems from the pool, excluding the correct word.
    static func distractors(for word: WordItem, from pool: [WordItem], count: Int = 2) -> [WordItem] {
        let others = pool.filter { $0.id != word.id }
        return Array(others.shuffled().prefix(count))
    }
}
