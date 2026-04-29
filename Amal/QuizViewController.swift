//
//  QuizViewController.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController {

    // MARK: - Data

    private var segments: [QuizSegment] = []
    private var allWords: [WordItem] = []
    private var currentIndex = 0
    private var hadWrongAnswer = false

    func configure(with words: [WordItem]) {
        self.allWords = words
        self.segments = QuizEngine.generate(from: words)
    }

    // MARK: - UI

    private let backButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("← 뒤로", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        b.setTitleColor(.amalGreen, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let progressBarBackground: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: 0xe0e0e0)
        v.layer.cornerRadius = 3
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let progressBarFill: UIView = {
        let v = UIView()
        v.backgroundColor = .amalGold
        v.layer.cornerRadius = 3
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var progressBarFillWidth: NSLayoutConstraint?

    // Wraps card + buttons so we can center the group vertically
    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // Question card (green top / red bottom like flashcard front)
    private let cardShadowContainer: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.12
        v.layer.shadowRadius = 16
        v.layer.shadowOffset = CGSize(width: 0, height: 6)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let greenTopHalf: UIView = {
        let v = UIView()
        v.backgroundColor = .amalGreen
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let romanizedLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let koreanPhoneticLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        l.textColor = UIColor.white.withAlphaComponent(0.85)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let greenStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let redBottomHalf: UIView = {
        let v = UIView()
        v.backgroundColor = .amalRed
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let arabicScriptLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let arabicHintLabel: UILabel = {
        let l = UILabel()
        l.text = "ARABIC SCRIPT"
        l.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        l.textColor = UIColor.white.withAlphaComponent(0.55)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Type D (audio)

    private let synthesizer = AVSpeechSynthesizer()

    private let speakerContainerView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let listenInstructionLabel: UILabel = {
        let l = UILabel()
        l.text = "들어보세요!"
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textColor = UIColor(hex: 0x1a1a1a)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let speakerButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 52, weight: .medium)
        b.setImage(UIImage(systemName: "speaker.wave.3.fill", withConfiguration: config), for: .normal)
        b.tintColor = .white
        b.backgroundColor = .amalGreen
        b.layer.cornerRadius = 64
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.18
        b.layer.shadowRadius = 16
        b.layer.shadowOffset = CGSize(width: 0, height: 6)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let speakerHintLabel: UILabel = {
        let l = UILabel()
        l.text = "탭하여 발음 듣기"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = UIColor(hex: 0x888888)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()


    // MARK: - Type C (tap-to-match)

    private let typeCContainerView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var typeCWords: [WordItem] = []
    private var chipOrder: [Int] = []          // chipOrder[chipIndex] = wordIndex in typeCWords
    private var activeRowIndex: Int = 0
    private var placements: [Int: Int] = [:]   // rowIndex → chipIndex
    private var correctPlacements: Set<Int> = []

    private var chipButtons: [UIButton] = []
    private var dropZoneButtons: [UIButton] = []
    private var meaningLabels: [UILabel] = []

    // Answer buttons
    private var answerButtons: [UIButton] = []

    private let buttonsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .amalBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupTopBar()
        setupContent()
        setupTypeCView()
        showCurrentQuestion()
    }

    // MARK: - Setup

    private func setupTopBar() {
        view.addSubview(backButton)
        view.addSubview(progressBarBackground)
        progressBarBackground.addSubview(progressBarFill)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),

            progressBarBackground.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            progressBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBarBackground.heightAnchor.constraint(equalToConstant: 6),

            progressBarFill.topAnchor.constraint(equalTo: progressBarBackground.topAnchor),
            progressBarFill.leadingAnchor.constraint(equalTo: progressBarBackground.leadingAnchor),
            progressBarFill.heightAnchor.constraint(equalTo: progressBarBackground.heightAnchor),
        ])

        progressBarFillWidth = progressBarFill.widthAnchor.constraint(equalToConstant: 0)
        progressBarFillWidth?.isActive = true
    }

    private func setupContent() {
        // Build card internals
        cardShadowContainer.addSubview(cardView)
        cardView.addSubview(greenTopHalf)
        greenTopHalf.addSubview(greenStack)
        greenStack.addArrangedSubview(romanizedLabel)
        greenStack.addArrangedSubview(koreanPhoneticLabel)
        cardView.addSubview(redBottomHalf)
        redBottomHalf.addSubview(arabicHintLabel)
        redBottomHalf.addSubview(arabicScriptLabel)

        // Build answer buttons
        for i in 0..<3 {
            let b = UIButton(type: .system)
            b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            b.titleLabel?.numberOfLines = 0
            b.titleLabel?.textAlignment = .center
            b.setTitleColor(UIColor(hex: 0x1a1a1a), for: .normal)
            b.backgroundColor = .white
            b.layer.cornerRadius = 14
            b.layer.borderWidth = 1.5
            b.layer.borderColor = UIColor(hex: 0xe0e0e0).cgColor
            b.layer.shadowColor = UIColor.black.cgColor
            b.layer.shadowOpacity = 0.06
            b.layer.shadowRadius = 6
            b.layer.shadowOffset = CGSize(width: 0, height: 3)
            b.tag = i
            b.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
            b.heightAnchor.constraint(equalToConstant: 68).isActive = true
            answerButtons.append(b)
            buttonsStack.addArrangedSubview(b)
        }

        // Build speaker container for Type D
        speakerContainerView.addSubview(listenInstructionLabel)
        speakerContainerView.addSubview(speakerButton)
        speakerContainerView.addSubview(speakerHintLabel)
        speakerButton.addTarget(self, action: #selector(didTapSpeaker), for: .touchUpInside)

        // Add card + speaker container + buttons into contentStack
        contentStack.addArrangedSubview(cardShadowContainer)
        contentStack.addArrangedSubview(speakerContainerView)
        contentStack.addArrangedSubview(buttonsStack)
        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            // Card fixed height
            cardShadowContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),

            // Center the whole group between progress bar and bottom
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),

            // Card internals
            cardView.topAnchor.constraint(equalTo: cardShadowContainer.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: cardShadowContainer.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cardShadowContainer.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: cardShadowContainer.bottomAnchor),

            greenTopHalf.topAnchor.constraint(equalTo: cardView.topAnchor),
            greenTopHalf.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            greenTopHalf.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            greenTopHalf.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.58),

            greenStack.centerXAnchor.constraint(equalTo: greenTopHalf.centerXAnchor),
            greenStack.centerYAnchor.constraint(equalTo: greenTopHalf.centerYAnchor),
            greenStack.leadingAnchor.constraint(equalTo: greenTopHalf.leadingAnchor, constant: 16),
            greenStack.trailingAnchor.constraint(equalTo: greenTopHalf.trailingAnchor, constant: -16),

            redBottomHalf.topAnchor.constraint(equalTo: greenTopHalf.bottomAnchor),
            redBottomHalf.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            redBottomHalf.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            redBottomHalf.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            arabicHintLabel.topAnchor.constraint(equalTo: redBottomHalf.topAnchor, constant: 10),
            arabicHintLabel.centerXAnchor.constraint(equalTo: redBottomHalf.centerXAnchor),

            arabicScriptLabel.centerXAnchor.constraint(equalTo: redBottomHalf.centerXAnchor),
            arabicScriptLabel.centerYAnchor.constraint(equalTo: redBottomHalf.centerYAnchor, constant: 4),
            arabicScriptLabel.leadingAnchor.constraint(equalTo: redBottomHalf.leadingAnchor, constant: 16),
            arabicScriptLabel.trailingAnchor.constraint(equalTo: redBottomHalf.trailingAnchor, constant: -16),
        ])

        // Speaker container constraints (same height slot as the card)
        NSLayoutConstraint.activate([
            speakerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),

            listenInstructionLabel.centerXAnchor.constraint(equalTo: speakerContainerView.centerXAnchor),
            listenInstructionLabel.topAnchor.constraint(equalTo: speakerContainerView.topAnchor, constant: 16),

speakerButton.centerXAnchor.constraint(equalTo: speakerContainerView.centerXAnchor),
            speakerButton.centerYAnchor.constraint(equalTo: speakerContainerView.centerYAnchor, constant: 8),
            speakerButton.widthAnchor.constraint(equalToConstant: 128),
            speakerButton.heightAnchor.constraint(equalToConstant: 128),

            speakerHintLabel.centerXAnchor.constraint(equalTo: speakerContainerView.centerXAnchor),
            speakerHintLabel.topAnchor.constraint(equalTo: speakerButton.bottomAnchor, constant: 14),
        ])
    }

    private func setupTypeCView() {
        view.addSubview(typeCContainerView)
        NSLayoutConstraint.activate([
            typeCContainerView.topAnchor.constraint(equalTo: progressBarBackground.bottomAnchor, constant: 12),
            typeCContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            typeCContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            typeCContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])

        // 5 match rows
        let rowsStack = UIStackView()
        rowsStack.axis = .vertical
        rowsStack.spacing = 8
        rowsStack.alignment = .fill
        rowsStack.distribution = .fillEqually

        for i in 0..<5 {
            let dropZone = UIButton(type: .system)
            dropZone.tag = i
            dropZone.setTitle("・・・", for: .normal)
            dropZone.setTitleColor(UIColor(hex: 0xbbbbbb), for: .normal)
            dropZone.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            dropZone.titleLabel?.numberOfLines = 2
            dropZone.backgroundColor = UIColor(hex: 0xf2f2f2)
            dropZone.layer.cornerRadius = 10
            dropZone.layer.borderWidth = 1.5
            dropZone.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
            dropZone.translatesAutoresizingMaskIntoConstraints = false
            dropZone.addTarget(self, action: #selector(didTapDropZone(_:)), for: .touchUpInside)
            dropZoneButtons.append(dropZone)

            let meaningLabel = UILabel()
            meaningLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            meaningLabel.textColor = UIColor(hex: 0x1a1a1a)
            meaningLabel.textAlignment = .right
            meaningLabel.numberOfLines = 2
            meaningLabel.adjustsFontSizeToFitWidth = true
            meaningLabel.minimumScaleFactor = 0.8
            meaningLabel.translatesAutoresizingMaskIntoConstraints = false
            meaningLabels.append(meaningLabel)

            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(dropZone)
            rowView.addSubview(meaningLabel)
            NSLayoutConstraint.activate([
                dropZone.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
                dropZone.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                dropZone.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: 0.48),
                dropZone.heightAnchor.constraint(equalTo: rowView.heightAnchor, constant: -6),

                meaningLabel.leadingAnchor.constraint(equalTo: dropZone.trailingAnchor, constant: 10),
                meaningLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
                meaningLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
            rowsStack.addArrangedSubview(rowView)
        }
        rowsStack.heightAnchor.constraint(equalToConstant: 5 * 54 + 4 * 8).isActive = true

        // Chips: 3 on row 1, 2 on row 2
        let chipsRow1 = UIStackView()
        chipsRow1.axis = .horizontal
        chipsRow1.spacing = 8
        chipsRow1.distribution = .fillEqually

        let chipsRow2 = UIStackView()
        chipsRow2.axis = .horizontal
        chipsRow2.spacing = 8
        chipsRow2.distribution = .fillEqually

        for i in 0..<5 {
            let chip = UIButton(type: .system)
            chip.tag = i
            chip.titleLabel?.numberOfLines = 0
            chip.titleLabel?.textAlignment = .center
            chip.backgroundColor = .white
            chip.layer.cornerRadius = 10
            chip.layer.borderWidth = 1.5
            chip.layer.borderColor = UIColor.amalGreen.cgColor
            chip.layer.shadowColor = UIColor.black.cgColor
            chip.layer.shadowOpacity = 0.06
            chip.layer.shadowRadius = 4
            chip.layer.shadowOffset = CGSize(width: 0, height: 2)
            chip.heightAnchor.constraint(equalToConstant: 80).isActive = true
            chip.translatesAutoresizingMaskIntoConstraints = false
            chip.addTarget(self, action: #selector(didTapChip(_:)), for: .touchUpInside)
            chipButtons.append(chip)
            if i < 3 { chipsRow1.addArrangedSubview(chip) }
            else { chipsRow2.addArrangedSubview(chip) }
        }
        // Spacer so chips 3,4 are same width as top row chips
        let chipSpacer = UIView()
        chipsRow2.addArrangedSubview(chipSpacer)

        let chipsStack = UIStackView(arrangedSubviews: [chipsRow1, chipsRow2])
        chipsStack.axis = .vertical
        chipsStack.spacing = 8
        chipsStack.alignment = .fill

        // Spacer between rows and chips
        let spacer = UIView()
        spacer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

        let outerStack = UIStackView(arrangedSubviews: [rowsStack, spacer, chipsStack])
        outerStack.axis = .vertical
        outerStack.spacing = 12
        outerStack.alignment = .fill
        outerStack.translatesAutoresizingMaskIntoConstraints = false

        typeCContainerView.addSubview(outerStack)
        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: typeCContainerView.topAnchor, constant: 8),
            outerStack.leadingAnchor.constraint(equalTo: typeCContainerView.leadingAnchor),
            outerStack.trailingAnchor.constraint(equalTo: typeCContainerView.trailingAnchor),
            outerStack.bottomAnchor.constraint(equalTo: typeCContainerView.bottomAnchor, constant: -8),
        ])
    }

    // MARK: - Quiz Logic

    private func showCurrentQuestion() {
        guard currentIndex < segments.count else { return }
        let segment = segments[currentIndex]
        updateProgressBar()
        switch segment.type {
        case .a: showTypeA(segment: segment)
        case .b: showTypeB(segment: segment)
        case .c: showTypeC(segment: segment)
        case .d: showTypeD(segment: segment)
        }
    }

    private func updateProgressBar() {
        view.layoutIfNeeded()
        let ratio = CGFloat(currentIndex + 1) / CGFloat(segments.count)
        let maxWidth = progressBarBackground.bounds.width
        progressBarFillWidth?.constant = maxWidth * ratio
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.view.layoutIfNeeded()
        }
    }

    private func showTypeA(segment: QuizSegment) {
        guard let word = segment.items.first else { return }

        contentStack.isHidden = false
        typeCContainerView.isHidden = true
        cardShadowContainer.isHidden = false
        speakerContainerView.isHidden = true
        koreanPhoneticLabel.isHidden = false
        arabicScriptLabel.text = word.arabic
        arabicHintLabel.text = "ARABIC SCRIPT"

        let romanizedAttr = NSMutableAttributedString(
            string: word.romanized,
            attributes: [.foregroundColor: UIColor.white,
                         .font: UIFont.systemFont(ofSize: 22, weight: .bold)]
        )
        if let darija = word.darija {
            romanizedAttr.append(NSAttributedString(
                string: " / \(darija)",
                attributes: [.foregroundColor: UIColor.amalGold,
                             .font: UIFont.systemFont(ofSize: 22, weight: .bold)]
            ))
        }
        romanizedLabel.attributedText = romanizedAttr

        let phoneticAttr = NSMutableAttributedString(
            string: word.koreanPhonetic,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.85),
                         .font: UIFont.systemFont(ofSize: 15, weight: .regular)]
        )
        if let darijaPhonetic = word.darijaKoreanPhonetic {
            phoneticAttr.append(NSAttributedString(
                string: " / \(darijaPhonetic)",
                attributes: [.foregroundColor: UIColor.amalGold.withAlphaComponent(0.85),
                             .font: UIFont.systemFont(ofSize: 15, weight: .regular)]
            ))
        }
        koreanPhoneticLabel.attributedText = phoneticAttr

        let distractors = QuizEngine.distractors(for: word, from: allWords)
        var choices = distractors + [word]
        choices.shuffle()

        for (i, button) in answerButtons.enumerated() {
            button.setAttributedTitle(nil, for: .normal)
            button.setTitle(choices[i].koreanMeaning, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.isEnabled = true
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(hex: 0xe0e0e0).cgColor
            button.setTitleColor(UIColor(hex: 0x1a1a1a), for: .normal)
            button.accessibilityValue = choices[i].id == word.id ? "correct" : "wrong"
        }
    }

    private func showTypeD(segment: QuizSegment) {
        guard let word = segment.items.first else { return }

        contentStack.isHidden = false
        typeCContainerView.isHidden = true
        cardShadowContainer.isHidden = true
        speakerContainerView.isHidden = false

        let distractors = QuizEngine.distractors(for: word, from: allWords)
        var choices = distractors + [word]
        choices.shuffle()

        for (i, button) in answerButtons.enumerated() {
            button.setAttributedTitle(nil, for: .normal)
            button.setTitle(choices[i].koreanMeaning, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.isEnabled = true
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(hex: 0xe0e0e0).cgColor
            button.setTitleColor(UIColor(hex: 0x1a1a1a), for: .normal)
            button.accessibilityValue = choices[i].id == word.id ? "correct" : "wrong"
        }
    }

    private func showTypeC(segment: QuizSegment) {
        contentStack.isHidden = true
        typeCContainerView.isHidden = false

        typeCWords = segment.items
        placements = [:]
        correctPlacements = []
        chipOrder = Array(0..<5).shuffled()
        activeRowIndex = 0

        for i in 0..<5 {
            meaningLabels[i].text = typeCWords[i].koreanMeaning
            resetDropZone(i)

            let word = typeCWords[chipOrder[i]]
            let attr = NSMutableAttributedString(
                string: word.romanized,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                    .foregroundColor: UIColor.amalGreen
                ]
            )
            attr.append(NSAttributedString(
                string: "\n" + word.koreanPhonetic,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 11, weight: .regular),
                    .foregroundColor: UIColor(hex: 0x888888)
                ]
            ))
            if let darija = word.darija {
                attr.append(NSAttributedString(
                    string: "\n" + darija,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 10, weight: .semibold),
                        .foregroundColor: UIColor.amalGold
                    ]
                ))
            }
            chipButtons[i].setAttributedTitle(attr, for: .normal)
        }
        updateChipAppearances()
        highlightActiveRow()
    }

    private func resetDropZone(_ row: Int) {
        let dz = dropZoneButtons[row]
        dz.setTitle("・・・", for: .normal)
        dz.setTitleColor(UIColor(hex: 0xbbbbbb), for: .normal)
        dz.backgroundColor = UIColor(hex: 0xf2f2f2)
        dz.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
    }

    private func fillDropZone(_ row: Int, chipIndex: Int) {
        let dz = dropZoneButtons[row]
        dz.setTitle(typeCWords[chipOrder[chipIndex]].romanized, for: .normal)
        dz.setTitleColor(UIColor(hex: 0x1a1a1a), for: .normal)
        dz.backgroundColor = .white
        dz.layer.borderColor = UIColor.amalGreen.cgColor
    }

    private func updateChipAppearances() {
        let placed = Set(placements.values)
        for i in 0..<chipButtons.count {
            let chip = chipButtons[i]
            if placed.contains(i) {
                chip.alpha = 0.35
                chip.isEnabled = false
            } else {
                chip.alpha = 1
                chip.isEnabled = true
            }
        }
    }

    private func highlightActiveRow() {
        for i in 0..<5 {
            if correctPlacements.contains(i) { continue }
            let dz = dropZoneButtons[i]
            if placements[i] != nil {
                dz.layer.borderColor = UIColor.amalGreen.cgColor
                dz.layer.borderWidth = 1.5
            } else if i == activeRowIndex {
                dz.layer.borderColor = UIColor.amalGold.cgColor
                dz.layer.borderWidth = 2.0
            } else {
                dz.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
                dz.layer.borderWidth = 1.5
            }
        }
    }

    @objc private func didTapChip(_ sender: UIButton) {
        let chipIndex = sender.tag
        let placed = Set(placements.values)
        guard !placed.contains(chipIndex) else { return }

        // Place chip in the active row
        placements[activeRowIndex] = chipIndex
        fillDropZone(activeRowIndex, chipIndex: chipIndex)
        updateChipAppearances()

        // Find next empty row (forward, then wrap)
        let nextEmpty = (activeRowIndex + 1..<5).first(where: { placements[$0] == nil })
            ?? (0..<activeRowIndex).first(where: { placements[$0] == nil })

        if let next = nextEmpty {
            activeRowIndex = next
            highlightActiveRow()
        } else {
            // All rows filled — auto-submit
            autoSubmit()
        }
    }

    @objc private func didTapDropZone(_ sender: UIButton) {
        let row = sender.tag
        if correctPlacements.contains(row) { return }
        guard placements[row] != nil else { return }

        // Remove chip and make this row active
        placements.removeValue(forKey: row)
        resetDropZone(row)
        activeRowIndex = row
        updateChipAppearances()
        highlightActiveRow()
    }

    private func autoSubmit() {
        var allCorrect = true
        for row in 0..<5 {
            guard let chip = placements[row] else { continue }
            let isCorrect = chipOrder[chip] == row
            let dz = dropZoneButtons[row]
            if isCorrect {
                correctPlacements.insert(row)
                dz.backgroundColor = UIColor(hex: 0x4CAF50)
                dz.layer.borderColor = UIColor(hex: 0x4CAF50).cgColor
                dz.setTitleColor(.white, for: .normal)
            } else {
                allCorrect = false
                hadWrongAnswer = true
                dz.backgroundColor = UIColor(hex: 0xE53935)
                dz.layer.borderColor = UIColor(hex: 0xE53935).cgColor
                dz.setTitleColor(.white, for: .normal)
            }
        }
        updateChipAppearances()

        if allCorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { self.advance() }
        } else {
            // Clear wrong rows after a moment so user can fix them
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let wrongRows = (0..<5).filter { !self.correctPlacements.contains($0) && self.placements[$0] != nil }.sorted()
                for row in wrongRows {
                    self.placements.removeValue(forKey: row)
                    self.resetDropZone(row)
                }
                if let first = wrongRows.first {
                    self.activeRowIndex = first
                }
                self.updateChipAppearances()
                self.highlightActiveRow()
            }
        }
    }

    @objc private func didTapSpeaker() {
        guard currentIndex < segments.count,
              let word = segments[currentIndex].items.first else { return }

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)

        synthesizer.stopSpeaking(at: .immediate)

        let arabicUtterance = AVSpeechUtterance(string: word.arabic)
        arabicUtterance.voice = AVSpeechSynthesisVoice(language: "ar")
        arabicUtterance.rate = 0.42
        synthesizer.speak(arabicUtterance)

        if let darija = word.darija {
            let darijaUtterance = AVSpeechUtterance(string: darija)
            darijaUtterance.voice = AVSpeechSynthesisVoice(language: "ar")
            darijaUtterance.rate = 0.42
            darijaUtterance.preUtteranceDelay = 0.4
            synthesizer.speak(darijaUtterance)
        }

        // Brief scale animation on the button
        UIView.animate(withDuration: 0.1, animations: {
            self.speakerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6) {
                self.speakerButton.transform = .identity
            }
        })
    }

    private func showTypeB(segment: QuizSegment) {
        guard let word = segment.items.first else { return }

        contentStack.isHidden = false
        typeCContainerView.isHidden = true
        cardShadowContainer.isHidden = false
        speakerContainerView.isHidden = true
        romanizedLabel.attributedText = nil
        koreanPhoneticLabel.attributedText = nil
        romanizedLabel.text = word.koreanMeaning
        koreanPhoneticLabel.isHidden = true
        arabicScriptLabel.text = word.arabic
        arabicHintLabel.text = "ARABIC SCRIPT"

        let distractors = QuizEngine.distractors(for: word, from: allWords)
        var choices = distractors + [word]
        choices.shuffle()

        for (i, button) in answerButtons.enumerated() {
            let choice = choices[i]
            // Line 1: romanized / darija
            let title = NSMutableAttributedString(
                string: choice.romanized,
                attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                             .foregroundColor: UIColor(hex: 0x1a1a1a)]
            )
            if let darija = choice.darija {
                title.append(NSAttributedString(
                    string: " / \(darija)",
                    attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                 .foregroundColor: UIColor.amalGold]
                ))
            }
            // Line 2: Korean phonetic / darija phonetic
            title.append(NSAttributedString(
                string: "\n" + choice.koreanPhonetic,
                attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular),
                             .foregroundColor: UIColor(hex: 0x777777)]
            ))
            if let darijaPhonetic = choice.darijaKoreanPhonetic {
                title.append(NSAttributedString(
                    string: " / \(darijaPhonetic)",
                    attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                 .foregroundColor: UIColor.amalGold]
                ))
            }
            button.setAttributedTitle(title, for: .normal)
            button.isEnabled = true
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(hex: 0xe0e0e0).cgColor
            button.accessibilityValue = choice.id == word.id ? "correct" : "wrong"
        }
    }

    @objc private func didTapAnswer(_ sender: UIButton) {
        let isCorrect = sender.accessibilityValue == "correct"

        // Disable all buttons immediately
        answerButtons.forEach { $0.isEnabled = false }

        if isCorrect {
            sender.backgroundColor = UIColor(hex: 0x4CAF50)
            sender.layer.borderColor = UIColor(hex: 0x4CAF50).cgColor
            sender.setTitleColor(.white, for: .normal)
        } else {
            hadWrongAnswer = true
            sender.backgroundColor = UIColor(hex: 0xE53935)
            sender.layer.borderColor = UIColor(hex: 0xE53935).cgColor
            sender.setTitleColor(.white, for: .normal)
            // Highlight the correct button
            answerButtons.first(where: { $0.accessibilityValue == "correct" }).map {
                $0.backgroundColor = UIColor(hex: 0x4CAF50)
                $0.layer.borderColor = UIColor(hex: 0x4CAF50).cgColor
                $0.setTitleColor(.white, for: .normal)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.advance()
        }
    }

    private func advance() {
        currentIndex += 1
        if currentIndex >= segments.count {
            showResult()
        } else {
            showCurrentQuestion()
        }
    }

    private func showResult() {
        if hadWrongAnswer {
            let alert = UIAlertController(
                title: "다시 도전해보세요! 💪",
                message: "모든 문제를 맞춰야 다음 단계로 넘어갈 수 있어요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        } else {
            let wasFullyUnlocked = WordStore.shared.isFullyUnlocked
            WordStore.shared.unlockNext()
            let newCount = WordStore.shared.unlockedCount

            let title = wasFullyUnlocked ? "완벽해요! 🎉" : "훌륭해요! 🎉"
            let message = wasFullyUnlocked
                ? "100개 단어를 모두 마스터했어요!"
                : "다음 5개 단어가 열렸어요! 이제 \(newCount)개를 공부할 수 있어요."

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "계속하기", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        }
    }

    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
