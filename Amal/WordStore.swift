//
//  WordStore.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import Foundation

class WordStore {
    static let shared = WordStore()

    private let unlockedCountKey = "unlockedCount"
    private let initialUnlockCount = 5

    private init() {
        // Set default unlock count on first launch
        if UserDefaults.standard.object(forKey: unlockedCountKey) == nil {
            UserDefaults.standard.set(initialUnlockCount, forKey: unlockedCountKey)
        }
    }

    // MARK: - Public API

    var allWords: [WordItem] {
        return WordData.words
    }

    var unlockedCount: Int {
        return UserDefaults.standard.integer(forKey: unlockedCountKey)
    }

    var unlockedWords: [WordItem] {
        return Array(allWords.prefix(unlockedCount))
    }

    /// Unlocks the next 5 words. No-op if already at 100.
    func unlockNext() {
        let newCount = min(unlockedCount + 5, allWords.count)
        UserDefaults.standard.set(newCount, forKey: unlockedCountKey)
    }

    var isFullyUnlocked: Bool {
        return unlockedCount >= allWords.count
    }
}
