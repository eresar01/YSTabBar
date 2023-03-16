//
//  YSTabBar.swift
//  YSTabBar
//
//  Created by Yerem Sargsyan on 13.02.23.
//


import UIKit

public protocol YSTabBarCoorinator: AnyObject {
    var item: UITabBarItem { get }
    var correctedInsets: UIEdgeInsets { get set }
}

public protocol YSTabBarDelegate: AnyObject {
    func tabBar(_ sender: YSTabBar, didSelectItemAt index: Int)
    func centerButton(_ sender: UIButton)
}

open class YSTabBar: UITabBarController {
    
    weak open var tabBarDelegate: YSTabBarDelegate?
    
    @IBInspectable public var radiusCenter: CGFloat = 35 {
        didSet {
            tabBarView.radiusCenter = radiusCenter
            updateTabBar()
        }
    }
    
    @IBInspectable public var heightForHole: CGFloat = 70 {
        didSet {
            updateTabBar()
        }
    }
    
    @IBInspectable public var heightForConvex: CGFloat = 90 {
        didSet {
            updateTabBar()
        }
    }
    
    @IBInspectable public var radiusButton: CGFloat = 30 {
        didSet {
            updateTabBar()
        }
    }

    public var tabBarStyle: YSViewStyle = .convex {
        didSet {
            tabBarView.style = tabBarStyle
            updateTabBar()
        }
    }
    
    @IBInspectable public var tintColor: UIColor? {
        didSet {
            tabBarView.tintColor = tintColor
            tabBarView.reloadApperance()
        }
    }

    @IBInspectable public var unselectedItemTintColor: UIColor? {
        didSet {
            tabBarView.unselectedItemTintColor = unselectedItemTintColor
            tabBarView.reloadApperance()
        }
    }

    @IBInspectable public var tabBarBackgroundColor: UIColor? {
        didSet {
            tabBarView.backgroundColor = tabBarBackgroundColor
            buttomView.backgroundColor = tabBarBackgroundColor
            tabBarView.reloadApperance()
        }
    }
    
    public var buttonConfiguration: UIButton.Configuration? {
        didSet {
            updateTabBar()
        }
    }
    
    public var items: [UITabBarItem] = [] {
        didSet {
            tabBarView.items = items
            tabBarView.reloadApperance()
        }
    }
    
    public var correctedInsets: UIEdgeInsets {
         var newInsets = UIEdgeInsets()
         newInsets.bottom += tabBarHeight + bottomSpacing
         return newInsets
     }
    
    lazy var tabBarView: YSTabBarView = {
        return YSTabBarView(style: tabBarStyle)
    }()

    lazy private var buttomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var bottomSpacing: CGFloat {
        if let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first,
           window.safeAreaInsets.bottom > 0 {
            return 0
        }
        return 12
    }
    
    fileprivate var tabBarHeight: CGFloat {
        return tabBarStyle == .hole ? heightForHole : heightForConvex
    }
    
    private var centerButton: UIButton?
    private var horizontalSpacing: CGFloat = 0

    override open var selectedIndex: Int {
        didSet {
            tabBarView.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open var selectedViewController: UIViewController? {
        didSet {
            tabBarView.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true

        setupTabBar()

        tabBarView.items = tabBar.items ?? []
        tabBarView.select(at: selectedIndex)
    }

    public func hideTabBar() {
        buttomView.isHidden = true
        tabBarView.isHidden = true
    }

    public func showTabBar() {
        buttomView.isHidden = false
        tabBarView.isHidden = false
    }

    fileprivate func setupTabBar() {
        view.addSubview(tabBarView)
        view.addSubview(buttomView)

        tabBarView.delegate = self

        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpacing),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            tabBarView.heightAnchor.constraint(equalToConstant: tabBarHeight),
            buttomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            buttomView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
            buttomView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
            buttomView.topAnchor.constraint(equalTo: tabBarView.bottomAnchor),
        ])
        
        self.view.bringSubviewToFront(tabBarView)
        tabBarView.tintColor = tintColor
        tabBarView.radiusCenter = radiusCenter
        tabBarView.unselectedItemTintColor = unselectedItemTintColor
    }

    fileprivate func updateTabBar() {
        self.view.removeFromSuperview()
        centerButton?.removeFromSuperview()
        setupTabBar()
        setupCentorButton()
    }
    
    fileprivate func setupCentorButton() {
        centerButton = nil
        centerButton = UIButton()
        guard let centerButton = centerButton else { return }
        centerButton.contentMode = .scaleToFill
        centerButton.configuration = buttonConfiguration ?? buttonDefoultConfigure
        centerButton.addTarget(self, action: #selector(buttonActon), for: .touchUpInside)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerButton)
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: self.tabBarView.centerXAnchor, constant: 0),
        ])
        switch tabBarStyle {
        case .hole:
            centerButton.heightAnchor.constraint(equalToConstant: (radiusButton * 2)).isActive = true
            centerButton.widthAnchor.constraint(equalToConstant: (radiusButton * 2)).isActive = true
            centerButton.bottomAnchor.constraint(equalTo: self.tabBarView.topAnchor, constant: radiusCenter - 5).isActive = true
        case .convex:
            let height = tabBarHeight - (2 * 16)
            centerButton.heightAnchor.constraint(equalToConstant: height).isActive = true
            centerButton.widthAnchor.constraint(equalToConstant: height).isActive = true
            centerButton.topAnchor.constraint(equalTo: self.tabBarView.topAnchor, constant: 16).isActive = true
        }
        centerButton.layoutSubviews()
        centerButton.layoutIfNeeded()
    }
    
    lazy var buttonDefoultConfigure: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "swift")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .orange
        return configuration
    }()
    
    @objc
    func buttonActon(_ sender: UIButton) {
        tabBarDelegate?.centerButton(sender)
    }
}

extension YSTabBar: YSTabBarViewDelegate {
    func customTabBar(_ sender: YSTabBarView, didSelectItemAt index: Int) {
        self.selectedIndex = index
        tabBarDelegate?.tabBar(self, didSelectItemAt: index)
    }
}
