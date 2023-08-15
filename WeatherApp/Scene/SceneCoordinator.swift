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
    private var window: UIWindow
    private let bag = DisposeBag()
    private var currentVC: UIViewController? {
        didSet {
            guard let currentVC = currentVC else { return }
            print(currentVC)
        }
    }
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        let subject = PublishSubject<Never>()
        let target = scene.create()
        
        switch style {
        case .root:
            
            if let nav = target as? UINavigationController {
                // navigationController의 push/pop 했을 때 willShow 이벤트를 방출하는 Observable을 구독하는 Observer 등록
                // navigation의 back버튼을 눌렀을 때, transition메소드는 호출되지 않아서 이런 옵저버를 등록해야함
                nav.rx.willShow
                    .withUnretained(self)
                    .subscribe(onNext: { coordinator, evt in
                        coordinator.currentVC = evt.viewController.sceneViewController
                    })
                    .disposed(by: bag)
            }
            
            window.rootViewController = target
            window.makeKeyAndVisible()
            
            subject.onCompleted()
        case .push:
            // Push 됐을 때 currentVC 업데이트는 위에서 등록한 Observer에 의해 자동으로 업데이트 됨.
            guard let nav = currentVC?.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.pushViewController(target, animated: animated)
            
            subject.onCompleted()
        case .modal:
            currentVC?.present(target, animated: animated) {
                subject.onCompleted()
            }
            
//            target.rx.methodInvoked(#selector(target.viewWillDisappear(_:)))
//                .map { _ in }
//                .withUnretained(self)
//                .subscribe(onNext: { coordinator, _ in
//                    guard let parentVC = target.presentingViewController else { return }
//                    coordinator.currentVC = parentVC.sceneViewController
//                })
//                .disposed(by: bag)
            
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
