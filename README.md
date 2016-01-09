## SwiftAutoLayout

SwiftAutoLayout is a tiny DSL for Autolayout intended to provide a more declarative way to express layout constraints. Here's a quick example:

```swift
// this:
let constraint = view1.left == view2.right * 2.0 + 10.0 ~ 750
		
// is equivalent to:
let constraint = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Right, multiplier: 2.0, constant: 10.0)
constraint.priority = 750
```

You may notice that this looks a lot like the linear equation that a constraint represents. From the [Apple documentation](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html):

> The relationship involves a first attribute, a relationship type, and a modified second value formed by multiplying an attribute by a constant factor and then adding another constant factor to it. In other words, constraints look very much like linear equations of the following form:
>
> `attribute1 == multiplier × attribute2 + constant`

SwiftAutoLayout allows you to more effectively communicate the intent of a constraint by making the syntax more similar to the equation that it represents.

### Installing

Use [Swift Package Manager](https://github.com/apple/swift-package-manager) or add `SwiftAutoLayout.xcodeproj` as a subproject and link against either `SwiftAutoLayout-iOS.framework` or `SwiftAutoLayout-Mac.framework` depending on the platform.

### Attributes

Layout attributes are defined as properties added in extensions of `UIView` and `UILayoutGuide` on iOS and `NSView` and `NSLayoutGuide` on OS X. For example, `UIView.width` and `UIView.height` represent `NSLayoutAttribute.Width` and `NSLayoutAttribute.Height`, respectively.

Layout guides (conforming to `UILayoutSupport`) in `UIViewController` are also supported using the `topLayoutGuideTop`, `topLayoutGuideBottom`, `bottomLayoutGuideTop`, and `bottomLayoutGuideBottom` properties.

### Relations

Relations are expressed using the overloaded operators `==` (`NSLayoutRelation.Equal`), `>=` (`NSLayoutRelation.GreaterThanOrEqual`), and `<=` (`NSLayoutRelation.LessThanOrEqual`). 

### Examples

#### Activating Single Constraint

```swift
(view1.left == view2.right * 2.0 + 10.0 ~ 750).active = true
```

#### Activating Multiple Constraints

```swift
NSLayoutConstraint.activateConstraints([
    view2.centerX == view2.superview!.centerX,
    view2.centerY == view2.superview!.centerY,
    view1.left == view2.right * 2.0 + 10.0 ~ 750,
    view1.top == view2.bottom + 5.0,
    view1.width >= 200,
    view1.height >= 400,
    view1.trailing == layoutGuide.trailing,
    view2.leading == layoutGuide.leading
])
```

### Contact

* Indragie Karunaratne
* [@indragie](http://twitter.com/indragie)
* [http://indragie.com](http://indragie.com)

### License

SwiftAutoLayout is licensed under the MIT License.
