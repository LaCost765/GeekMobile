//
//  ThreadSafeAction.swift
//  GeekMobile
//
//  Created by Egor on 16.05.2021.
//

import Foundation

class ThreadSafeAction {
    
    private let semaphore: DispatchSemaphore
    
    init(parallelsCount: Int) {
        semaphore = DispatchSemaphore(value: parallelsCount)
    }
    
    func call<T>(code: () -> T) -> T {
        
        semaphore.wait()
        let value = code()
        semaphore.signal()
        return value
    }
}
