//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    public typealias ALView = NSView
#elseif os(iOS)
    import UIKit
    public typealias ALView = UIView
#endif

public struct ALLayoutItem {
    public let view: ALView
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat = 1.0
    public let constant: CGFloat = 0.0
    
    init (view: ALView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }
    
    init (view: ALView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
    // relateTo(), equalTo(), greaterThanOrEqualTo(), and lessThanOrEqualTo() used to be overloaded functions
    // instead of having two separately named functions (e.g. relateTo() and relateToConstant()) but they had
    // to be renamed due to a compiler bug where the compiler chose the wrong function to call.
    //
    // Repro case: http://cl.ly/3S0a1T0Q0S1D
    // rdar://17412596, OpenRadar: http://www.openradar.me/radar?id=5275533159956480
    
    /// Builds a constraint by relating the item to another item.
    public func relateTo(right: ALLayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
    }
    
    /// Builds a constraint by relating the item to a constant value.
    public func relateToConstant(right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: right)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    public func equalTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    public func equalToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    public func greaterThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    public func lessThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .LessThanOrEqual)
    }
}

/// Multiplies the operand's multiplier by the RHS value
public func * (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier * right, constant: left.constant)
}

/// Divides the operand's multiplier by the RHS value
public func / (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier / right, constant: left.constant)
}

/// Adds the RHS value to the operand's constant
public func + (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}

/// Subtracts the RHS value from the operand's constant
public func - (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}

/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.equalTo(right)
}

/// Equivalent to NSLayoutRelation.Equal
public func == (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.equalToConstant(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.greaterThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
public func >= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualToConstant(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.lessThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
public func <= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualToConstant(right)
}

public extension ALView {
    func al_operand(attribute: NSLayoutAttribute) -> ALLayoutItem {
        return ALLayoutItem(view: self, attribute: attribute)
    }
    
    /// Equivalent to NSLayoutAttribute.Left
    var al_left: ALLayoutItem {
        return al_operand(.Left)
    }
    
    /// Equivalent to NSLayoutAttribute.LeftMargin
    var al_leftMargin: ALLayoutItem {
        return al_operand(.LeftMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Right
    var al_right: ALLayoutItem {
        return al_operand(.Right)
    }
    
    /// Equivalent to NSLayoutAttribute.RightMargin
    var al_rightMargin: ALLayoutItem {
        return al_operand(.RightMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Top
    var al_top: ALLayoutItem {
        return al_operand(.Top)
    }
    
    /// Equivalent to NSLayoutAttribute.TopMargin
    var al_topMargin: ALLayoutItem {
        return al_operand(.TopMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Bottom
    var al_bottom: ALLayoutItem {
        return al_operand(.Bottom)
    }
    
    /// Equivalent to NSLayoutAttribute.BottomMargin
    var al_bottomMargin: ALLayoutItem {
        return al_operand(.BottomMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Leading
    var al_leading: ALLayoutItem {
        return al_operand(.Leading)
    }
    
    /// Equivalent to NSLayoutAttribute.LeadingMargin
    var al_leadingMargin: ALLayoutItem {
        return al_operand(.LeadingMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Trailing
    var al_trailing: ALLayoutItem {
        return al_operand(.Trailing)
    }
    
    /// Equivalent to NSLayoutAttribute.TrailingMargin
    var al_trailingMargin: ALLayoutItem {
        return al_operand(.TrailingMargin)
    }
    
    /// Equivalent to NSLayoutAttribute.Width
    var al_width: ALLayoutItem {
        return al_operand(.Width)
    }
    
    /// Equivalent to NSLayoutAttribute.Height
    var al_height: ALLayoutItem {
        return al_operand(.Height)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterX
    var al_centerX: ALLayoutItem {
        return al_operand(.CenterX)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterXWithinMargins
    var al_centerXWithinMargins: ALLayoutItem {
        return al_operand(.CenterXWithinMargins)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterY
    var al_centerY: ALLayoutItem {
        return al_operand(.CenterY)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterYWithinMargins
    var al_centerYWithinMargins: ALLayoutItem {
        return al_operand(.CenterYWithinMargins)
    }
    
    /// Equivalent to NSLayoutAttribute.Baseline
    var al_baseline: ALLayoutItem {
        return al_operand(.Baseline)
    }
    
    /// Equivalent to NSLayoutAttribute.FirstBaseline
    var al_firstbaseline: ALLayoutItem {
        return al_operand(.FirstBaseline)
    }
}

extension NSLayoutConstraint {
    func withPriority(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    // Using UILayoutPriority constants below causes compiler issue
    func withDefaultLowPriority() -> NSLayoutConstraint {
        return self.withPriority(250) // UILayoutPriorityDefaultLow
    }
    
    func withDefaultHighPriority() -> NSLayoutConstraint {
        return self.withPriority(750) // UILayoutPriorityDefaultHigh
    }
    
    func withFittingSizeLevelPriority() -> NSLayoutConstraint {
        return self.withPriority(50) // UILayoutPriorityFittingSizeLevel
    }
    
    func withRequiredPriority() -> NSLayoutConstraint {
        return self.withPriority(1000) // UILayoutPriorityRequired
    }
    
    func addConstraintTo(view: ALView) -> NSLayoutConstraint {
        view.addConstraint(self)
        return self
    }
}
