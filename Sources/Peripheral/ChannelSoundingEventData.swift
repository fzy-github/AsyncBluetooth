// Copyright (c) 2026 Manuel Fernandez. All rights reserved.

import Foundation

#if os(iOS) && compiler(>=6.4)

/// Represents the results of a single channel sounding procedure, performed while a channel
/// sounding session is active.
public struct ChannelSoundingEventData: Sendable {
    /// The measured distance to the peripheral, in meters. `nil` when the procedure failed or
    /// completed without a valid measurement.
    public var distance: Double? {
        (try? self.distanceResult.get()) ?? nil
    }

    /**
     A `Result` representing the outcome of the channel sounding procedure.
     If the procedure was successful, contains the measured distance to the peripheral in meters —
     or `nil` when the procedure completed without a valid measurement.
     If an error occurred during the procedure (such as in `peripheral(_:didReceive:error:)`),
     contains the error.
     */
    public let distanceResult: Result<Double?, Error>

    init(distance: Double?, error: Error?) {
        if let error {
            self.distanceResult = .failure(error)
        } else {
            self.distanceResult = .success(distance)
        }
    }
}

#endif
