//
//  SecondVC.swift
//  YSTabBarExample
//
//  Created by Yerem Sargsyan on 14.02.23.
//

import UIKit
import YSTabBar

class SecondVC: UIViewController, YSTabBarCoorinator {

    let item: UITabBarItem = {
        let icon = UIImage(systemName: "map")
        let item = UITabBarItem(title: "SecondVC", image: icon, selectedImage: nil)
        return item
    }()
        
    var correctedInsets: UIEdgeInsets = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
    }

}
