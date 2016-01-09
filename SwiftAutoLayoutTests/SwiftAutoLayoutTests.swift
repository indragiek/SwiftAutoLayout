//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

import XCTest
import SwiftAutoLayout

class SwiftAutoLayoutTests: XCTestCase {
    let view1 = View(frame: CGRectZero)
    let view2 = View(frame: CGRectZero)
    
    func testAttributeValues() {
        XCTAssertEqual(view1.left.attribute, NSLayoutAttribute.Left)
        XCTAssertEqual(view1.right.attribute, NSLayoutAttribute.Right)
        XCTAssertEqual(view1.top.attribute, NSLayoutAttribute.Top)
        XCTAssertEqual(view1.bottom.attribute, NSLayoutAttribute.Bottom)
        XCTAssertEqual(view1.leading.attribute, NSLayoutAttribute.Leading)
        XCTAssertEqual(view1.trailing.attribute, NSLayoutAttribute.Trailing)
        XCTAssertEqual(view1.width.attribute, NSLayoutAttribute.Width)
        XCTAssertEqual(view1.height.attribute, NSLayoutAttribute.Height)
        XCTAssertEqual(view1.centerX.attribute, NSLayoutAttribute.CenterX)
        XCTAssertEqual(view1.centerY.attribute, NSLayoutAttribute.CenterY)
        XCTAssertEqual(view1.baseline.attribute, NSLayoutAttribute.Baseline)
    }
    
    func testEqual() {
        let constraint = view1.left == view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.Equal)
    }
    
    func testGreaterThanOrEqual() {
        let constraint = view1.left >= view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.GreaterThanOrEqual)
    }
    
    func testLessThanOrEqual() {
        let constraint = view1.left <= view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.LessThanOrEqual)
    }
    
    func testAddition() {
        let constraint = view1.left == view2.right + 10.0
        XCTAssertEqual(constraint.constant, 10.0)
    }
    
    func testSubtraction() {
        let constraint = view1.left == view2.right - 10.0
        XCTAssertEqual(constraint.constant, -10.0)
    }
    
    func testMultiplication() {
        let constraint = view1.left == view2.right * 2.0
        XCTAssertEqual(constraint.multiplier, 2.0)
    }
    
    func testDivision() {
        let constraint = view1.left == view2.right / 2.0
        XCTAssertEqual(constraint.multiplier, 0.5)
    }
    
    func testDefaultConstraintPriority() {
        let constraint = view1.left == view2.right
        XCTAssertEqual(constraint.priority, 1000)
    }
    
    func testExplicitConstraintPriority() {
        let constraint = view1.left == view2.right ~ 600
        XCTAssertEqual(constraint.priority, 600)
    }
    
    func testCompleteConstraint() {
        let c1 = view2.right * 2.0 / 0.5 + 20.0 - 10.0
        let constraint = view1.left == c1 ~ 600
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.firstAttribute, NSLayoutAttribute.Left)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.Equal)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.secondAttribute, NSLayoutAttribute.Right)
        XCTAssertEqual(constraint.constant, 10.0)
        XCTAssertEqual(constraint.multiplier, 4.0)
        XCTAssertEqual(constraint.priority, 600)
    }
    
    func testConstantMultiplierOnWrongSide() {
        let c1 = view1.left * 2.0 / 0.5 + 20.0 - 10.0
        let constraint = c1 == view2.right
        XCTAssertEqual(constraint.constant, 0.0)
        XCTAssertEqual(constraint.multiplier, 1.0)
        XCTAssertEqual(constraint.priority, 1000)
    }
    
    func testRelationsWithoutSecondView() {
        let constraint1 = view1.width == 10.0 * 2.0
        let constraint2 = view1.width >= 10.0 * 2.0
        let constraint3 = view1.width <= 10.0 * 2.0
        for constraint in [constraint1, constraint2, constraint3] {
            XCTAssertEqual(constraint.constant, 20.0)
            XCTAssertEqual(constraint.multiplier, 1.0)
            XCTAssertEqual(constraint.priority, 1000)
        }
    }
    
    @available(iOS 9.0, OSX 10.11, *)
    func testConstrainingLayoutGuide() {
        let layoutGuide = LayoutGuide()
        let constraint = view1.left >= layoutGuide.right * 2.0 - 10.0 ~ 600
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? LayoutGuide, layoutGuide)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.GreaterThanOrEqual)
        XCTAssertEqual(constraint.constant, -10.0)
        XCTAssertEqual(constraint.multiplier, 2.0)
        XCTAssertEqual(constraint.priority, 600)
    }
}
