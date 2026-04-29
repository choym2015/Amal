//
//  WordItem.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import Foundation

struct WordItem {
    let id: Int                  // 1-100, determines display order
    let arabic: String           // Arabic script e.g. مرحبا
    let romanized: String        // Standard Arabic phonetic e.g. Marhaba
    let koreanPhonetic: String   // Korean phonetic e.g. 마르하바
    let koreanMeaning: String    // Korean meaning e.g. 안녕하세요
    let darija: String?                  // Moroccan Darija romanized e.g. Labas?
    let darijaKoreanPhonetic: String?    // Korean phonetic for Darija e.g. 라바스?

    init(id: Int, arabic: String, romanized: String, koreanPhonetic: String, koreanMeaning: String,
         darija: String? = nil, darijaKoreanPhonetic: String? = nil) {
        self.id = id
        self.arabic = arabic
        self.romanized = romanized
        self.koreanPhonetic = koreanPhonetic
        self.koreanMeaning = koreanMeaning
        self.darija = darija
        self.darijaKoreanPhonetic = darijaKoreanPhonetic
    }
}
