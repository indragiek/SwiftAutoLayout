//
//  SwiftAutoLayoutTests.swift
//  SwiftAutoLayoutTests
//
//  Created by Indragie on 6/17/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import XCTest
import UIKit
import SwiftAutoLayout

class SwiftAutoLayoutTests: XCTestCase {
    let view1 = UIView(frame: CGRectZero)
    let view2 = UIView(frame: CGRectZero)
    
    func testAttributeValues() {
        XCTAssertEqual(view1.al_left().attribute, NSLayoutAttribute.Left, "Expect UIView.al_left() to have the attribute NSLayoutAttribute.Left")
        XCTAssertEqual(view1.al_right().attribute, NSLayoutAttribute.Right, "Expect UIView.al_right() to have the attribute NSLayoutAttribute.Right")
        XCTAssertEqual(view1.al_top().attribute, NSLayoutAttribute.Top, "Expect UIView.al_top() to have the attribute NSLayoutAttribute.Top")
        XCTAssertEqual(view1.al_bottom().attribute, NSLayoutAttribute.Bottom, "Expect UIView.al_bottom() to have the attribute NSLayoutAttribute.Bottom")
        XCTAssertEqual(view1.al_leading().attribute, NSLayoutAttribute.Leading, "Expect UIView.al_leading() to have the attribute NSLayoutAttribute.Leading")
        XCTAssertEqual(view1.al_trailing().attribute, NSLayoutAttribute.Trailing, "Expect UIView.al_trailing() to have the attribute NSLayoutAttribute.Trailing")
        XCTAssertEqual(view1.al_width().attribute, NSLayoutAttribute.Width, "Expect UIView.al_width() to have the attribute NSLayoutAttribute.Width")
        XCTAssertEqual(view1.al_height().attribute, NSLayoutAttribute.Height, "Expect UIView.al_height() to have the attribute NSLayoutAttribute.Height")
        XCTAssertEqual(view1.al_centerX().attribute, NSLayoutAttribute.CenterX, "Expect UIView.al_centerX() to have the attribute NSLayoutAttribute.CenterX")
        XCTAssertEqual(view1.al_centerY().attribute, NSLayoutAttribute.CenterY, "Expect UIView.al_centerY() to have the attribute NSLayoutAttribute.CenterY")
        XCTAssertEqual(view1.al_baseline().attribute, NSLayoutAttribute.Baseline, "Expect UIView.al_baseline() to have the attribute NSLayoutAttribute.Baseline")
    }
    
    func testOperandDefaultValues() {
        let operands = [view1.al_left(),
                        view1.al_right(),
                        view1.al_top(),
                        view1.al_bottom(),
                        view1.al_leading(),
                        view1.al_trailing(),
                        view1.al_width(),
                        view1.al_height(),
                        view1.al_centerX(),
                        view1.al_centerY(),
                        view1.al_baseline()]
        
        for operand in operands {
            XCTAssertEqualObjects(view1, operand.view, "Expect view to be correct")
            XCTAssertEqual(operand.constant, 0.0, "Expect default constant to be 0.0")
            XCTAssertEqual(operand.multiplier, 1.0, "Expect default multiplier to be 1.0")
        }
    }
    
    func testEqual() {
        let equal = view1.al_left().equalTo(view2.al_right())
        XCTAssertEqual(equal.relation, NSLayoutRelation.Equal, "Expect ALOperand.equalTo() to produce constraint with NSLayoutRelation.Equal relation")
        
        let equalOperator = view1.al_left() == view2.al_right();
        XCTAssertEqual(equalOperator.relation, NSLayoutRelation.Equal, "Expect == operator to produce constraint with NSLayoutRelation.Equal relation")
    }
    
