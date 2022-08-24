//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by SeungMin on 2022/08/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    let usernameTextfieldSubject = PublishSubject<String>()
    let passwardTextfieldSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextfieldSubject.asObservable(), passwardTextfieldSubject.asObservable()).map { username, passward in
            return username.count > 5 && passward.count > 5
        }.startWith(false)
    }
}

class ViewController: UIViewController {
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwardTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        print("tapped Login Button!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.usernameTextfieldSubject).disposed(by: disposeBag)
        passwardTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.passwardTextfieldSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
    }
}

