//
//  SwiftAutoLayoutTests.swift
//  SwiftAutoLayoutTests
//
//  Created by Indragie on 6/17/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import XCTest
import SwiftAutoLayout

// The imports from SwiftAutoLayout don't cascade here
#if os(OSX)
    import AppKit
#elseif os(iOS)
    import UIKit
#endif


class SwiftAutoLayoutTests: XCTestCase {
    let view1 = ALView(frame: CGRectZero)
    let view2 = ALView(frame: CGRectZero)
    
    func testAttributeValues() {
        XCTAssertEqual(view1.al_left.attribute, NSLayoutAttribute.Left, "Expect ALView.al_left to have the attribute NSLayoutAttribute.Left")
        XCTAssertEqual(view1.al_leftMargin.attribute, NSLayoutAttribute.LeftMargin, "Expect ALView.al_leftMargin to have the attribute NSLayoutAttribute.LeftMargin")
        XCTAssertEqual(view1.al_right.attribute, NSLayoutAttribute.Right, "Expect ALView.al_right to have the attribute NSLayoutAttribute.Right")
        XCTAssertEqual(view1.al_rightMargin.attribute, NSLayoutAttribute.RightMargin, "Expect ALView.al_rightMargin to have the attribute NSLayoutAttribute.RightMargin")
        XCTAssertEqual(view1.al_top.attribute, NSLayoutAttribute.Top, "Expect ALView.al_top to have the attribute NSLayoutAttribute.Top")
        XCTAssertEqual(view1.al_topMargin.attribute, NSLayoutAttribute.TopMargin, "Expect ALView.al_topMargin to have the attribute NSLayoutAttribute.TopMargin")
        XCTAssertEqual(view1.al_bottom.attribute, NSLayoutAttribute.Bottom, "Expect ALView.al_bottom to have the attribute NSLayoutAttribute.Bottom")
        XCTAssertEqual(view1.al_bottomMargin.attribute, NSLayoutAttribute.BottomMargin, "Expect ALView.al_bottomMargin to have the attribute NSLayoutAttribute.BottomMargin")
        XCTAssertEqual(view1.al_leading.attribute, NSLayoutAttribute.Leading, "Expect ALView.al_leading to have the attribute NSLayoutAttribute.Leading")
        XCTAssertEqual(view1.al_leadingMargin.attribute, NSLayoutAttribute.LeadingMargin, "Expect ALView.al_leadingMargin to have the attribute NSLayoutAttribute.LeadingMargin")
        XCTAssertEqual(view1.al_trailing.attribute, NSLayoutAttribute.Trailing, "Expect ALView.al_trailing to have the attribute NSLayoutAttribute.Trailing")
        XCTAssertEqual(view1.al_trailingMargin.attribute, NSLayoutAttribute.TrailingMargin, "Expect ALView.al_trailingMargin to have the attribute NSLayoutAttribute.TrailingMargin")
        XCTAssertEqual(view1.al_width.attribute, NSLayoutAttribute.Width, "Expect ALView.al_width to have the attribute NSLayoutAttribute.Width")
        XCTAssertEqual(view1.al_height.attribute, NSLayoutAttribute.Height, "Expect ALView.al_height to have the attribute NSLayoutAttribute.Height")
        XCTAssertEqual(view1.al_centerX.attribute, NSLayoutAttribute.CenterX, "Expect ALView.al_centerX to have the attribute NSLayoutAttribute.CenterX")
        XCTAssertEqual(view1.al_centerXWithinMargins.attribute, NSLayoutAttribute.CenterXWithinMargins, "Expect ALView.al_centerXWithinMargins to have the attribute NSLayoutAttribute.CenterXWithinMargins")
        XCTAssertEqual(view1.al_centerY.attribute, NSLayoutAttribute.CenterY, "Expect ALView.al_centerY to have the attribute NSLayoutAttribute.CenterY")
        XCTAssertEqual(view1.al_centerYWithinMargins.attribute, NSLayoutAttribute.CenterYWithinMargins, "Expect ALView.al_centerYWithinMargins to have the attribute NSLayoutAttribute.CenterYWithinMargins")
        XCTAssertEqual(view1.al_baseline.attribute, NSLayoutAttribute.Baseline, "Expect ALView.al_baseline to have the attribute NSLayoutAttribute.Baseline")
        XCTAssertEqual(view1.al_firstbaseline.attribute, NSLayoutAttribute.FirstBaseline, "Expect ALView.al_firstbaseline to have the attribute NSLayoutAttribute.FirstBaseline")
    }
    
