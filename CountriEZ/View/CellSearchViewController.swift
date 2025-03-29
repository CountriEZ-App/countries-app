//
//  CellSearchViewController.swift
//  CountriEZ
//
//  Created by Zelene Yosseline Isayana Montes Cantero on 12/03/25.
//

import UIKit


class CellSearchViewController: UITableViewCell {
    
    lazy var imageCountry: UIImageView = {
        let imageCountry = UIImageView()
        imageCountry.contentMode = .scaleAspectFit
        imageCountry.translatesAutoresizingMaskIntoConstraints = false
        return imageCountry
    }()
    
    lazy var labelCountry: UILabel = {
        let labelCountry = UILabel()
        labelCountry.textColor = Theme.textColor
        labelCountry.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        labelCountry.translatesAutoresizingMaskIntoConstraints = false
        return labelCountry
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageCountry, labelCountry])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imageCountry.widthAnchor.constraint(equalToConstant: 50)
        ])
//        imageCountry.heightAnchor.constraint(equalToConstant: 30).priority = .defaultLow
    }
}
