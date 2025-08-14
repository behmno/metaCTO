import UIKit

class FeaturesViewController: UIViewController {
    
    // MARK: - Properties
    private var features: [Feature] = []
    private var currentPage = 1
    private let limit = 10
    private var totalPages = 1
    private var isLoading = false
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(FeatureTableViewCell.self, forCellReuseIdentifier: "FeatureCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.refreshControl = refreshControl
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let label = UILabel()
        label.text = "No features yet\nBe the first to propose a feature!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        loadFeatures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data when returning to this view
        refreshData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigation() {
        title = "Features"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addFeatureTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }
    
    // MARK: - Data Loading
    private func loadFeatures(page: Int = 1, shouldAppend: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        
        if !shouldAppend && features.isEmpty {
            activityIndicator.startAnimating()
        }
        
        APIService.shared.getFeatures(page: page, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                
                switch result {
                case .success(let paginatedFeatures):
                    if shouldAppend {
                        self?.features.append(contentsOf: paginatedFeatures.items)
                    } else {
                        self?.features = paginatedFeatures.items
                    }
                    
                    self?.currentPage = page
                    self?.totalPages = paginatedFeatures.pages
                    self?.updateUI()
                    
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        tableView.reloadData()
        
        if features.isEmpty {
            emptyStateView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStateView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        currentPage = 1
        loadFeatures(page: currentPage)
    }
    
    @objc private func addFeatureTapped() {
        let createFeatureVC = CreateFeatureViewController()
        let navController = UINavigationController(rootViewController: createFeatureVC)
        present(navController, animated: true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            AuthService.shared.logout()
            self.navigateToLogin()
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FeaturesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as! FeatureTableViewCell
        let feature = features[indexPath.row]
        cell.configure(with: feature)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeaturesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feature = features[indexPath.row]
        let detailVC = FeatureDetailViewController(feature: feature)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more data when reaching the end
        if indexPath.row == features.count - 1 && currentPage < totalPages {
            loadFeatures(page: currentPage + 1, shouldAppend: true)
        }
    }
}

// MARK: - FeatureTableViewCellDelegate
extension FeaturesViewController: FeatureTableViewCellDelegate {
    func didTapVote(for feature: Feature) {
        APIService.shared.voteFeature(featureId: feature.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Refresh the data to get updated vote counts
                    self?.refreshData()
                case .failure(let error):
                    self?.showAlert(title: "Voting Failed", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Custom Table View Cell
protocol FeatureTableViewCellDelegate: AnyObject {
    func didTapVote(for feature: Feature)
}

class FeatureTableViewCell: UITableViewCell {
    weak var delegate: FeatureTableViewCellDelegate?
    private var feature: Feature?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(voteButton)
        contentView.addSubview(voteCountLabel)
        
        voteButton.addTarget(self, action: #selector(voteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: voteButton.leadingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            voteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            voteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            voteButton.widthAnchor.constraint(equalToConstant: 44),
            voteButton.heightAnchor.constraint(equalToConstant: 44),
            
            voteCountLabel.topAnchor.constraint(equalTo: voteButton.bottomAnchor, constant: 4),
            voteCountLabel.centerXAnchor.constraint(equalTo: voteButton.centerXAnchor)
        ])
    }
    
    func configure(with feature: Feature) {
        self.feature = feature
        titleLabel.text = feature.title
        descriptionLabel.text = feature.description ?? "No description"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        authorLabel.text = "By \(feature.author.name)"
        
        voteCountLabel.text = "\(feature.voteCount)"
    }
    
    @objc private func voteButtonTapped() {
        guard let feature = feature else { return }
        delegate?.didTapVote(for: feature)
    }
}