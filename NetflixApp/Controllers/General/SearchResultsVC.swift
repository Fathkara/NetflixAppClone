//
//  SearchResultsVC.swift
//  NetflixApp
//
//  Created by Fatih on 18.10.2022.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsViewControllerItem(_ viewModel:TitlePreviewViewModel)
}

class SearchResultsVC: UIViewController {
    
    public var Movies: [Movie] = [Movie]()
    
    public weak var delegate: SearchResultsVCDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleForCVCell.self, forCellWithReuseIdentifier: TitleForCVCell.Identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self

        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
        
    }
    

}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleForCVCell.Identifier, for: indexPath) as? TitleForCVCell else {
            return UICollectionViewCell()
        }
        
        
        let movie = Movies[indexPath.row]
        cell.configure(with: movie.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let movie = Movies[indexPath.row]
        let titleName = movie.original_title ?? ""
        CallerAPI.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self!.delegate?.searchResultsViewControllerItem(TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
