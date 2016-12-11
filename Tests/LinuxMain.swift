import XCTest
@testable import ZeroFormatterTests

XCTMain([
    testCase(ArrayTestCase.allTests),
    testCase(ListTestCase_internal.allTests),
    testCase(ListTestCase.allTests),
    testCase(ObjectTestCase.allTests),
    testCase(PrimitiveDeserializeOptionalTestCase.allTests),
    testCase(PrimitiveDeserializeTestCase.allTests),
    testCase(PrimitiveSerializeOptionalTestCase.allTests),
    testCase(PrimitiveSerializeTestCase.allTests)
])
