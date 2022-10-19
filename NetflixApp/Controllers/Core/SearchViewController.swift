//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Fatih on 17.10.2022.
//

import UIKit

class SearchViewController: UIViewController {
    private var Movies: [Movie] = [Movie]()
    
    
    private let SearchForTableView: UITableView = {
        let table = UITableView()
        table.register(TableviewForUpcoming.self, forCellReuseIdentifier: TableviewForUpcoming.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(SearchForTableView)
        
        SearchForTableView.delegate = self
        SearchForTableView.dataSource = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        SearchMoviesCall()
        searchController.searchResultsUpdater = self
    }
    
    
    
    private func SearchMoviesCall() {
        CallerAPI.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let Movies):
                self?.Movies = Movies
                DispatchQueue.main.async {
                    self?.SearchForTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SearchForTableView.frame = view.bounds
    }
    
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableviewForUpcoming.identifier, for: indexPath) as? TableviewForUpcoming else {
            return UITableViewCell()
        }
        
        
        let title = Movies[indexPath.row]
        let model = UpcomingTitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = Movies[indexPath.row]
        
        guard let titleName = movie.original_title ?? movie.original_name else {
            return
        }
        
        
        CallerAPI.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else {
                  return
              }
        resultsController.delegate = self
        
        
        CallerAPI.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let Movies):
                    resultsController.Movies = Movies
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    func searchResultsViewControllerItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
