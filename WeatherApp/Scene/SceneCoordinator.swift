//
//  SceneCoordinator.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import RxSwift
import RxCocoa
import UIKit

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController?
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        let subject = PublishSubject<Never>()
        
        let target = scene.create()
        
        switch style {
        case .root:
            currentVC = target.sceneViewController
            
            window.rootViewController = target
            window.makeKeyAndVisible()
            
            subject.onCompleted()
        case .push:
            guard let nav = currentVC?.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .subscribe(onNext: { [weak self] evt in
                    self?.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            
            currentVC = target.sceneViewController
            
            subject.onCompleted()
        case .modal:
            currentVC?.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target.sceneViewController
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create() }
            
            if let presentingVC = self.currentVC?.presentingViewController {
                
                self.currentVC?.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
                
            } else if let nav = self.currentVC?.navigationController {
                
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
                
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
