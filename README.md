## SwiftAutoLayout

SwiftAutoLayout is a very small DSL for Autolayout, intended to provide a more declarative way to express layout constraints. Here's a quick example:

```swift
// this:
let constraint = view1.al_left() == view2.al_right() * 2.0 + 10.0
		
// is equivalent to:
let constraint = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Right, multiplier: 2.0, constant: 10.0)
```

You may notice that this looks a lot like the linear equation that a constraint represents. From the [Apple documentation](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html):

> The relationship involves a first attribute, a relationship type, and a modified second value formed by multiplying an attribute by a constant factor and then adding another constant factor to it. In other words, constraints look very much like linear equations of the following form:
>
> `attribute1 == multiplier × attribute2 + constant`

SwiftAutolayout allows you to more effectively communicate the intent of a constraint by making the syntax more similar to the equation that it represents.

### Attributes

Layout attributes are defined as functions added in an extension of `UIView`. For example, `UIView.al_width()` and `UIView.al_height()` represent `NSLayoutAttribute.Width` and `NSLayoutAttribute.Height`, respectively. 

But why functions instead of properties? Properties would make for cleaner syntax, but functions had to be used because there is a bug as of Xcode 6 beta 2 that [causes the Swift compiler to segfault](https://gist.github.com/indragiek/0b163d8a1d998aa44ff6) when calling computed properties defined on class extensions.

### Relations

Relations are expressed using the overloaded operators `==` (`NSLayoutRelation.Equal`), `>=` (`NSLayoutRelation.GreaterThanOrEqual`), and `<=` (`NSLayoutRelation.LessThanOrEqual`). 

If you think I'm crazy for overloading operators like `==` (even though it doesn't have any pre-existing behaviour with structs), you can also use plain old function calls:

```swift
// this:
let constraint = view1.al_left() == view2.al_right() * 2.0 + 10.0
		
// is equivalent to:
let constraint = view1.al_left().equalTo(view2.al_right() * 2.0 + 10.0))
```
`equalTo()`, `greaterThanOrEqualTo()`, and `lessThanOrEqualTo()` are equivalent to `==`, `>=`, and `<=`, respectively.

### Tests?

####[**Yes.**](https://github.com/indragiek/SwiftAutoLayout/blob/master/SwiftAutoLayout/SwiftAutoLayoutTests/SwiftAutoLayoutTests.swift)

### Baby's First Swift OSS

As a sidenote, this is my first open-source Swift project! I had a lot of fun building this and am super excited about the future of the language, especially once the glaring compiler issues have been sorted out.

### Todo

* Support for OS X

### Contact

* Indragie Karunaratne
* [@indragie](http://twitter.com/indragie)
* [http://indragie.com](http://indragie.com)

### License

SwiftAutoLayout is licensed under the MIT License.
