//
//  ListViewController.swift
//  Amal
//

import UIKit

class ListViewController: UIViewController {

    // MARK: - UI Elements

    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .amalGreen
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        v.layer.masksToBounds = true
        return v
    }()

    private let missionLabel: UILabel = {
        let l = UILabel()
        l.text = "모로코/모리타니아 소망음악회 2026"
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.textColor = UIColor.white.withAlphaComponent(0.75)
        l.letterSpacing(1.5)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Arabic Phrases"
        l.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let progressLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .amalGold
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let progressBarBackground: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
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

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .amalBackground
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 72
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        return tv
    }()

    private let quizButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Start Quiz", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .amalRed
        b.layer.cornerRadius = 16
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.2
        b.layer.shadowRadius = 8
        b.layer.shadowOffset = CGSize(width: 0, height: 4)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let toggleButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("한국어", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        b.layer.cornerRadius = 14
        b.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    // MARK: - Data

    private var words: [WordItem] = []
    private var isShowingKorean = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .amalBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHeader()
        setupQuizButton()
        setupTableView()
        quizButton.addTarget(self, action: #selector(didTapQuiz), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    // MARK: - Setup

    private func setupHeader() {
        view.addSubview(headerView)
        headerView.addSubview(missionLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(progressLabel)
        headerView.addSubview(progressBarBackground)
        progressBarBackground.addSubview(progressBarFill)
        headerView.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.26),

            toggleButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            missionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            missionLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6),

            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: progressLabel.topAnchor, constant: -16),

            progressLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            progressLabel.bottomAnchor.constraint(equalTo: progressBarBackground.topAnchor, constant: -6),

            progressBarBackground.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            progressBarBackground.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            progressBarBackground.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -24),
            progressBarBackground.heightAnchor.constraint(equalToConstant: 6),

            progressBarFill.topAnchor.constraint(equalTo: progressBarBackground.topAnchor),
            progressBarFill.leadingAnchor.constraint(equalTo: progressBarBackground.leadingAnchor),
            progressBarFill.heightAnchor.constraint(equalTo: progressBarBackground.heightAnchor),
        ])

        progressBarFillWidth = progressBarFill.widthAnchor.constraint(equalToConstant: 0)
        progressBarFillWidth?.isActive = true
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(WordCell.self, forCellReuseIdentifier: WordCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: quizButton.topAnchor, constant: -8),
        ])
    }

    private func setupQuizButton() {
        view.addSubview(quizButton)
        NSLayoutConstraint.activate([
            quizButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            quizButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            quizButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            quizButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    // MARK: - Data

    private func reloadData() {
        words = WordStore.shared.unlockedWords
        tableView.reloadData()
        updateProgress()
    }

    private func updateProgress() {
        let unlocked = WordStore.shared.unlockedCount
        let total = WordStore.shared.allWords.count
        progressLabel.text = "\(unlocked) / \(total) words unlocked"

        // Animate progress bar
        view.layoutIfNeeded()
        let ratio = CGFloat(unlocked) / CGFloat(total)
        let maxWidth = progressBarBackground.bounds.width
        progressBarFillWidth?.constant = maxWidth * ratio
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        })
    }

    // MARK: - Actions

    @objc private func didTapToggle() {
        isShowingKorean.toggle()
        if isShowingKorean {
            toggleButton.setTitle("عربي", for: .normal)
            toggleButton.backgroundColor = UIColor.amalGold.withAlphaComponent(0.85)
        } else {
            toggleButton.setTitle("한국어", for: .normal)
            toggleButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        }
        tableView.reloadData()
    }

    @objc private func didTapQuiz() {
        let quizVC = QuizViewController()
        quizVC.configure(with: WordStore.shared.unlockedWords)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseID, for: indexPath) as! WordCell
        cell.configure(with: words[indexPath.row], index: indexPath.row + 1, showingKorean: isShowingKorean)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.words = words
        vc.currentIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - WordCell

final class WordCell: UITableViewCell {
    static let reuseID = "WordCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.07
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.masksToBounds = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let indexLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        l.textColor = .amalGreen
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let arabicLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        l.textColor = UIColor(hex: 0x1a1a1a)
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let romanizedLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor(hex: 0x555555)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let chevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = UIColor(hex: 0xcccccc)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.addSubview(indexLabel)
        cardView.addSubview(arabicLabel)
        cardView.addSubview(romanizedLabel)
        cardView.addSubview(chevron)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            indexLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            indexLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),

            arabicLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
            arabicLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            arabicLabel.leadingAnchor.constraint(greaterThanOrEqualTo: indexLabel.trailingAnchor, constant: 8),

            romanizedLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            romanizedLabel.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 4),
            romanizedLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
            romanizedLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),

            chevron.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 8),
            chevron.heightAnchor.constraint(equalToConstant: 14),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 16).cgPath
    }

    func configure(with word: WordItem, index: Int, showingKorean: Bool) {
        indexLabel.text = "\(index)"
        if showingKorean {
            arabicLabel.text = word.koreanMeaning
            arabicLabel.textAlignment = .left
            arabicLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            let attr = NSMutableAttributedString(
                string: word.koreanPhonetic,
                attributes: [.foregroundColor: UIColor(hex: 0x555555)]
            )
            if let darijaPhonetic = word.darijaKoreanPhonetic {
                attr.append(NSAttributedString(
                    string: " / \(darijaPhonetic)",
                    attributes: [.foregroundColor: UIColor.amalGold]
                ))
            }
            romanizedLabel.attributedText = attr
        } else {
            arabicLabel.text = word.arabic
            arabicLabel.textAlignment = .right
            arabicLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            let attr = NSMutableAttributedString(
                string: word.romanized,
                attributes: [.foregroundColor: UIColor(hex: 0x555555)]
            )
            if let darija = word.darija {
                attr.append(NSAttributedString(
                    string: " / \(darija)",
                    attributes: [.foregroundColor: UIColor.amalGold]
                ))
            }
            romanizedLabel.attributedText = attr
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.12) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.cardView.alpha = highlighted ? 0.95 : 1.0
        }
    }
}

// MARK: - UILabel helpers

private extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributed = NSAttributedString(string: text, attributes: [.kern: spacing])
        self.attributedText = attributed
    }
}
