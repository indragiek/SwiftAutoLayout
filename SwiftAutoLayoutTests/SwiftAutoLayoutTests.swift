//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

import XCTest
import SwiftAutoLayout

#if os(iOS) || os(tvOS)
private class ViewController: UIViewController {
    fileprivate override func loadView() {
        self.view = UIView(frame: CGRect.zero)
    }
}
#endif

class SwiftAutoLayoutTests: XCTestCase {
    let view1 = View(frame: CGRect.zero)
    let view2 = View(frame: CGRect.zero)
    
    func testViewAttributeValues() {
        XCTAssertEqual(view1.left.attribute, NSLayoutAttribute.left)
        XCTAssertEqual(view1.right.attribute, NSLayoutAttribute.right)
        XCTAssertEqual(view1.top.attribute, NSLayoutAttribute.top)
        XCTAssertEqual(view1.bottom.attribute, NSLayoutAttribute.bottom)
        XCTAssertEqual(view1.leading.attribute, NSLayoutAttribute.leading)
        XCTAssertEqual(view1.trailing.attribute, NSLayoutAttribute.trailing)
        XCTAssertEqual(view1.width.attribute, NSLayoutAttribute.width)
        XCTAssertEqual(view1.height.attribute, NSLayoutAttribute.height)
        XCTAssertEqual(view1.centerX.attribute, NSLayoutAttribute.centerX)
        XCTAssertEqual(view1.centerY.attribute, NSLayoutAttribute.centerY)
        XCTAssertEqual(view1.baseline.attribute, NSLayoutAttribute.lastBaseline)
        XCTAssertEqual(view1.firstBaseline.attribute, NSLayoutAttribute.firstBaseline)
        XCTAssertEqual(view1.lastBaseline.attribute, NSLayoutAttribute.lastBaseline)
    }
    
    #if os(iOS) || os(tvOS)
    func testViewMarginAttributeValues() {
        XCTAssertEqual(view1.leftMargin.attribute, NSLayoutAttribute.leftMargin)
        XCTAssertEqual(view1.rightMargin.attribute, NSLayoutAttribute.rightMargin)
        XCTAssertEqual(view1.topMargin.attribute, NSLayoutAttribute.topMargin)
        XCTAssertEqual(view1.bottomMargin.attribute, NSLayoutAttribute.bottomMargin)
        XCTAssertEqual(view1.leadingMargin.attribute, NSLayoutAttribute.leadingMargin)
        XCTAssertEqual(view1.trailingMargin.attribute, NSLayoutAttribute.trailingMargin)
        XCTAssertEqual(view1.centerXWithinMargins.attribute, NSLayoutAttribute.centerXWithinMargins)
        XCTAssertEqual(view1.centerYWithinMargins.attribute, NSLayoutAttribute.centerYWithinMargins)
    }
    
    func testViewControllerAttributeValues() {
        let viewController = ViewController()
        print(viewController.view) // Load the view
        XCTAssertEqual(viewController.topLayoutGuideTop.attribute, NSLayoutAttribute.top)
        XCTAssertEqual(viewController.topLayoutGuideBottom.attribute, NSLayoutAttribute.bottom)
        XCTAssertEqual(viewController.bottomLayoutGuideTop.attribute, NSLayoutAttribute.top)
        XCTAssertEqual(viewController.bottomLayoutGuideBottom.attribute, NSLayoutAttribute.bottom)
    }
    #endif
    
    func testEqual() {
        let constraint = view1.left == view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.equal)
    }
    
    func testGreaterThanOrEqual() {
        let constraint = view1.left >= view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.greaterThanOrEqual)
    }
    
    func testLessThanOrEqual() {
        let constraint = view1.left <= view2.right;
        XCTAssertEqual(constraint.firstItem as? View, view1)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.lessThanOrEqual)
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
        XCTAssertEqual(constraint.firstAttribute, NSLayoutAttribute.left)
        XCTAssertEqual(constraint.relation, NSLayoutRelation.equal)
        XCTAssertEqual(constraint.secondItem as? View, view2)
        XCTAssertEqual(constraint.secondAttribute, NSLayoutAttribute.right)
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
        XCTAssertEqual(constraint.relation, NSLayoutRelation.greaterThanOrEqual)
        XCTAssertEqual(constraint.constant, -10.0)
        XCTAssertEqual(constraint.multiplier, 2.0)
        XCTAssertEqual(constraint.priority, 600)
    }
}
