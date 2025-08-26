//
//  AppBinder.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 27/04/2024.
//

import Foundation

class Bindable<T>{
    
    init(_ value: T? = nil) {
        self.value = value
    }
    
    var value: T? {
        didSet{
            self.observer?(value)
        }
    }
    
    private var observer: ((T?)-> ())?
    
    func bind(completion: @escaping (T?)-> ()){
        self.observer = completion
    }
    
}
