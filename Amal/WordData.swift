//
//  WordData.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import Foundation

struct WordData {
    static let words: [WordItem] = [

        // MARK: - Essential Greetings (1-15)
        WordItem(id: 1,  arabic: "السلام عليكم",        romanized: "As-salamu alaykum",            koreanPhonetic: "앗살라무 알라이쿰",      koreanMeaning: "평화가 당신에게 (이슬람식 인사)"),
        WordItem(id: 2,  arabic: "وعليكم السلام",        romanized: "Wa alaykum as-salam",          koreanPhonetic: "와알라이쿰 앗살람",      koreanMeaning: "당신에게도 평화를 (인사 응답)"),
        WordItem(id: 3,  arabic: "مرحبا",                romanized: "Marhaba",                      koreanPhonetic: "마르하바",              koreanMeaning: "안녕하세요"),
        WordItem(id: 9,  arabic: "كيف حالك",             romanized: "Kayfa halak",                  koreanPhonetic: "카이파 할락",            koreanMeaning: "어떻게 지내세요?",        darija: "Labas?",              darijaKoreanPhonetic: "라바스?"),
        WordItem(id: 10, arabic: "أنا بخير",             romanized: "Ana bikhair",                  koreanPhonetic: "아나 비카이르",          koreanMeaning: "잘 지내요",              darija: "Labas, alhamdulillah", darijaKoreanPhonetic: "라바스, 알함두릴라"),

        WordItem(id: 4,  arabic: "شكراً",                romanized: "Shukran",                      koreanPhonetic: "슈크란",                koreanMeaning: "감사합니다"),
        WordItem(id: 5,  arabic: "عفواً",                romanized: "Afwan",                        koreanPhonetic: "아프완",                koreanMeaning: "천만에요 / 죄송합니다",    darija: "Machi mushkil",       darijaKoreanPhonetic: "마쉬 무쉬킬"),
        WordItem(id: 16, arabic: "نعم",                  romanized: "Na'am",                        koreanPhonetic: "나암",                  koreanMeaning: "네",                     darija: "Iyyeh / Ah",          darijaKoreanPhonetic: "이예 / 아"),
        WordItem(id: 17, arabic: "لا",                   romanized: "La",                           koreanPhonetic: "라",                    koreanMeaning: "아니요"),
        WordItem(id: 18, arabic: "طيب",                  romanized: "Tayyib",                       koreanPhonetic: "타이입",                koreanMeaning: "좋아요 / 알겠어요",       darija: "Safi / Wakha",        darijaKoreanPhonetic: "사피 / 와카"),

        WordItem(id: 6,  arabic: "صباح الخير",           romanized: "Sabah al-khayr",               koreanPhonetic: "사바흐 알카이르",        koreanMeaning: "좋은 아침이에요"),
        WordItem(id: 7,  arabic: "مساء الخير",           romanized: "Masa al-khayr",                koreanPhonetic: "마사 알카이르",          koreanMeaning: "좋은 저녁이에요"),
        WordItem(id: 8,  arabic: "مع السلامة",           romanized: "Ma'a as-salama",               koreanPhonetic: "마아 앗살라마",          koreanMeaning: "안녕히 가세요",           darija: "Bslama",              darijaKoreanPhonetic: "브슬라마"),
        WordItem(id: 11, arabic: "أهلاً وسهلاً",         romanized: "Ahlan wa sahlan",              koreanPhonetic: "아흘란 와 사흘란",       koreanMeaning: "환영합니다",              darija: "Ahlan",               darijaKoreanPhonetic: "아흘란"),
        WordItem(id: 35, arabic: "إن شاء الله",          romanized: "Inshallah",                    koreanPhonetic: "인샬라",                koreanMeaning: "신의 뜻이라면"),

        // MARK: - Introductions & Key Phrases (16-30)
        WordItem(id: 36, arabic: "الحمد لله",            romanized: "Alhamdulillah",                koreanPhonetic: "알함두릴라",             koreanMeaning: "하나님께 감사"),
        WordItem(id: 12, arabic: "اسمي",                 romanized: "Ismi",                         koreanPhonetic: "이스미",                koreanMeaning: "제 이름은 ~입니다",       darija: "Smiti...",            darijaKoreanPhonetic: "스미티..."),
        WordItem(id: 13, arabic: "ما اسمك",              romanized: "Ma ismak",                     koreanPhonetic: "마 이스막",              koreanMeaning: "이름이 뭐예요?",          darija: "Shnu smitek?",        darijaKoreanPhonetic: "쉬누 스미텍?"),
        WordItem(id: 102,arabic: "تشرفنا",              romanized: "Tasharrafna",                  koreanPhonetic: "타샤르라프나",           koreanMeaning: "만나서 반가워요",         darija: "Tsharrafna",          darijaKoreanPhonetic: "차르라프나"),
        WordItem(id: 14, arabic: "إلى اللقاء",           romanized: "Ila al-liqa",                  koreanPhonetic: "일랄리카",              koreanMeaning: "또 만나요",               darija: "Htta men baad",       darijaKoreanPhonetic: "흐타 멘 바아드"),

        WordItem(id: 15, arabic: "من فضلك",              romanized: "Min fadlak",                   koreanPhonetic: "민 파들락",              koreanMeaning: "부탁합니다",              darija: "Afak",                darijaKoreanPhonetic: "아팍"),
        WordItem(id: 107,arabic: "آسف",                 romanized: "Asif",                         koreanPhonetic: "아시프",                koreanMeaning: "죄송합니다",              darija: "Smeh liya",           darijaKoreanPhonetic: "스메흐 리야"),
        WordItem(id: 20, arabic: "مش مشكلة",             romanized: "Mish mushkila",                koreanPhonetic: "미쉬 무쉬킬라",          koreanMeaning: "괜찮아요",               darija: "Machi mushkil",        darijaKoreanPhonetic: "마쉬 무쉬킬"),
        WordItem(id: 19, arabic: "لا أفهم",              romanized: "La afham",                     koreanPhonetic: "라 아프함",              koreanMeaning: "이해 못 해요",            darija: "Ma fhemtsh",          darijaKoreanPhonetic: "마 프헴쉬"),
        WordItem(id: 31, arabic: "أعد من فضلك",          romanized: "A'id min fadlak",              koreanPhonetic: "아이드 민 파들락",        koreanMeaning: "다시 말해 주세요"),

        WordItem(id: 101,arabic: "ببطء",                romanized: "Bibut'",                       koreanPhonetic: "비부트",                koreanMeaning: "천천히",                 darija: "Bshwiya",             darijaKoreanPhonetic: "브쉬야"),
        WordItem(id: 32, arabic: "هل تتكلم الإنجليزية",  romanized: "Hal tatakallam al-injiliziyya",koreanPhonetic: "할 타타칼람 알인질리지야",  koreanMeaning: "영어 할 줄 아세요?"),
        WordItem(id: 33, arabic: "أريد",                 romanized: "Uridu",                        koreanPhonetic: "우리두",                koreanMeaning: "원해요 / 주세요",         darija: "Bghit",               darijaKoreanPhonetic: "브깃"),
        WordItem(id: 37, arabic: "ما شاء الله",          romanized: "Mashallah",                    koreanPhonetic: "마샬라",                koreanMeaning: "정말 대단해요"),
        WordItem(id: 38, arabic: "بسم الله",             romanized: "Bismillah",                    koreanPhonetic: "비스밀라",              koreanMeaning: "하나님의 이름으로"),

        // MARK: - Practical Needs & Navigation (31-45)
        WordItem(id: 23, arabic: "أين",                  romanized: "Ayn",                          koreanPhonetic: "아인",                  koreanMeaning: "어디",                   darija: "Fin?",                darijaKoreanPhonetic: "핀?"),
        WordItem(id: 24, arabic: "حمام",                 romanized: "Hammam",                       koreanPhonetic: "함맘",                  koreanMeaning: "화장실"),
        WordItem(id: 30, arabic: "كم",                   romanized: "Kam",                          koreanPhonetic: "캄",                    koreanMeaning: "얼마예요?",              darija: "Bshhal?",             darijaKoreanPhonetic: "브샬?"),
        WordItem(id: 21, arabic: "مساعدة",               romanized: "Musa'ada",                     koreanPhonetic: "무사아다",              koreanMeaning: "도와주세요"),
        WordItem(id: 22, arabic: "مريض",                 romanized: "Marid",                        koreanPhonetic: "마리드",                koreanMeaning: "아파요"),

        WordItem(id: 25, arabic: "ماء",                  romanized: "Ma",                           koreanPhonetic: "마아",                  koreanMeaning: "물"),
        WordItem(id: 26, arabic: "هنا",                  romanized: "Huna",                         koreanPhonetic: "후나",                  koreanMeaning: "여기"),
        WordItem(id: 27, arabic: "هناك",                 romanized: "Hunak",                        koreanPhonetic: "후나크",                koreanMeaning: "저기"),
        WordItem(id: 115,arabic: "أخي",                 romanized: "Akhi",                         koreanPhonetic: "아키",                  koreanMeaning: "형제 / 친구야",           darija: "Khoya",               darijaKoreanPhonetic: "호야"),
        WordItem(id: 114,arabic: "صديقي",               romanized: "Sadiqi",                       koreanPhonetic: "사디키",                koreanMeaning: "내 친구",                darija: "Sahbi",               darijaKoreanPhonetic: "사흐비"),

        WordItem(id: 112,arabic: "هيا",                 romanized: "Hayya",                        koreanPhonetic: "하이야",                koreanMeaning: "가자! / 어서요",          darija: "Yallah",              darijaKoreanPhonetic: "얄라"),
        WordItem(id: 88, arabic: "الآن",                 romanized: "Al-an",                        koreanPhonetic: "알안",                  koreanMeaning: "지금",                   darija: "Daba",                darijaKoreanPhonetic: "다바"),
        WordItem(id: 84, arabic: "بعد",                  romanized: "Ba'd",                         koreanPhonetic: "바으드",                koreanMeaning: "나중에",                  darija: "Men baad",            darijaKoreanPhonetic: "멘 바아드"),
        WordItem(id: 83, arabic: "كثير",                 romanized: "Kathir",                       koreanPhonetic: "카시르",                koreanMeaning: "많이",                   darija: "Bzaf",                darijaKoreanPhonetic: "브자프"),
        WordItem(id: 82, arabic: "سريعاً",               romanized: "Sari'an",                      koreanPhonetic: "사리안",                koreanMeaning: "빨리",                   darija: "Bzerba",              darijaKoreanPhonetic: "브제르바"),

        // MARK: - Food & Market (46-60)
        WordItem(id: 39, arabic: "طعام",                 romanized: "Ta'am",                        koreanPhonetic: "타암",                  koreanMeaning: "음식",                   darija: "Makla",               darijaKoreanPhonetic: "마클라"),
        WordItem(id: 40, arabic: "خبز",                  romanized: "Khubz",                        koreanPhonetic: "후브즈",                koreanMeaning: "빵",                     darija: "Khobz",               darijaKoreanPhonetic: "호브즈"),
        WordItem(id: 41, arabic: "شاي",                  romanized: "Shay",                         koreanPhonetic: "샤이",                  koreanMeaning: "차 (음료)",               darija: "Atay",                darijaKoreanPhonetic: "아타이"),
        WordItem(id: 42, arabic: "قهوة",                 romanized: "Qahwa",                        koreanPhonetic: "카흐와",                koreanMeaning: "커피"),
        WordItem(id: 43, arabic: "لذيذ",                 romanized: "Ladhidh",                      koreanPhonetic: "라지즈",                koreanMeaning: "맛있어요",               darija: "Bnin",                darijaKoreanPhonetic: "브닌"),

        WordItem(id: 34, arabic: "غالي",                 romanized: "Ghali",                        koreanPhonetic: "갈리",                  koreanMeaning: "비싸요"),
        WordItem(id: 110,arabic: "غالي جداً",           romanized: "Ghali jiddan",                 koreanPhonetic: "갈리 짓단",              koreanMeaning: "너무 비싸요",             darija: "Ghali bzaf",          darijaKoreanPhonetic: "갈리 브자프"),
        WordItem(id: 111,arabic: "رخيص",                romanized: "Rakhis",                       koreanPhonetic: "라키스",                koreanMeaning: "싸요",                   darija: "Rkhis",               darijaKoreanPhonetic: "르키스"),
        WordItem(id: 45, arabic: "سوق",                  romanized: "Suq",                          koreanPhonetic: "수크",                  koreanMeaning: "시장"),
        WordItem(id: 44, arabic: "فندق",                 romanized: "Funduq",                       koreanPhonetic: "푼두크",                koreanMeaning: "호텔"),

        WordItem(id: 106,arabic: "شكراً جزيلاً",        romanized: "Shukran jazeelan",             koreanPhonetic: "슈크란 자질란",          koreanMeaning: "정말 감사합니다",         darija: "Shukran bzaf",        darijaKoreanPhonetic: "슈크란 브자프"),
        WordItem(id: 113,arabic: "حقاً",                romanized: "Haqqan?",                      koreanPhonetic: "하깐?",                 koreanMeaning: "정말요?",                darija: "Bssa7?",              darijaKoreanPhonetic: "브사흐?"),
        WordItem(id: 108,arabic: "ماذا",                romanized: "Madha?",                       koreanPhonetic: "마다?",                 koreanMeaning: "뭐예요?",                darija: "Ashno?",              darijaKoreanPhonetic: "아쉬누?"),
        WordItem(id: 109,arabic: "لماذا",               romanized: "Limadha?",                     koreanPhonetic: "리마다?",               koreanMeaning: "왜요?",                  darija: "'Lash?",              darijaKoreanPhonetic: "라쉬?"),
        WordItem(id: 28, arabic: "يمين",                 romanized: "Yameen",                       koreanPhonetic: "야민",                  koreanMeaning: "오른쪽"),

        // MARK: - Spiritual & Mission (61-75)
        WordItem(id: 56, arabic: "سلام",                 romanized: "Salam",                        koreanPhonetic: "살람",                  koreanMeaning: "평화"),
        WordItem(id: 57, arabic: "الله",                 romanized: "Allah",                        koreanPhonetic: "알라",                  koreanMeaning: "하나님"),
        WordItem(id: 58, arabic: "عيسى المسيح",          romanized: "Isa al-Masih",                 koreanPhonetic: "이사 알마시흐",          koreanMeaning: "예수 그리스도"),
        WordItem(id: 59, arabic: "حب",                   romanized: "Hubb",                         koreanPhonetic: "후브",                  koreanMeaning: "사랑"),
        WordItem(id: 68, arabic: "الله يحبك",            romanized: "Allah yuhibbuk",               koreanPhonetic: "알라 유힙북",            koreanMeaning: "하나님이 당신을 사랑해요"),

        WordItem(id: 60, arabic: "حياة",                 romanized: "Hayat",                        koreanPhonetic: "하야트",                koreanMeaning: "생명"),
        WordItem(id: 61, arabic: "إيمان",                romanized: "Iman",                         koreanPhonetic: "이만",                  koreanMeaning: "믿음"),
        WordItem(id: 62, arabic: "رجاء",                 romanized: "Raja",                         koreanPhonetic: "라자",                  koreanMeaning: "희망"),
        WordItem(id: 63, arabic: "نعمة",                 romanized: "Ni'ma",                        koreanPhonetic: "니으마",                koreanMeaning: "은혜"),
        WordItem(id: 64, arabic: "غفران",                romanized: "Ghufran",                      koreanPhonetic: "구프란",                koreanMeaning: "용서"),

        WordItem(id: 65, arabic: "خلاص",                 romanized: "Khelas",                       koreanPhonetic: "칼라스",                koreanMeaning: "구원"),
        WordItem(id: 66, arabic: "إنجيل",                romanized: "Injil",                        koreanPhonetic: "인질",                  koreanMeaning: "복음"),
        WordItem(id: 67, arabic: "أحبك",                 romanized: "Uhibbuk",                      koreanPhonetic: "우힙북",                koreanMeaning: "사랑해요"),
        WordItem(id: 69, arabic: "الله يحفظك",           romanized: "Allah yahfazak",               koreanPhonetic: "알라 야흐파작",           koreanMeaning: "하나님이 당신을 지키시길"),
        WordItem(id: 94, arabic: "نور",                  romanized: "Nur",                          koreanPhonetic: "누르",                  koreanMeaning: "빛"),

        // MARK: - Concert & People (76-90)
        WordItem(id: 91, arabic: "موسيقى",               romanized: "Musiqa",                       koreanPhonetic: "무시카",                koreanMeaning: "음악"),
        WordItem(id: 92, arabic: "حفلة",                 romanized: "Hafla",                        koreanPhonetic: "하플라",                koreanMeaning: "콘서트 / 파티"),
        WordItem(id: 93, arabic: "أغنية",                romanized: "Ughniyya",                     koreanPhonetic: "우그니야",              koreanMeaning: "노래"),
        WordItem(id: 70, arabic: "أنا",                  romanized: "Ana",                          koreanPhonetic: "아나",                  koreanMeaning: "나 / 저"),
        WordItem(id: 71, arabic: "أنت",                  romanized: "Anta",                         koreanPhonetic: "안타",                  koreanMeaning: "당신"),

        WordItem(id: 72, arabic: "نحن",                  romanized: "Nahnu",                        koreanPhonetic: "나흐누",                koreanMeaning: "우리"),
        WordItem(id: 73, arabic: "صديق",                 romanized: "Sadiq",                        koreanPhonetic: "사디크",                koreanMeaning: "친구"),
        WordItem(id: 74, arabic: "ناس",                  romanized: "Nas",                          koreanPhonetic: "나스",                  koreanMeaning: "사람들"),
        WordItem(id: 75, arabic: "أخ",                   romanized: "Akh",                          koreanPhonetic: "아흐",                  koreanMeaning: "형제"),
        WordItem(id: 76, arabic: "أخت",                  romanized: "Ukht",                         koreanPhonetic: "우흐트",                koreanMeaning: "자매"),

        WordItem(id: 77, arabic: "رجل",                  romanized: "Rajul",                        koreanPhonetic: "라줄",                  koreanMeaning: "남자"),
        WordItem(id: 78, arabic: "امرأة",                romanized: "Imra'a",                       koreanPhonetic: "임라아",                koreanMeaning: "여자"),
        WordItem(id: 79, arabic: "طفل",                  romanized: "Tifl",                         koreanPhonetic: "티플",                  koreanMeaning: "아이"),
        WordItem(id: 80, arabic: "مسجد",                 romanized: "Masjid",                       koreanPhonetic: "마스지드",              koreanMeaning: "모스크"),
        WordItem(id: 81, arabic: "هدية",                 romanized: "Hadiyya",                      koreanPhonetic: "하디야",                koreanMeaning: "선물"),

        // MARK: - Numbers (91-100)
        WordItem(id: 46, arabic: "واحد",                 romanized: "Wahid",                        koreanPhonetic: "와히드",                koreanMeaning: "1 (일)"),
        WordItem(id: 47, arabic: "اثنان",                romanized: "Ithnan",                       koreanPhonetic: "이스난",                koreanMeaning: "2 (이)"),
        WordItem(id: 48, arabic: "ثلاثة",                romanized: "Thalatha",                     koreanPhonetic: "살라사",                koreanMeaning: "3 (삼)"),
        WordItem(id: 49, arabic: "أربعة",                romanized: "Arba'a",                       koreanPhonetic: "아르바아",              koreanMeaning: "4 (사)"),
        WordItem(id: 50, arabic: "خمسة",                 romanized: "Khamsa",                       koreanPhonetic: "캄사",                  koreanMeaning: "5 (오)"),

        WordItem(id: 51, arabic: "ستة",                  romanized: "Sitta",                        koreanPhonetic: "싯타",                  koreanMeaning: "6 (육)"),
        WordItem(id: 52, arabic: "سبعة",                 romanized: "Sab'a",                        koreanPhonetic: "사브아",                koreanMeaning: "7 (칠)"),
        WordItem(id: 53, arabic: "ثمانية",               romanized: "Thamaniya",                    koreanPhonetic: "사마니야",              koreanMeaning: "8 (팔)"),
        WordItem(id: 54, arabic: "تسعة",                 romanized: "Tis'a",                        koreanPhonetic: "티스아",                koreanMeaning: "9 (구)"),
        WordItem(id: 55, arabic: "عشرة",                 romanized: "Ashara",                       koreanPhonetic: "아샤라",                koreanMeaning: "10 (십)"),

        // MARK: - Extended Conversations & Time (101-109)
        WordItem(id: 104,arabic: "من أين أنت",          romanized: "Min ayna anta?",               koreanPhonetic: "민 아이나 안타?",        koreanMeaning: "어디서 왔어요?",         darija: "Mn fin nta?",         darijaKoreanPhonetic: "므 핀 엔타?"),
        WordItem(id: 105,arabic: "أنا من",              romanized: "Ana min...",                   koreanPhonetic: "아나 민...",            koreanMeaning: "저는 ~에서 왔어요",      darija: "Ana mn...",           darijaKoreanPhonetic: "아나 므..."),
        WordItem(id: 103,arabic: "كم عمرك",             romanized: "Kam 'umruk?",                  koreanPhonetic: "캄 우므루크?",           koreanMeaning: "몇 살이에요?",           darija: "Shhal f'mrak?",       darijaKoreanPhonetic: "샬 프므락?"),
        WordItem(id: 29, arabic: "يسار",                 romanized: "Yassar",                       koreanPhonetic: "야사르",                koreanMeaning: "왼쪽"),
        WordItem(id: 85, arabic: "اليوم",                romanized: "Al-yawm",                      koreanPhonetic: "알야움",                koreanMeaning: "오늘"),

        WordItem(id: 86, arabic: "غداً",                 romanized: "Ghadan",                       koreanPhonetic: "가단",                  koreanMeaning: "내일"),
        WordItem(id: 87, arabic: "أمس",                  romanized: "Ams",                          koreanPhonetic: "암스",                  koreanMeaning: "어제"),
        WordItem(id: 89, arabic: "ليل",                  romanized: "Layl",                         koreanPhonetic: "라일",                  koreanMeaning: "밤"),
        WordItem(id: 90, arabic: "مساء",                 romanized: "Masa",                         koreanPhonetic: "마사",                  koreanMeaning: "저녁"),

        // MARK: - Emergency & Travel (110-115)
        WordItem(id: 95,  arabic: "مستشفى",              romanized: "Mustashfa",                    koreanPhonetic: "무스타쉬파",             koreanMeaning: "병원"),
        WordItem(id: 96,  arabic: "شرطة",                romanized: "Shurta",                       koreanPhonetic: "슈르타",                koreanMeaning: "경찰"),
        WordItem(id: 97,  arabic: "سفارة",               romanized: "Sifara",                       koreanPhonetic: "시파라",                koreanMeaning: "대사관"),
        WordItem(id: 98,  arabic: "مطار",                romanized: "Matar",                        koreanPhonetic: "마타르",                koreanMeaning: "공항"),
        WordItem(id: 99,  arabic: "جواز السفر",           romanized: "Jawaz as-safar",               koreanPhonetic: "자와즈 앗사파르",         koreanMeaning: "여권"),
        WordItem(id: 100, arabic: "سيارة",               romanized: "Sayyara",                      koreanPhonetic: "사야라",                koreanMeaning: "자동차"),
    ]
}
