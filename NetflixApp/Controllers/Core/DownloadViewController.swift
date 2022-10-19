//
//  DownloadViewController.swift
//  NetflixApp
//
//  Created by Fatih on 17.10.2022.
//

import UIKit

class DownloadViewController: UIViewController {
    private var Movies : [TitleItem] = [TitleItem]()
    
    
    
    private let downloadTable: UITableView = {
       
        let table = UITableView()
        table.register(TableviewForUpcoming.self, forCellReuseIdentifier: TableviewForUpcoming.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadTable.delegate = self
        downloadTable.dataSource = self
        view.addSubview(downloadTable)

        self.fetchLocalStorageForDownload()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    
    private func fetchLocalStorageForDownload() {

        
        DataManager.shared.CellTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let Movies):
                self?.Movies = Movies
                DispatchQueue.main.async {
                    self?.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}
extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataManager.shared.deleteTitleWith(model: Movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.Movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = Movies[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        
        CallerAPI.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
