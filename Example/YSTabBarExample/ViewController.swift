//
//  ViewController.swift
//  YSTabBarExample
//
//  Created by Yerem Sargsyan on 14.02.23.
//

import UIKit
import YSTabBar

class ViewController: YSTabBar  {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    func setupTabBar() {
        tabBarStyle = .hole
        let coordinators: [YSTabBarCoorinator] = [FirstVC(), SecondVC()]
        coordinators.forEach { $0.correctedInsets = correctedInsets }
        viewControllers = coordinators.compactMap { $0 as? UIViewController }
        items = coordinators.map { $0.item }
        tabBarDelegate = self
    }

}
extension ViewController: YSTabBarDelegate {
    func tabBar(_ sender: YSTabBar, didSelectItemAt index: Int) {
        print(index)
    }
    
    func centerButton(_ sender: UIButton) {
        print("action")
    }
    
}

