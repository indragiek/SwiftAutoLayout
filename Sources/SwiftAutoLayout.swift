//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    public typealias View = NSView
    public typealias LayoutPriority = NSLayoutPriority
    
    @available(OSX 10.11, *)
    public typealias LayoutGuide = NSLayoutGuide
#elseif os(iOS) || os(tvOS)
    import UIKit
    public typealias View = UIView
    public typealias LayoutPriority = UILayoutPriority
    
    @available(iOS 9.0, *)
    public typealias LayoutGuide = UILayoutGuide
#endif

public protocol LayoutRegion: AnyObject {}
extension View: LayoutRegion {}

@available(iOS 9.0, OSX 10.11, *)
extension LayoutGuide: LayoutRegion {}

public struct XAxis {}
public struct YAxis {}
public struct Dimension {}

public struct LayoutItem<C> {
    public let item: AnyObject
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat
    public let constant: CGFloat
    
    private func constrain(secondItem: LayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: secondItem.item, attribute: secondItem.attribute, multiplier: secondItem.multiplier, constant: secondItem.constant)
    }
    
    private func constrain(constant: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: constant)
    }
    
    private func itemWithMultiplier(multiplier: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: multiplier, constant: self.constant)
    }
    
    private func itemWithConstant(constant: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: self.multiplier, constant: constant)
    }
}

public func *<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier * rhs)
}

public func /<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier / rhs)
}

public func +<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant + rhs)
}

public func -<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant - rhs)
}

public func ==<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .Equal)
}

public func ==(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .Equal)
}

public func >=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .GreaterThanOrEqual)
}

public func >=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .GreaterThanOrEqual)
}

public func <=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .LessThanOrEqual)
}

public func <=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.constrain(rhs, relation: .LessThanOrEqual)
}

private func layoutItem<C>(item: AnyObject, _ attribute: NSLayoutAttribute) -> LayoutItem<C> {
    return LayoutItem(item: item, attribute: attribute, multiplier: 1.0, constant: 0.0)
}

public extension LayoutRegion {
    public var left: LayoutItem<XAxis> { return layoutItem(self, .Left) }
    public var right: LayoutItem<XAxis> { return layoutItem(self, .Right) }
    public var top: LayoutItem<YAxis> { return layoutItem(self, .Top) }
    public var bottom: LayoutItem<YAxis> { return layoutItem(self, .Bottom) }
    public var leading: LayoutItem<XAxis> { return layoutItem(self, .Leading) }
    public var trailing: LayoutItem<XAxis> { return layoutItem(self, .Trailing) }
    public var width: LayoutItem<Dimension> { return layoutItem(self, .Width) }
    public var height: LayoutItem<Dimension> { return layoutItem(self, .Height) }
    public var centerX: LayoutItem<XAxis> { return layoutItem(self, .CenterX) }
    public var centerY: LayoutItem<YAxis> { return layoutItem(self, .CenterY) }
    public var baseline: LayoutItem<YAxis> { return layoutItem(self, .Baseline) }
}

#if os(iOS)
public extension UIViewController {
    public var topLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .Top)
    }
    
    public var topLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(topLayoutGuide, .Bottom)
    }
    
    public var bottomLayoutGuideTop: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .Top)
    }
    
    public var bottomLayoutGuideBottom: LayoutItem<YAxis> {
        return layoutItem(bottomLayoutGuide, .Bottom)
    }
}
#endif

infix operator ~ { associativity left precedence 120 }

public func ~(lhs: NSLayoutConstraint, rhs: LayoutPriority) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(item: lhs.firstItem, attribute: lhs.firstAttribute, relatedBy: lhs.relation, toItem: lhs.secondItem, attribute: lhs.secondAttribute, multiplier: lhs.multiplier, constant: lhs.constant)
    newConstraint.priority = rhs
    return newConstraint
}
