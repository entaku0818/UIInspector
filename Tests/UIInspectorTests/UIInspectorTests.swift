import XCTest
@testable import UIInspector

@MainActor
final class ViewHierarchyPluginTests: XCTestCase {
    private let plugin = ViewHierarchyPlugin()

    func testBuildHierarchy_singleView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let node = plugin.buildHierarchy(from: view)
        XCTAssertEqual(node.depth, 0)
        XCTAssertTrue(node.children.isEmpty)
        XCTAssertTrue(node.isLeaf)
    }

    func testBuildHierarchy_withChildren() {
        let root = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let child1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let child2 = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        let grandchild = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        root.addSubview(child1)
        root.addSubview(child2)
        child1.addSubview(grandchild)

        let node = plugin.buildHierarchy(from: root)

        XCTAssertEqual(node.children.count, 2)
        XCTAssertEqual(node.children[0].children.count, 1)
        XCTAssertEqual(node.children[1].children.count, 0)
        XCTAssertEqual(node.depth, 0)
        XCTAssertEqual(node.children[0].depth, 1)
        XCTAssertEqual(node.children[0].children[0].depth, 2)
    }

    func testViewNode_className() {
        let label = UILabel()
        let node = plugin.buildHierarchy(from: label)
        XCTAssertEqual(node.className, "UILabel")
    }

    func testViewNode_frameDescription() {
        let view = UIView(frame: CGRect(x: 10, y: 20, width: 150, height: 80))
        let node = plugin.buildHierarchy(from: view)
        XCTAssertEqual(node.frameDescription, "(10,20) 150×80")
    }
}

@MainActor
final class ViewMeasurementTests: XCTestCase {
    func testHorizontalGap_rightOfA() {
        let a = CGRect(x: 0, y: 0, width: 100, height: 50)
        let b = CGRect(x: 120, y: 0, width: 100, height: 50)
        let m = ViewMeasurement(frameA: a, classA: "A", frameB: b, classB: "B")
        XCTAssertEqual(m.horizontalGap, 20)
        XCTAssertNil(m.verticalGap)
        XCTAssertFalse(m.isOverlapping)
    }

    func testVerticalGap_belowA() {
        let a = CGRect(x: 0, y: 0, width: 100, height: 50)
        let b = CGRect(x: 0, y: 70, width: 100, height: 50)
        let m = ViewMeasurement(frameA: a, classA: "A", frameB: b, classB: "B")
        XCTAssertNil(m.horizontalGap)
        XCTAssertEqual(m.verticalGap, 20)
        XCTAssertFalse(m.isOverlapping)
    }

    func testOverlapping() {
        let a = CGRect(x: 0, y: 0, width: 100, height: 100)
        let b = CGRect(x: 50, y: 50, width: 100, height: 100)
        let m = ViewMeasurement(frameA: a, classA: "A", frameB: b, classB: "B")
        XCTAssertTrue(m.isOverlapping)
    }

    func testCenterDistance() {
        let a = CGRect(x: 0, y: 0, width: 100, height: 100)   // center: (50, 50)
        let b = CGRect(x: 100, y: 0, width: 100, height: 100) // center: (150, 50)
        let m = ViewMeasurement(frameA: a, classA: "A", frameB: b, classB: "B")
        XCTAssertEqual(m.centerDistance, 100, accuracy: 0.01)
    }

    func testBothGaps() {
        let a = CGRect(x: 0, y: 0, width: 50, height: 50)
        let b = CGRect(x: 100, y: 100, width: 50, height: 50)
        let m = ViewMeasurement(frameA: a, classA: "A", frameB: b, classB: "B")
        XCTAssertEqual(m.horizontalGap, 50)
        XCTAssertEqual(m.verticalGap, 50)
        XCTAssertFalse(m.isOverlapping)
    }
}

@MainActor
final class ViewAttributesTests: XCTestCase {
    func testLabel_extractsTypeSpecific() {
        let label = UILabel()
        label.text = "Hello"
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 44)

        let attrs = ViewAttributes(view: label)
        XCTAssertEqual(attrs.className, "UILabel")
        XCTAssertEqual(attrs.frame, label.frame)
        let keys = attrs.typeSpecific.map(\.key)
        XCTAssertTrue(keys.contains("text"))
        XCTAssertTrue(keys.contains("font"))
        XCTAssertTrue(keys.contains("textColor"))
    }

    func testLabel_textValue() {
        let label = UILabel()
        label.text = "Test"
        let attrs = ViewAttributes(view: label)
        let textRow = attrs.typeSpecific.first { $0.key == "text" }
        XCTAssertEqual(textRow?.value, "Test")
    }

    func testPlainView_noTypeSpecific() {
        let view = UIView()
        let attrs = ViewAttributes(view: view)
        XCTAssertTrue(attrs.typeSpecific.isEmpty)
    }

    func testScrollView_hasContentOffset() {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        let attrs = ViewAttributes(view: scroll)
        let keys = attrs.typeSpecific.map(\.key)
        XCTAssertTrue(keys.contains("contentOffset"))
        XCTAssertTrue(keys.contains("contentSize"))
    }
}
