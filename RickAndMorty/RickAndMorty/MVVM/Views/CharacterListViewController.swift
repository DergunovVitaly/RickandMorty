//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Vitaliy on 06.02.2025.
//

import UIKit
import SwiftUI
import Combine

class CharacterListViewController: UIViewController {
    
    private let viewModel: CharacterListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()

    private let refreshControl = UIRefreshControl()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No data"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    private let filterOptions = ["Alive", "Dead", "Unknown"]
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupTableViewPrefetching()
        bindViewModel()
        
        Task {
            await loadInitialData()
        }
    }
    
    private func setupUI() {
      
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(filterStackView)
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
   
        filterOptions.forEach { option in
            let button = createFilterChip(title: option)
            filterStackView.addArrangedSubview(button)
        }
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
     
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
      
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            filterStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
  
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createFilterChip(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
       
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(filterChipTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterChipTapped(_ sender: UIButton) {
        guard let filterTitle = sender.currentTitle else { return }
        
        switch filterTitle {
        case "All":
            viewModel.statusFilter = nil
        case "Alive":
            viewModel.statusFilter = "alive"
        case "Dead":
            viewModel.statusFilter = "dead"
        case "Unknown":
            viewModel.statusFilter = "unknown"
        default:
            break
        }
        
        Task {
            await viewModel.refresh()
        }
    }
    
    private func setupTableViewPrefetching() {
        tableView.prefetchDataSource = self
    }
    
    private func bindViewModel() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chars in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.emptyStateLabel.isHidden = !chars.isEmpty
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentErrorAlert(message: error)
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialData() async {
        activityIndicator.startAnimating()
        await viewModel.fetchCharacters(reset: true)
        activityIndicator.stopAnimating()
    }
    
    @objc private func refreshData() {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.retryLoadingData()
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    private func retryLoadingData() {
        Task {
            await viewModel.fetchCharacters(reset: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
                as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        let detailViewModel = CharacterDetailViewModel(character: character)
        let detailVC = UIHostingController(rootView: CharacterDetailView(viewModel: detailViewModel))
        navigationController?.pushViewController(detailVC, animated: true)
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        let threshold = contentHeight - (height * 1.2)
        if offsetY > threshold {
            Task {
                await viewModel.fetchCharacters()
            }
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension CharacterListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView,
                   prefetchRowsAt indexPaths: [IndexPath]) {
        
        let maxRow = indexPaths.map { $0.row }.max() ?? 0
        if maxRow > viewModel.characters.count - 5 {
            Task {
                await viewModel.fetchCharacters()
            }
        }
    }
}
