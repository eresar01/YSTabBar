//
//  FirstVC.swift
//  YSTabBarExample
//
//  Created by Yerem Sargsyan on 14.02.23.
//

import UIKit
import YSTabBar

class FirstVC: UIViewController, YSTabBarCoorinator {

    let item: UITabBarItem = {
        let icon = UIImage(systemName: "person")
        let item = UITabBarItem(title: "FirstVC", image: icon, selectedImage: nil)
        return item
    }()
        
    var correctedInsets: UIEdgeInsets = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }

}
