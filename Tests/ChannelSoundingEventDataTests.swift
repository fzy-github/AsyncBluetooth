import Foundation
import XCTest
@testable import AsyncBluetooth

#if os(iOS) && compiler(>=6.4)

class ChannelSoundingEventDataTests: XCTestCase {

    private struct TestError: Error {}

    func testDistanceIsReturnedWhenProcedureProducesValidMeasurement() throws {
        let eventData = ChannelSoundingEventData(distance: 1.5, error: nil)

        XCTAssertEqual(eventData.distance, 1.5)
        XCTAssertEqual(try eventData.distanceResult.get(), 1.5)
    }

    func testDistanceIsNilWhenProcedureCompletesWithoutValidMeasurement() throws {
        let eventData = ChannelSoundingEventData(distance: nil, error: nil)

        XCTAssertNil(eventData.distance)
        XCTAssertNil(try eventData.distanceResult.get())
    }

    func testDistanceResultIsFailureWhenProcedureFails() {
        let eventData = ChannelSoundingEventData(distance: 1.5, error: TestError())

        XCTAssertNil(eventData.distance)
        XCTAssertThrowsError(try eventData.distanceResult.get())
    }
}

#endif
