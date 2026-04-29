# Amal App — Implementation Plan

Arabic language learning app for Korean missionaries traveling to Morocco & Mauritania, June 2026.

---

## Step 1: Project Setup
- Update `SceneDelegate.swift` to programmatically set root as `UINavigationController(rootViewController: ListViewController())`
- Remove storyboard dependency (delete Main.storyboard entry from Info.plist or set it up to be ignored)
- Rename/delete the default `ViewController.swift`
- Force light mode on window
- **Build & Run checkpoint:** App launches to a blank ListViewController

---

## Step 2: Data Layer
Create the following files:

### `WordItem.swift`
```
struct WordItem {
    let id: Int          // 1-100, determines order
    let arabic: String   // Arabic script e.g. مرحبا
    let romanized: String // English phonetic e.g. Marhaba
    let koreanPhonetic: String // Korean phonetic e.g. 마르하바
    let koreanMeaning: String  // Korean meaning e.g. 안녕하세요
}
```

### `WordStore.swift`
- Singleton: `WordStore.shared`
- `allWords: [WordItem]` — hardcoded 100 words in order of usefulness
- `unlockedCount: Int` — persisted in UserDefaults, starts at 5
- `unlockedWords: [WordItem]` — computed, returns first `unlockedCount` items
- `unlockNext()` — increments unlockedCount by 5 (max 100)

### `WordData.swift`
- The actual 100 Arabic words/phrases, ordered by usefulness:
  - Greetings & pleasantries (1-15)
  - Numbers (16-25)
  - Common responses / yes/no (26-35)
  - Directions & places (36-50)
  - Food & daily life (51-65)
  - Time & days (66-75)
  - Spiritual / gospel phrases (76-90)
  - Emergency & practical (91-100)

- **Build & Run checkpoint:** No crash, store initializes correctly

---

## Step 3: ListViewController
- Replace default ViewController with `ListViewController.swift`
- UITableView showing `WordStore.shared.unlockedWords`
- Each cell shows: arabic script + romanized (two-line cell)
- Locked items shown as greyed-out/locked below unlocked ones (optional visual)
- "Start Quiz" button pinned to bottom of screen
- Tap cell → push `DetailViewController` with selected index + unlocked word list
- **Build & Run checkpoint:** List shows first 5 words, tapping navigates (blank detail screen ok)

---

## Step 4: DetailViewController
- Flashcard card view centered on screen
- **Front side:** arabic script (large) + romanized (medium) + korean phonetic (small)
- **Back side:** korean meaning (large)
- Tap card → flip animation (`UIView.transition` with `.transitionFlipFromRight`)
- Swipe left → next item (within unlocked list), swipe right → previous item
- Navigation bar shows current index e.g. "3 / 10"
- **Build & Run checkpoint:** Flashcard flips, swipe navigates between words

---

## Step 5: Quiz Engine
Create `QuizEngine.swift`:

```
struct QuizSegment {
    let type: QuizType  // .a, .b, .c
    let items: [WordItem]  // 1 item for A/B, 5 items for C
}

enum QuizType { case a, b, c }

class QuizEngine {
    static func generateQuiz(from unlockedWords: [WordItem]) -> [QuizSegment]
}
```

Algorithm:
1. N = unlockedWords.count
2. Randomly pick C count: at least 1, at most N/5
3. Remaining = N - (cCount * 5) items → fill with random A/B
4. Build type array, shuffle it
5. Shuffle unlockedWords
6. Assign words to segments in order
7. Return [QuizSegment]

- **Build & Run checkpoint:** Unit-test the engine in console (print segments)

---

## Step 6: QuizViewController
- Receives `[QuizSegment]` from ListViewController
- Tracks current segment index and whether any answer was wrong
- Displays correct child question view based on `segment.type`:
  - Type A → `QuizTypeAView`
  - Type B → `QuizTypeBView`
  - Type C → `QuizTypeCView`
- Each child view calls back with pass/fail result
- On all correct → show congratulations alert → call `WordStore.shared.unlockNext()` → pop to List
- On any wrong → show "try again" alert → pop to List
- Progress indicator at top (e.g. "Question 2 of 6")
- **Build & Run checkpoint:** Quiz launches, progresses through segments, result handled

---

## Step 7: Quiz Type A
Create `QuizTypeAView.swift` (UIView subclass, not a VC):

Layout:
- Arabic script label (large, center)
- Romanized label (medium, center)
- Korean phonetic label (small, center)
- 3 answer buttons stacked vertically (Korean meanings)
  - 1 correct (from item.koreanMeaning)
  - 2 distractors (random koreanMeaning from other unlocked words)
- On correct tap: green flash → callback(correct: true)
- On wrong tap: red flash on tapped button, highlight correct → callback(correct: false)
- **Build & Run checkpoint:** Type A works, correct/wrong feedback visible

---

## Step 8: Quiz Type B
Create `QuizTypeBView.swift` (UIView subclass):

Layout:
- Korean meaning label (large, center)
- 3 answer buttons stacked vertically (romanized Arabic)
  - 1 correct (from item.romanized)
  - 2 distractors (random romanized from other unlocked words)
- Same correct/wrong feedback as Type A
- **Build & Run checkpoint:** Type B works

---

## Step 9: Quiz Type C
Create `QuizTypeCView.swift` (UIView subclass):

Layout:
- 5 rows, each row: `[ drop zone view ]  [ korean meaning label ]`
- Bottom area: 5 draggable chips (romanized Arabic), shuffled order
- Submit button (enabled only when all 5 zones are filled)
- Drag mechanic: `UIPanGestureRecognizer` on each chip
  - On drag end: snap to nearest empty drop zone if close enough, else return to original position
  - Chips already placed can be dragged back out and swapped
- On submit:
  - Check each row: chip.item == row.item
  - Correct rows flash green, wrong rows flash red
  - callback(correct: allCorrect)
- **Build & Run checkpoint:** Drag and drop works, submit evaluates correctly

---

## Step 10: Polish & Final QA
- Consistent typography and colors across all screens
- Navigation bar titles
- Empty state handling (edge cases)
- Test full flow: launch → list → detail → quiz → unlock → repeat
- Test persistence: unlock some words, close app, reopen — count preserved
- **Build & Run checkpoint:** Full end-to-end flow works

---

## Future (not in scope now)
- HomeViewController with progress bar
- Quiz Type D and Type E
- Audio pronunciation
- Multiple user profiles (for the 16 group members)
