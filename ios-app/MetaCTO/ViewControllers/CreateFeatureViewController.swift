import UIKit

class CreateFeatureViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Propose a New Feature"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Share your idea for improving the platform"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Brief, descriptive title for your feature"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let titleHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep it concise and clear"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Describe your feature idea in detail..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "Explain what the feature should do and why it would be valuable"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Feature", for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupTextView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(titleTextField)
        view.addSubview(titleHelperLabel)
        view.addSubview(descriptionTextView)
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
        view.addSubview(descriptionHelperLabel)
        view.addSubview(createButton)
        createButton.addSubview(activityIndicator)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            titleHelperLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            titleHelperLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            titleHelperLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleHelperLabel.bottomAnchor, constant: 24),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 8),
            descriptionPlaceholderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -8),
            
            descriptionHelperLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 4),
            descriptionHelperLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            descriptionHelperLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
            
            createButton.topAnchor.constraint(equalTo: descriptionHelperLabel.bottomAnchor, constant: 40),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: createButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: createButton.centerYAnchor)
        ])
        
        updateCreateButton()
    }
    
    private func setupNavigation() {
        title = "New Feature"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    private func setupTextView() {
        descriptionTextView.delegate = self
        updatePlaceholder()
    }
    
    // MARK: - Actions
    @objc private func createButtonTapped() {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            showAlert(title: "Error", message: "Please enter a feature title")
            return
        }
        
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let featureDescription = description.isEmpty ? nil : description
        
        setLoading(true)
        
        APIService.shared.createFeature(title: title, description: featureDescription) { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                
                switch result {
                case .success:
                    self?.dismiss(animated: true)
                    
                case .failure(let error):
                    self?.showAlert(title: "Failed to Create Feature", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButton()
    }
    
    // MARK: - Helper Methods
    private func updateCreateButton() {
        let hasTitle = !(titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        createButton.isEnabled = hasTitle
        createButton.alpha = hasTitle ? 1.0 : 0.6
    }
    
    private func updatePlaceholder() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    private func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            createButton.setTitle("", for: .normal)
            createButton.setImage(nil, for: .normal)
            createButton.isEnabled = false
            titleTextField.isEnabled = false
            descriptionTextView.isEditable = false
        } else {
            activityIndicator.stopAnimating()
            createButton.setTitle("Create Feature", for: .normal)
            createButton.setImage(UIImage(systemName: "plus"), for: .normal)
            titleTextField.isEnabled = true
            descriptionTextView.isEditable = true
            updateCreateButton()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreateFeatureViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholder()
    }
}