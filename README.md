# YSTabBar

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![convex](https://user-images.githubusercontent.com/26775714/218567399-4e8e16e2-7081-418e-a482-d1c480ab9650.gif)
![hole](https://user-images.githubusercontent.com/26775714/218567408-230461ab-c91a-495a-af3c-dfde4c4b2e38.gif)
![holeFourItems](https://user-images.githubusercontent.com/26775714/218567412-33deae73-171d-4240-827f-3c30110a7a67.gif)

## Requirements

- Xcode 14+
- Swift 5+
- iOS 15+

## Installation

YSTabBar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YSTabBar'
```
## About

YSTabBar is fully customizable tab bar controller which has unique center item. 

## Usage

YSTabBar has 2 styles - convex and hole

```swift

tabBarStyle = .convex
```

```swift

tabBarStyle = .hole
```
The simplest use-case is setting a TabBarController

```swift
import YSTabBar

class MyTabBar: YSTabBar 

tabBarStyle = .hole
let coordinators: [YSTabBarCoorinator] = [FirstVC(), SecondVC()]
coordinators.forEach { $0.correctedInsets = correctedInsets }
viewControllers = coordinators.compactMap { $0 as? UIViewController }
items = coordinators.map { $0.item }
```
use-case for ViewController

```swift
import YSTabBar

class FirstVC: UIViewController, YSTabBarCoorinator {
    
let item: UITabBarItem = {
    let icon = UIImage(systemName: "person")
    let item = UITabBarItem(title: "FirstVC", image: icon, selectedImage: nil)
    return item
}()
    
var correctedInsets: UIEdgeInsets = .zero
```

## Author

Yerem Sargsyan eresar01@gmail.com

https://www.linkedin.com/in/eresar01/

## License

YSTabBar is available under the MIT license. See the LICENSE file for more info.
