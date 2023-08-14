//
//  RxMKLocalSearchCompleterDelegateProxy.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

extension MKLocalSearchCompleter: HasDelegate {
    public typealias Delegate = MKLocalSearchCompleterDelegate
}

public class RxLocalSearchCompleterDelegateProxy: DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate>, DelegateProxyType, MKLocalSearchCompleterDelegate {
    
    public init(searchCompleter: MKLocalSearchCompleter) {
        super.init(parentObject: searchCompleter, delegateProxy: RxLocalSearchCompleterDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxLocalSearchCompleterDelegateProxy(searchCompleter:  $0) }
    }
    
}

extension Reactive where Base: MKLocalSearchCompleter {
    
    var delegate: DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate> {
        return RxLocalSearchCompleterDelegateProxy.proxy(for: base)
    }
    
    var didUpdateResults: Observable<[MKLocalSearchCompletion]> {
        let sel = #selector(MKLocalSearchCompleterDelegate.completerDidUpdateResults(_:))
        return delegate.methodInvoked(sel)
            .map { $0[0] as! MKLocalSearchCompleter }
            .map { $0.results }
    }
    
}
