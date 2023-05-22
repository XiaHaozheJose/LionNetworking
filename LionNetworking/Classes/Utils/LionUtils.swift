//
//  LionUtils.swift
//  LionNetworking
//
//  Created by 夏悦淇 on 19/3/23.
//

import Foundation

final class LionWeak<T: AnyObject> {
    weak var value: T?

    init(_ value: T?) {
        self.value = value
    }
}
