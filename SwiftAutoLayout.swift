//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

#if os(OSX)
    import AppKit
    typealias ALView = NSView
#elseif os(iOS)
    import UIKit
    typealias ALView = UIView
#endif

// Using class instead of a struct temporarily to work around a compiler bug when
// defining computed properties on class extensions that return types that are
// not bridgable to Objective-C (e.g. structs).
//
// Repro case: https://gist.github.com/indragiek/0b163d8a1d998aa44ff6
// rdar://17409615, OpenRadar: http://www.openradar.me/radar?id=4588084989526016
@objc class ALLayoutItem {
    let view: ALView
    let attribute: NSLayoutAttribute
    let multiplier: CGFloat = 1.0
    let constant: CGFloat = 0.0
    
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
    func relateTo(right: ALLayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
    }
    
    /// Builds a constraint by relating the item to a constant value.
    func relateToConstant(right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: right)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualTo(right: ALLayoutItem) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .LessThanOrEqual)
    }
}

/// Multiplies the operand's multiplier by the RHS value
@infix func * (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier * right, constant: left.constant)
}

/// Divides the operand's multiplier by the RHS value
@infix func / (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier / right, constant: left.constant)
}

/// Adds the RHS value to the operand's constant
@infix func + (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}

/// Subtracts the RHS value from the operand's constant
@infix func - (left: ALLayoutItem, right: CGFloat) -> ALLayoutItem {
	return ALLayoutItem(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}

/// Equivalent to NSLayoutRelation.Equal
@infix func == (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.equalTo(right)
}

/// Equivalent to NSLayoutRelation.Equal
@infix func == (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.equalToConstant(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
@infix func >= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.greaterThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
@infix func >= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualToConstant(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
@infix func <= (left: ALLayoutItem, right: ALLayoutItem) -> NSLayoutConstraint {
	return left.lessThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
@infix func <= (left: ALLayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualToConstant(right)
}

extension ALView {
    func al_operand(attribute: NSLayoutAttribute) -> ALLayoutItem {
        return ALLayoutItem(view: self, attribute: attribute)
    }
    
    /// Equivalent to NSLayoutAttribute.Left
    var al_left: ALLayoutItem {
        return al_operand(.Left)
    }
    
    /// Equivalent to NSLayoutAttribute.Right
    var al_right: ALLayoutItem {
        return al_operand(.Right)
    }
    
    /// Equivalent to NSLayoutAttribute.Top
    var al_top: ALLayoutItem {
        return al_operand(.Top)
    }
    
    /// Equivalent to NSLayoutAttribute.Bottom
    var al_bottom: ALLayoutItem {
        return al_operand(.Bottom)
    }
    
    /// Equivalent to NSLayoutAttribute.Leading
    var al_leading: ALLayoutItem {
        return al_operand(.Leading)
    }
    
    /// Equivalent to NSLayoutAttribute.Trailing
    var al_trailing: ALLayoutItem {
        return al_operand(.Trailing)
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
    
    /// Equivalent to NSLayoutAttribute.CenterY
    var al_centerY: ALLayoutItem {
        return al_operand(.CenterY)
    }
    
    /// Equivalent to NSLayoutAttribute.Baseline
    var al_baseline: ALLayoutItem {
        return al_operand(.Baseline)
    }
}
