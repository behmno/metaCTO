import UIKit

class FeatureDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let feature: Feature
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteCountChip: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thumbsUpImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featureIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vote", for: .normal)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    init(feature: Feature) {
        self.feature = feature
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Feature Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(voteCountChip)
        voteCountChip.addSubview(thumbsUpImageView)
        voteCountChip.addSubview(voteCountLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorContainerView)
        authorContainerView.addSubview(authorImageView)
        authorContainerView.addSubview(authorNameLabel)
        authorContainerView.addSubview(authorDateLabel)
        contentView.addSubview(featureIdLabel)
        contentView.addSubview(voteButton)
        voteButton.addSubview(activityIndicator)
        
        voteButton.addTarget(self, action: #selector(voteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: voteCountChip.leadingAnchor, constant: -12),
            
            voteCountChip.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            voteCountChip.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            voteCountChip.heightAnchor.constraint(equalToConstant: 32),
            
            thumbsUpImageView.leadingAnchor.constraint(equalTo: voteCountChip.leadingAnchor, constant: 12),
            thumbsUpImageView.centerYAnchor.constraint(equalTo: voteCountChip.centerYAnchor),
            thumbsUpImageView.widthAnchor.constraint(equalToConstant: 16),
            thumbsUpImageView.heightAnchor.constraint(equalToConstant: 16),
            
            voteCountLabel.leadingAnchor.constraint(equalTo: thumbsUpImageView.trailingAnchor, constant: 6),
            voteCountLabel.trailingAnchor.constraint(equalTo: voteCountChip.trailingAnchor, constant: -12),
            voteCountLabel.centerYAnchor.constraint(equalTo: voteCountChip.centerYAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            authorContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            authorContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            authorImageView.topAnchor.constraint(equalTo: authorContainerView.topAnchor, constant: 16),
            authorImageView.leadingAnchor.constraint(equalTo: authorContainerView.leadingAnchor, constant: 16),
            authorImageView.widthAnchor.constraint(equalToConstant: 40),
            authorImageView.heightAnchor.constraint(equalToConstant: 40),
            
            authorNameLabel.topAnchor.constraint(equalTo: authorContainerView.topAnchor, constant: 16),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            authorNameLabel.trailingAnchor.constraint(equalTo: authorContainerView.trailingAnchor, constant: -16),
            
            authorDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 4),
            authorDateLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 12),
            authorDateLabel.trailingAnchor.constraint(equalTo: authorContainerView.trailingAnchor, constant: -16),
            authorDateLabel.bottomAnchor.constraint(equalTo: authorContainerView.bottomAnchor, constant: -16),
            
            featureIdLabel.topAnchor.constraint(equalTo: authorContainerView.bottomAnchor, constant: 16),
            featureIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featureIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            voteButton.topAnchor.constraint(equalTo: featureIdLabel.bottomAnchor, constant: 32),
            voteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            voteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            voteButton.heightAnchor.constraint(equalToConstant: 50),
            voteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: voteButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: voteButton.centerYAnchor)
        ])
    }
    
    private func configureData() {
        titleLabel.text = feature.title
        voteCountLabel.text = "\(feature.voteCount)"
        descriptionLabel.text = feature.description ?? "No description provided."
        authorNameLabel.text = feature.author.name
        featureIdLabel.text = "Feature ID: \(feature.id)"
        
        // Format date
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: feature.createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .long
            displayFormatter.timeStyle = .short
            authorDateLabel.text = "Proposed on \(displayFormatter.string(from: date))"
        } else {
            authorDateLabel.text = "Proposed on \(feature.createdAt)"
        }
        
        updateVoteButton()
    }
    
    private func updateVoteButton() {
        voteButton.setTitle("Vote (\(feature.voteCount))", for: .normal)
    }
    
    // MARK: - Actions
    @objc private func voteButtonTapped() {
        setLoading(true)
        
        APIService.shared.voteFeature(featureId: feature.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                
                switch result {
                case .success:
                    self?.showAlert(title: "Success", message: "Vote recorded successfully!")
                    // In a real app, you might want to refresh the feature data
                    
                case .failure(let error):
                    self?.showAlert(title: "Voting Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            voteButton.setTitle("", for: .normal)
            voteButton.setImage(nil, for: .normal)
            voteButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            voteButton.setTitle("Vote (\(feature.voteCount))", for: .normal)
            voteButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            voteButton.isEnabled = true
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}