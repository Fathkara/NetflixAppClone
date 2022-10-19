//
//  UpComingViewController.swift
//  NetflixApp
//
//  Created by Fatih on 17.10.2022.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var Movies: [Movie] = [Movie]()
    
    private let UpcomingTableView: UITableView = {
        let table = UITableView()
        table.register(TableviewForUpcoming.self, forCellReuseIdentifier: TableviewForUpcoming.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(UpcomingTableView)
        UpcomingTableView.delegate = self
        UpcomingTableView.dataSource = self
        fetchAPIUpcoming()
    }
    
    private func fetchAPIUpcoming() {
        CallerAPI.shared.UpcomingMovies { [weak self] result in
            switch result {
            case .success(let Movies):
                self?.Movies = Movies
                DispatchQueue.main.async {
                    self?.UpcomingTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UpcomingTableView.frame = view.bounds
    }
    


}
extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableviewForUpcoming.identifier, for: indexPath) as? TableviewForUpcoming else {
            return UITableViewCell()
        }
        
        let title = Movies[indexPath.row]
        cell.configure(with: UpcomingTitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
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