    func testOperandDefaultValues() {
        let operands = [view1.al_left,
                        view1.al_leftMargin,
                        view1.al_right,
                        view1.al_rightMargin,
                        view1.al_top,
                        view1.al_topMargin,
                        view1.al_bottom,
                        view1.al_bottomMargin,
                        view1.al_leading,
                        view1.al_leadingMargin,
                        view1.al_trailing,
                        view1.al_trailingMargin,
                        view1.al_width,
                        view1.al_height,
                        view1.al_centerX,
                        view1.al_centerXWithinMargins,
                        view1.al_centerY,
                        view1.al_centerYWithinMargins,
                        view1.al_baseline,
                        view1.al_firstbaseline
        ]
        
        for operand in operands {
            XCTAssertEqual(view1, operand.view, "Expect view to be correct")
            XCTAssertEqual(operand.constant, 0.0, "Expect default constant to be 0.0")
            XCTAssertEqual(operand.multiplier, 1.0, "Expect default multiplier to be 1.0")
        }
    }
    
    func testEqual() {
        let equal = view1.al_left.equalTo(view2.al_right)
        XCTAssertEqual(equal.relation, NSLayoutRelation.Equal, "Expect ALLayoutItem.equalTo to produce constraint with NSLayoutRelation.Equal relation")
        
        let equalOperator = view1.al_left == view2.al_right;
        XCTAssertEqual(equalOperator.relation, NSLayoutRelation.Equal, "Expect == operator to produce constraint with NSLayoutRelation.Equal relation")
    }
    
    func testGreaterThanOrEqual() {
        let gte = view1.al_left.greaterThanOrEqualTo(view2.al_right)
        XCTAssertEqual(gte.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect ALLayoutItem.greaterThanOrEqualTo to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
        
        let gteOperator = view1.al_left >= view2.al_right;
        XCTAssertEqual(gteOperator.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect >= operator to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
    }
    
    func testLessThanOrEqual() {
        let lte = view1.al_left.lessThanOrEqualTo(view2.al_right)
        XCTAssertEqual(lte.relation, NSLayoutRelation.LessThanOrEqual, "Expect ALLayoutItem.lessThanOrEqualTo to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
        
        let lteOperator = view1.al_left <= view2.al_right;
        XCTAssertEqual(lteOperator.relation, NSLayoutRelation.LessThanOrEqual, "Expect <= operator to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
    }
    
    func testAddition() {
        let constraint = view1.al_left == view2.al_right + 10.0
        XCTAssertEqual(constraint.constant, 10.0, "Expect constraint constant to be 10.0")
    }
    
    func testSubtraction() {
        let constraint = view1.al_left == view2.al_right - 10.0
        XCTAssertEqual(constraint.constant, -10.0, "Expect constraint constant to be -10.0")
    }
    
    func testMultiplication() {
        let constraint = view1.al_left == view2.al_right * 2.0
        XCTAssertEqual(constraint.multiplier, 2.0, "Expect constraint multiplier to be 2.0")
    }
    
    func testDivision() {
        let constraint = view1.al_left == view2.al_right / 2.0
        XCTAssertEqual(constraint.multiplier, 0.5, "Expect constraint multiplier to be 0.5")
    }
    
    func testCompleteConstraint() {
        let constraint = view1.al_left == view2.al_right * 2.0 / 0.5 + 20.0 - 10.0
        XCTAssertEqual(constraint.firstItem as ALView, view1, "Expect first item to be view1")
        XCTAssertEqual(constraint.firstAttribute, NSLayoutAttribute.Left, "Expect first attribute to be NSLayoutAttribute.Left")
        XCTAssertEqual(constraint.relation, NSLayoutRelation.Equal, "Expect constraint relation to be NSLayoutRelation.Equal")
        XCTAssertEqual(constraint.secondItem as ALView, view2, "Expect second item to be view2")
        XCTAssertEqual(constraint.secondAttribute, NSLayoutAttribute.Right, "Expect second attribute to be NSLayoutAttribute.Right")
        XCTAssertEqual(constraint.constant, 10.0, "Expect constraint constant to be 10.0")
        XCTAssertEqual(constraint.multiplier, 4.0, "Expect constraint multiplier to be 4.0")
    }
    
    func testConstantMultiplierOnWrongSide() {
        let constraint = view1.al_left * 2.0 / 0.5 + 20.0 - 10.0 == view2.al_right
        XCTAssertEqual(constraint.constant, 0.0, "Expect constraint constant to be 0.0 when expression is on wrong side of the relation")
        XCTAssertEqual(constraint.multiplier, 1.0, "Expect constraint multiplier to be 1.0 when expression is on wrong side of the relation")
    }
    
    func testRelationsWithoutSecondView() {
        let constraints = [view1.al_width == 10.0 * 2.0,
                           view1.al_width.equalToConstant(10.0 * 2.0),
                           view1.al_width >= 10.0 * 2.0,
                           view1.al_width.greaterThanOrEqualToConstant(10.0 * 2.0),
                           view1.al_width <= 10.0 * 2.0,
                           view1.al_width.lessThanOrEqualToConstant(10.0 * 2.0)]
        
        for constraint in constraints {
            XCTAssertEqual(constraint.constant, 20.0, "Expect constraint constant to be 20.0")
            XCTAssertEqual(constraint.multiplier, 1.0, "Expect constraint multiplier to be 0.0")
        }
    }
}
