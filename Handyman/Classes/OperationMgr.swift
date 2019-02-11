//
//  OperationMgr.swift
//  Handyman
//
//  Created by strong84 on 2/11/19.
//

import UIKit

public final class OperationMgr {
    
    public static let shared = OperationMgr()
    
    private var queue = [Operation]()
    
    public func addOperation(block: @escaping (_ mgr: OperationMgr) -> Void) {
        
        let op = Operation()
        op.completionBlock = {
            DispatchQueue.main.async {
                block(OperationMgr.shared)
            }
        }
        
        queue.append(op)
    }
    
    public func run() {
        guard let op = queue.first else { return }
        OperationQueue.main.maxConcurrentOperationCount = 1
        OperationQueue.main.addOperation(op)
    }
    
    public func runNext() {
        guard queue.count > 0 else { return }
        queue.remove(at: 0)
        run()
    }
    
    public func stop() {
        queue.removeAll()
    }
}

// MARK: - Helper
extension OperationMgr {
    
    public func delay(_ seconds: Double, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            block()
        }
    }
}
