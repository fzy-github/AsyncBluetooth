//  Copyright (c) 2021 Manuel Fernandez-Peix Perez. All rights reserved.

import Foundation
import CoreBluetooth
import Combine

/// Contains the objects necessary to track a Peripheral's commands.
actor PeripheralContext {
    #if os(iOS) && compiler(>=6.4)
    actor ChannelSoundingSessionContext {
        /// Continuation used for yielding channel sounding procedure results, and finishing
        /// channel sounding sessions.
        private(set) var continuation: AsyncThrowingStream<ChannelSoundingEventData, Error>.Continuation?

        func setContinuation(
            _ continuation: AsyncThrowingStream<ChannelSoundingEventData, Error>.Continuation?
        ) -> Void {
            self.continuation = continuation
        }
    }
    #endif

    nonisolated let characteristicValueUpdatedSubject = PassthroughSubject<CharacteristicValueUpdateEventData, Never>()
    nonisolated let invalidatedServicesSubject = PassthroughSubject<[Service], Never>()
    
    private(set) lazy var readRSSIExecutor = {
        let executor = AsyncSerialExecutor<NSNumber>()
        Task {
            await flushableExecutors.append(executor)
        }
        return executor
    }()
    
    private(set) lazy var discoverServiceExecutor = {
        let executor = AsyncSerialExecutor<Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var discoverIncludedServicesExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var discoverCharacteristicsExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var readCharacteristicValueExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var writeCharacteristicValueExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var setNotifyValueExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var discoverDescriptorsExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var readDescriptorValueExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var writeDescriptorValueExecutor = {
        let executor = AsyncExecutorMap<CBUUID, Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    private(set) lazy var openL2CAPChannelExecutor = {
        let executor = AsyncSerialExecutor<CBL2CAPChannel?>()
        flushableExecutors.append(executor)
        return executor
    }()
    
    #if os(iOS) && compiler(>=6.4)
    private(set) lazy var channelSoundingSessionContext = ChannelSoundingSessionContext()

    private(set) lazy var channelSoundingSessionExecutor = {
        let executor = AsyncSerialExecutor<Void>()
        flushableExecutors.append(executor)
        return executor
    }()
    #endif

    private var flushableExecutors: ThreadSafeArray<FlushableExecutor> = []
    
    func flush(error: Error) async {
        for await flushableExecutor in flushableExecutors {
            await flushableExecutor.flush(error: error)
        }
    }
}
