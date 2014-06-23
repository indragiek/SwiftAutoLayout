//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

import UIKit

@objc class ALOperand {
    let view: UIView
    let attribute: NSLayoutAttribute
    let multiplier: CGFloat = 1.0
    let constant: CGFloat = 0.0
    
    init (view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }
    
    init (view: UIView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
    /// Builds a constraint by relating the item to another item.
    func relateTo(right: ALOperand, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
    }
    
    /// Builds a constraint by relating the item to a constant value.
    func relateToConstant(right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: right)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalTo(right: ALOperand) -> NSLayoutConstraint {
        return relateTo(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.Equal
    func equalToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .Equal)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualTo(right: ALOperand) -> NSLayoutConstraint {
        return relateTo(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.GreaterThanOrEqual
    func greaterThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .GreaterThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualTo(right: ALOperand) -> NSLayoutConstraint {
        return relateTo(right, relation: .LessThanOrEqual)
    }
    
    /// Equivalent to NSLayoutRelation.LessThanOrEqual
    func lessThanOrEqualToConstant(right: CGFloat) -> NSLayoutConstraint {
        return relateToConstant(right, relation: .LessThanOrEqual)
    }
}

/// Multiplies the operand's multiplier by the RHS value
@infix func * (left: ALOperand, right: CGFloat) -> ALOperand {
	return ALOperand(view: left.view, attribute: left.attribute, multiplier: left.multiplier * right, constant: left.constant)
}

/// Divides the operand's multiplier by the RHS value
@infix func / (left: ALOperand, right: CGFloat) -> ALOperand {
	return ALOperand(view: left.view, attribute: left.attribute, multiplier: left.multiplier / right, constant: left.constant)
}

/// Adds the RHS value to the operand's constant
@infix func + (left: ALOperand, right: CGFloat) -> ALOperand {
	return ALOperand(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant + right)
}

/// Subtracts the RHS value from the operand's constant
@infix func - (left: ALOperand, right: CGFloat) -> ALOperand {
	return ALOperand(view: left.view, attribute: left.attribute, multiplier: left.multiplier, constant: left.constant - right)
}

/// Equivalent to NSLayoutRelation.Equal
@infix func == (left: ALOperand, right: ALOperand) -> NSLayoutConstraint {
	return left.equalTo(right)
}

/// Equivalent to NSLayoutRelation.Equal
@infix func == (left: ALOperand, right: CGFloat) -> NSLayoutConstraint {
    return left.equalToConstant(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
@infix func >= (left: ALOperand, right: ALOperand) -> NSLayoutConstraint {
	return left.greaterThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.GreaterThanOrEqual
@infix func >= (left: ALOperand, right: CGFloat) -> NSLayoutConstraint {
    return left.greaterThanOrEqualToConstant(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
@infix func <= (left: ALOperand, right: ALOperand) -> NSLayoutConstraint {
	return left.lessThanOrEqualTo(right)
}

/// Equivalent to NSLayoutRelation.LessThanOrEqual
@infix func <= (left: ALOperand, right: CGFloat) -> NSLayoutConstraint {
    return left.lessThanOrEqualToConstant(right)
}

extension UIView {
    func al_operand(attribute: NSLayoutAttribute) -> ALOperand {
        return ALOperand(view: self, attribute: attribute)
    }
    
    //
    // These have to be functions rather than properties because as of Xcode 6 beta 2, there
    // is a compiler bug that causes a segfault when calling a property getter defined on
    // a class extension. Repro case: https://gist.github.com/indragiek/0b163d8a1d998aa44ff6
    //
    
    /// Equivalent to NSLayoutAttribute.Left
    var al_left: ALOperand {
        return al_operand(.Left)
    }
    
    /// Equivalent to NSLayoutAttribute.Right
    var al_right: ALOperand {
        return al_operand(.Right)
    }
    
    /// Equivalent to NSLayoutAttribute.Top
    var al_top: ALOperand {
        return al_operand(.Top)
    }
    
    /// Equivalent to NSLayoutAttribute.Bottom
    var al_bottom: ALOperand {
        return al_operand(.Bottom)
    }
    
    /// Equivalent to NSLayoutAttribute.Leading
    var al_leading: ALOperand {
        return al_operand(.Leading)
    }
    
    /// Equivalent to NSLayoutAttribute.Trailing
    var al_trailing: ALOperand {
        return al_operand(.Trailing)
    }
    
    /// Equivalent to NSLayoutAttribute.Width
    var al_width: ALOperand {
        return al_operand(.Width)
    }
    
    /// Equivalent to NSLayoutAttribute.Height
    var al_height: ALOperand {
        return al_operand(.Height)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterX
    var al_centerX: ALOperand {
        return al_operand(.CenterX)
    }
    
    /// Equivalent to NSLayoutAttribute.CenterY
    var al_centerY: ALOperand {
        return al_operand(.CenterY)
    }
    
    /// Equivalent to NSLayoutAttribute.Baseline
    var al_baseline: ALOperand {
        return al_operand(.Baseline)
    }
}
