//
//  YSTabBarView.swift
//  YSTabBar
//
//  Created by Yerem Sargsyan on 13.02.23.
//

import UIKit

protocol YSTabBarViewDelegate: AnyObject {
    func customTabBar(_ sender: YSTabBarView, didSelectItemAt index: Int)
}

final class YSTabBarView: UIView {

    weak var delegate: YSTabBarViewDelegate?
    
    var radiusCenter: CGFloat = 35 {
        didSet {
            layoutSubviews()
        }
    }
    
    var style: YSViewStyle {
        didSet {
            layoutSubviews()
        }
    }
    
    var items: [UITabBarItem] = [] {
        didSet {
            if items.count % 2 != 0 {
                items.removeLast()
            }
            reloadViews()
        }
    }

    var unselectedItemTintColor: UIColor! = .black {
        didSet {
            reloadApperance()
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        reloadApperance()
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center

        return stackView
    }()
    
    init(style: YSViewStyle = .convex) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        self.style = .convex
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setupStackView()
        self.backgroundColor = .white
        tintColorDidChange()
    }
    
    func setupStackView() {
        addSubview(stackView)
    }

    func viewStyle(view: UIView, radius: CGFloat) {
        let width = view.layer.bounds.width
        let height = view.layer.bounds.height

        let path = style.viewStyle(width: width, height: height, radius: radius)
        // Creating a mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        maskLayer.fillColor = UIColor.red.cgColor
        // Setting the mask
        view.layer.mask = maskLayer
    }
    
    func add(item: UITabBarItem) {
        self.items.append(item)
        self.addButton(with: item.image!, title: item.title!, accessibilityIdentifier: item.accessibilityIdentifier)
    }

    func remove(item: UITabBarItem) {
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
        }
    }

    func reloadApperance() {
        buttons().forEach { button in
            button.selectedColor = tintColor
            button.unselectedColor = unselectedItemTintColor
        }
    }

    private func addButton(with image: UIImage, title: String, accessibilityIdentifier: String?) {
        let button = YSTabBarItemView(image: image, title: title)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = tintColor
        button.unselectedColor = unselectedItemTintColor

        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(sender:)))
        gesture.numberOfTapsRequired = 1
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        button.accessibilityIdentifier = accessibilityIdentifier
        self.stackView.addArrangedSubview(button)
    }

    func select(at index: Int, notifyDelegate: Bool = true) {
        for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
            if let button = view as? YSTabBarItemView {
                button.selectedColor = tintColor
                button.unselectedColor = unselectedItemTintColor
                button.isSelected = bIndex == index
            }
        }

        if notifyDelegate {
            self.delegate?.customTabBar(self, didSelectItemAt: index)
        }
    }

    func select(at index: Int) {
        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = tintColor
            button.unselectedColor = unselectedItemTintColor
            button.isSelected = bIndex == index
        }

        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        self.delegate?.customTabBar(self, didSelectItemAt: index)
    }

    private func reloadViews() {
        for button in (stackView.arrangedSubviews.compactMap { $0 as? YSTabBarItemView }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }

        for item in items {
            if let image = item.image {
                addButton(with: image, title: item.title!, accessibilityIdentifier: item.accessibilityIdentifier)
            } else {
                addButton(with: UIImage(), title: item.title!, accessibilityIdentifier: item.accessibilityIdentifier)
            }
        }
        stackViewConstraint()
        select(at: 0)
    }

    private func buttons() -> [YSTabBarItemView] {
        return stackView.arrangedSubviews.compactMap { $0 as? YSTabBarItemView }
    }

    fileprivate func stackViewConstraint() {
        guard !items.isEmpty else { return }
        let index = (items.count / 2) - 1
        let view1 = self.stackView.arrangedSubviews[index]
        let view2 = self.stackView.arrangedSubviews[index + 1]
        NSLayoutConstraint.activate([
            view2.leftAnchor.constraint(equalTo: view1.rightAnchor, constant: (radiusCenter * 2)),
        ])
    }
    
    @objc func buttonTapped(sender: YSTabBarItemView) {
        if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
            select(at: index)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }

        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? YSTabBarItemView }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }

        let buttonsDistances = zip(buttons, distances)

        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let topInsets: CGFloat = style == .hole ? 0 : (radiusCenter + (radiusCenter / 12))
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: topInsets, left: 0, bottom: 0, right: 0))
        viewStyle(view: self, radius: radiusCenter)
    }
}

fileprivate extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}


