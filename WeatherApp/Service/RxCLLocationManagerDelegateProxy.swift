//
//  RxCLLocationManagerDelegateProxy.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
}

extension Reactive where Base: CLLocationManager {
    
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    public var didUpdateLocation: Observable<[CLLocation]> {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return delegate.methodInvoked(sel)
            .map { params in
                return params[1] as! [CLLocation]
            }
    }
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        let sel: Selector
        
        if #available(iOS 14.0, *) {
            sel = #selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:))
            
            return delegate.methodInvoked(sel)
                .map { params in
                    return (params[0] as! CLLocationManager).authorizationStatus
                 }
        } else {
            // Fallback on earlier versions
            sel = #selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:))
            
            return delegate.methodInvoked(sel)
                .map { params in
                    return CLAuthorizationStatus(rawValue: params[1] as! Int32) ?? .notDetermined
                 }
        }
    }
    
}
