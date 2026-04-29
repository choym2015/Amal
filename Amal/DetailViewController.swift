//
//  DetailViewController.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    // MARK: - Properties

    var words: [WordItem] = []
    var currentIndex: Int = 0
    private var isShowingFront = true
    private let synthesizer = AVSpeechSynthesizer()

    private static let speedRates: [Float] = [0.38, 0.43, 0.55]
    private static let speedLabels = ["0.5x", "0.75x", "1.0x"]

    private var speechRate: Float {
        let saved = UserDefaults.standard.float(forKey: "speechRate")
        return DetailViewController.speedRates.contains(saved) ? saved : 0.38
    }

    private let speedStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 3
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private var speedTextLabels: [UILabel] = []

    // MARK: - UI

    private let backButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("← 뒤로", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        b.setTitleColor(.amalGreen, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let prevButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("← 이전", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.setTitleColor(.amalGreen, for: .normal)
        b.setTitleColor(UIColor(hex: 0xcccccc), for: .disabled)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let nextButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("다음 →", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.setTitleColor(.amalGreen, for: .normal)
        b.setTitleColor(UIColor(hex: 0xcccccc), for: .disabled)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let counterLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        l.textColor = UIColor(hex: 0x888888)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // Container for the bottom half — flip is scoped to this view only
    private let bottomContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // Shadow wrapper (does not clip, so shadow is visible)
    private let cardShadowContainer: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.15
        v.layer.shadowRadius = 20
        v.layer.shadowOffset = CGSize(width: 0, height: 8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // Card (clips inner views so the split looks clean)
    private let cardView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 24
        v.layer.masksToBounds = true
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Front

    private let arabicTopHalf: UIView = {
        let v = UIView()
        v.backgroundColor = .amalGreen
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let arabicCategoryLabel: UILabel = {
        let l = UILabel()
        l.text = "ARABIC SCRIPT"
        l.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        l.textColor = UIColor.white.withAlphaComponent(0.6)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let arabicLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let romanizedBottomHalf: UIView = {
        let v = UIView()
        v.backgroundColor = .amalRed
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // Stack to vertically center romanized + phonetic together in the green half
    private let romanizedStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        l.textColor = UIColor.white.withAlphaComponent(0.8)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let tapHintLabel: UILabel = {
        let l = UILabel()
        l.text = "탭하여 의미 보기 →"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = UIColor.white.withAlphaComponent(0.6)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Back

    private let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .amalBackground
        v.isHidden = true
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let koreanCategoryLabel: UILabel = {
        let l = UILabel()
        l.text = "한국어 의미"
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.textColor = UIColor.amalGold
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let koreanMeaningLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        l.textColor = UIColor(hex: 0x1a1a1a)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let backTapHintLabel: UILabel = {
        let l = UILabel()
        l.text = "← 탭하여 돌아가기"
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = UIColor(hex: 0xaaaaaa)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let listenButton: UIButton = {
        let b = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .amalGreen
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: "speaker.wave.2.fill")
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        b.configuration = config
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .amalBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupTopBar()
        setupCard()
        setupListenButton()
        setupNavButtons()
        setupGestures()
        updateContent()
    }

    // MARK: - Setup

    private func setupTopBar() {
        view.addSubview(backButton)
        view.addSubview(counterLabel)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),

            counterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            counterLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
        ])
    }

    private func setupCard() {
        view.addSubview(cardShadowContainer)
        cardShadowContainer.addSubview(cardView)

        // Green top half — always visible
        cardView.addSubview(arabicTopHalf)
        arabicTopHalf.addSubview(romanizedStack)
        romanizedStack.addArrangedSubview(romanizedLabel)
        romanizedStack.addArrangedSubview(koreanPhoneticLabel)

        // Bottom flip container — only this part flips
        cardView.addSubview(bottomContainer)
        bottomContainer.addSubview(romanizedBottomHalf)   // front face (red)
        romanizedBottomHalf.addSubview(arabicCategoryLabel)
        romanizedBottomHalf.addSubview(arabicLabel)
        romanizedBottomHalf.addSubview(tapHintLabel)
        bottomContainer.addSubview(backView)              // back face (light)
        backView.addSubview(koreanCategoryLabel)
        backView.addSubview(koreanMeaningLabel)
        backView.addSubview(backTapHintLabel)

        NSLayoutConstraint.activate([
            // Shadow container
            cardShadowContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardShadowContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 24),
            cardShadowContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            cardShadowContainer.heightAnchor.constraint(equalTo: cardShadowContainer.widthAnchor, multiplier: 1.35),

            // Card fills shadow container
            cardView.topAnchor.constraint(equalTo: cardShadowContainer.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: cardShadowContainer.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cardShadowContainer.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: cardShadowContainer.bottomAnchor),

            // Green top half (55%)
            arabicTopHalf.topAnchor.constraint(equalTo: cardView.topAnchor),
            arabicTopHalf.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            arabicTopHalf.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            arabicTopHalf.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.5),

            romanizedStack.centerXAnchor.constraint(equalTo: arabicTopHalf.centerXAnchor),
            romanizedStack.centerYAnchor.constraint(equalTo: arabicTopHalf.centerYAnchor),
            romanizedStack.leadingAnchor.constraint(equalTo: arabicTopHalf.leadingAnchor, constant: 16),
            romanizedStack.trailingAnchor.constraint(equalTo: arabicTopHalf.trailingAnchor, constant: -16),

            // Bottom container (bottom 45%)
            bottomContainer.topAnchor.constraint(equalTo: arabicTopHalf.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            // Red front fills bottomContainer
            romanizedBottomHalf.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            romanizedBottomHalf.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            romanizedBottomHalf.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            romanizedBottomHalf.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),

            arabicCategoryLabel.topAnchor.constraint(equalTo: romanizedBottomHalf.topAnchor, constant: 16),
            arabicCategoryLabel.centerXAnchor.constraint(equalTo: romanizedBottomHalf.centerXAnchor),

            arabicLabel.centerXAnchor.constraint(equalTo: romanizedBottomHalf.centerXAnchor),
            arabicLabel.centerYAnchor.constraint(equalTo: romanizedBottomHalf.centerYAnchor),
            arabicLabel.leadingAnchor.constraint(equalTo: romanizedBottomHalf.leadingAnchor, constant: 16),
            arabicLabel.trailingAnchor.constraint(equalTo: romanizedBottomHalf.trailingAnchor, constant: -16),

            tapHintLabel.centerXAnchor.constraint(equalTo: romanizedBottomHalf.centerXAnchor),
            tapHintLabel.bottomAnchor.constraint(equalTo: romanizedBottomHalf.bottomAnchor, constant: -16),

            // Korean back fills bottomContainer
            backView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            backView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),

            koreanCategoryLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            koreanCategoryLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),

            koreanMeaningLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            koreanMeaningLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            koreanMeaningLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 24),
            koreanMeaningLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -24),

            backTapHintLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            backTapHintLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
        ])
    }

    private func setupListenButton() {
        // Build speed label stack
        for text in DetailViewController.speedLabels {
            let l = UILabel()
            l.text = text
            l.isUserInteractionEnabled = false
            speedTextLabels.append(l)
            speedStackView.addArrangedSubview(l)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSpeedStack))
        speedStackView.addGestureRecognizer(tap)

        // Horizontal row: [🔊 button]  [천천히 / 보통 / 빠르게]
        let rowStack = UIStackView(arrangedSubviews: [listenButton, speedStackView])
        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.spacing = 16
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rowStack)
        listenButton.addTarget(self, action: #selector(didTapListen), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rowStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rowStack.topAnchor.constraint(equalTo: cardShadowContainer.bottomAnchor, constant: 20),
        ])
        updateSpeedLabels()
    }

    private func setupNavButtons() {
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        NSLayoutConstraint.activate([
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        cardView.addGestureRecognizer(tap)
    }

    // MARK: - Content

    private func updateContent() {
        guard !words.isEmpty, currentIndex < words.count else { return }
        let word = words[currentIndex]
        arabicLabel.text = word.arabic
        koreanMeaningLabel.text = word.koreanMeaning
        counterLabel.text = "\(currentIndex + 1) / \(words.count)"

        // Romanized: "Kayfa halak / Labas?" (darija part in gold)
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

        // Korean phonetic: "카이파 할락 / 라바스?" (darija part in gold)
        let phoneticAttr = NSMutableAttributedString(
            string: word.koreanPhonetic,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.8),
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
        prevButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < words.count - 1
    }

    private func resetToFront() {
        guard !isShowingFront else { return }
        romanizedBottomHalf.isHidden = false
        backView.isHidden = true
        isShowingFront = true
        backView.layer.borderWidth = 0
    }

    // MARK: - Actions

    @objc private func didTapCard() {
        let options: UIView.AnimationOptions = isShowingFront ? .transitionFlipFromRight : .transitionFlipFromLeft
        isShowingFront.toggle()
        UIView.transition(with: bottomContainer, duration: 0.5, options: options) {
            self.romanizedBottomHalf.isHidden = !self.isShowingFront
            self.backView.isHidden = self.isShowingFront
        }
        backView.layer.borderColor = UIColor.amalGold.cgColor
        backView.layer.borderWidth = isShowingFront ? 0 : 2.5
    }

    @objc private func didTapNext() {
        guard currentIndex < words.count - 1 else { return }
        slideCard(toIndex: currentIndex + 1, direction: -1)
    }

    @objc private func didTapPrev() {
        guard currentIndex > 0 else { return }
        slideCard(toIndex: currentIndex - 1, direction: 1)
    }

    private func slideCard(toIndex index: Int, direction: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.cardShadowContainer.transform = CGAffineTransform(translationX: direction * self.view.bounds.width, y: 0)
            self.cardShadowContainer.alpha = 0
        } completion: { _ in
            self.currentIndex = index
            self.resetToFront()
            self.updateContent()
            self.cardShadowContainer.transform = CGAffineTransform(translationX: direction * -self.view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0) {
                self.cardShadowContainer.transform = .identity
                self.cardShadowContainer.alpha = 1
            }
        }
    }

    private func updateSpeedLabels() {
        let rate = speechRate
        let selectedIdx = DetailViewController.speedRates.firstIndex(of: rate) ?? 0
        for (i, label) in speedTextLabels.enumerated() {
            if i == selectedIdx {
                label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                label.textColor = .amalGold
            } else {
                label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                label.textColor = UIColor(hex: 0xbbbbbb)
            }
        }
    }

    @objc private func didTapSpeedStack() {
        let current = speechRate
        let idx = DetailViewController.speedRates.firstIndex(of: current) ?? 0
        let next = (idx + 1) % DetailViewController.speedRates.count
        UserDefaults.standard.set(DetailViewController.speedRates[next], forKey: "speechRate")
        updateSpeedLabels()
    }

    @objc private func didTapListen() {
        guard !words.isEmpty, currentIndex < words.count else { return }
        let word = words[currentIndex]

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)

        synthesizer.stopSpeaking(at: .immediate)

        let arabicUtterance = AVSpeechUtterance(string: word.arabic)
        arabicUtterance.voice = AVSpeechSynthesisVoice(language: "ar")
        arabicUtterance.rate = speechRate
        synthesizer.speak(arabicUtterance)

        if let darija = word.darija {
            let darijaUtterance = AVSpeechUtterance(string: darija)
            darijaUtterance.voice = AVSpeechSynthesisVoice(language: "ar")
            darijaUtterance.rate = speechRate
            darijaUtterance.preUtteranceDelay = 0.4
            synthesizer.speak(darijaUtterance)
        }
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
