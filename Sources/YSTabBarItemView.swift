//
//  YSTabBarItemView.swift
//  YSTabBar
//
//  Created by Yerem Sargsyan on 13.02.23.
//

import UIKit

final class YSTabBarItemView: UIView {
    lazy var titleLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var isSelected: Bool = false {
        didSet {
            reloadApperance()
        }
    }
    
    var selectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }
    
    var unselectedColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }
    
    var yAnchor: NSLayoutConstraint?
    
    init(forItem item: UITabBarItem) {
        super.init(frame: .zero)
        titleLabel.text = item.title
        iconImage.image = item.image
        setupUI()
    }

    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        iconImage.image = image
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(iconImage)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        yAnchor = iconImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        yAnchor?.isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 6).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
       
        titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        titleLabel.textAlignment = .center
        
        hideTitle()
        layoutIfNeeded()
    }

    func hideTitle() {
        yAnchor?.constant = 0
        titleLabel.isHidden = true
        iconImage.tintColor = unselectedColor
    }

    func showTitle() {
        yAnchor?.constant = -8
        titleLabel.textColor = selectedColor
        titleLabel.isHidden = false
        iconImage.tintColor = selectedColor
    }

    func reloadApperance() {
        isSelected ? showTitle() : hideTitle()
    }
}


