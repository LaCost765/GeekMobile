//
//  RxExtensions.swift
//  GeekMobile
//
//  Created by Egor on 11.03.2021.
//

import Foundation
import RxSwift

extension BehaviorSubject {
    func safeValue() -> Element? {
        do {
            return try self.value()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