    func testGreaterThanOrEqual() {
        let gte = view1.al_left().greaterThanOrEqualTo(view2.al_right())
        XCTAssertEqual(gte.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect ALOperand.greaterThanOrEqualTo() to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
        
        let gteOperator = view1.al_left() >= view2.al_right();
        XCTAssertEqual(gteOperator.relation, NSLayoutRelation.GreaterThanOrEqual, "Expect >= operator to produce constraint with NSLayoutRelation.GreaterThanOrEqual relation")
    }
    
    func testLessThanOrEqual() {
        let lte = view1.al_left().lessThanOrEqualTo(view2.al_right())
        XCTAssertEqual(lte.relation, NSLayoutRelation.LessThanOrEqual, "Expect ALOperand.lessThanOrEqualTo() to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
        
        let lteOperator = view1.al_left() <= view2.al_right();
        XCTAssertEqual(lteOperator.relation, NSLayoutRelation.LessThanOrEqual, "Expect <= operator to produce constraint with NSLayoutRelation.LessThanOrEqual relation")
    }
    
    func testAddition() {
        let constraint = view1.al_left() == view2.al_right() + 10.0
        XCTAssertEqual(constraint.constant, 10.0, "Expect constraint constant to be 10.0")
    }
    
    func testSubtraction() {
        let constraint = view1.al_left() == view2.al_right() - 10.0
        XCTAssertEqual(constraint.constant, -10.0, "Expect constraint constant to be -10.0")
    }
    
    func testMultiplication() {
        let constraint = view1.al_left() == view2.al_right() * 2.0
        XCTAssertEqual(constraint.multiplier, 2.0, "Expect constraint multiplier to be 2.0")
    }
    
    func testDivision() {
        let constraint = view1.al_left() == view2.al_right() / 2.0
        XCTAssertEqual(constraint.multiplier, 0.5, "Expect constraint multiplier to be 0.5")
    }
    
    func testCompleteConstraint() {
        let constraint = view1.al_left() == view2.al_right() * 2.0 / 0.5 + 20.0 - 10.0
        XCTAssertEqualObjects(constraint.firstItem as UIView, view1, "Expect first item to be view1")
        XCTAssertEqual(constraint.firstAttribute, NSLayoutAttribute.Left, "Expect first attribute to be NSLayoutAttribute.Left")
        XCTAssertEqual(constraint.relation, NSLayoutRelation.Equal, "Expect constraint relation to be NSLayoutRelation.Equal")
        XCTAssertEqualObjects(constraint.secondItem as UIView, view2, "Expect second item to be view2")
        XCTAssertEqual(constraint.secondAttribute, NSLayoutAttribute.Right, "Expect second attribute to be NSLayoutAttribute.Right")
        XCTAssertEqual(constraint.constant, 10.0, "Expect constraint constant to be 10.0")
        XCTAssertEqual(constraint.multiplier, 4.0, "Expect constraint multiplier to be 4.0")
        XCTAssertEqual(constraint.priority, 1000, "Expect constraint priority to be required")
    }
    
    func testConstantMultiplierOnWrongSide() {
        let constraint = view1.al_left() * 2.0 / 0.5 + 20.0 - 10.0 == view2.al_right()
        XCTAssertEqual(constraint.constant, 0.0, "Expect constraint constant to be 0.0 when expression is on wrong side of the relation")
        XCTAssertEqual(constraint.multiplier, 1.0, "Expect constraint multiplier to be 1.0 when expression is on wrong side of the relation")
    }
    
    func testRelationsWithoutSecondView() {
        let constraints = [view1.al_width() == 10.0 * 2.0,
                           view1.al_width().equalTo(10.0 * 2.0),
                           view1.al_width() >= 10.0 * 2.0,
                           view1.al_width().greaterThanOrEqualTo(10.0 * 2.0),
                           view1.al_width() <= 10.0 * 2.0,
                           view1.al_width().lessThanOrEqualTo(10.0 * 2.0)]
        
        for constraint in constraints {
            XCTAssertEqual(constraint.constant, 20.0, "Expect constraint constant to be 20.0")
            XCTAssertEqual(constraint.multiplier, 1.0, "Expect constraint multiplier to be 0.0")
        }
    }

    func testConstraintPriority() {
        let constraint500 = view1.al_left() == view2.al_right() + 10.0 !! 500
        XCTAssertEqual(constraint500.priority, 500)

        let constraint999 = view1.al_left() == view2.al_right() + 10.0 !! UILayoutPriority(UILayoutPriorityRequired) - 1
        XCTAssertEqual(constraint999.priority, 999)

        let constraintBase = view1.al_left() == view2.al_right()
        XCTAssertEqual(constraintBase.priority, 1000)

        let adjustedConstraint = constraintBase !! 250
        XCTAssertEqual(constraintBase.priority, 1000, "Original constraint priority should be unchanged")
        XCTAssertEqual(adjustedConstraint.priority, 250)

        let singleViewConstraint = view1.al_width() == 10.0 !! 400
        XCTAssertEqual(singleViewConstraint.priority, 400)
    }
}
