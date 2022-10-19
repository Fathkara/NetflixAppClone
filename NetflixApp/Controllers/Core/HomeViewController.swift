//
//  HomeViewController.swift
//  NetflixApp
//
//  Created by Fatih on 17.10.2022.
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}



class HomeViewController: UIViewController {
    
    private var randomHeaderImage: Movie?
    private var headerView: MainHeroHeaderView?
    
    let sectionMovies: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTable)
        homeTable.delegate = self
        homeTable.dataSource = self
        view.backgroundColor = .systemBackground
        
        
        NavbarConfigure()
        
        headerView = MainHeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeTable.tableHeaderView = headerView
        ConfigureMainHeroHeaderView()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
    }
    private func ConfigureMainHeroHeaderView() {
        CallerAPI.shared.TrendingMovies { [weak self] result in
            switch result {
            case .success(let Movies):
                let selectedTitle = Movies.randomElement()
                
                self?.randomHeaderImage = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    private func NavbarConfigure() {
        var image = UIImage(named: "oldu")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    


}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMovies.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            CallerAPI.shared.TrendingMovies { result in
                switch result {
                    
                case .success(let Movies):
                    cell.configure(with: Movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
            
        case Sections.TrendingTv.rawValue:
            CallerAPI.shared.TrendingTv { result in
                switch result {
                case.success(let Movies):
                    cell.configure(with: Movies)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            CallerAPI.shared.Popular { result in
                switch result {
                case .success(let Movies):
                    cell.configure(with: Movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            
            CallerAPI.shared.UpcomingMovies { result in
                switch result {
                case .success(let Movies):
                    cell.configure(with: Movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            CallerAPI.shared.TopRated { result in
                switch result {
                case .success(let Movies):
                    cell.configure(with: Movies)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
       
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionMovies[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
