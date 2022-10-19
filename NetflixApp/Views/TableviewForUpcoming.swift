//
//  TableviewForUpcoming.swift
//  NetflixApp
//
//  Created by Fatih on 18.10.2022.
//

import UIKit

class TableviewForUpcoming: UITableViewCell {

    static let identifier = "TableviewForUpcoming"
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
        
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let PosterUIImageviewTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(playTitleButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(PosterUIImageviewTitle)
        
        AllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func AllConstraints() {
        let PosterUIImageviewTitleConstraints = [
            PosterUIImageviewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            PosterUIImageviewTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            PosterUIImageviewTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            PosterUIImageviewTitle.widthAnchor.constraint(equalToConstant: 100),
            
        
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: PosterUIImageviewTitle.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        NSLayoutConstraint.activate(PosterUIImageviewTitleConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    public func configure(with model:UpcomingTitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        PosterUIImageviewTitle.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    
    }
    
}
