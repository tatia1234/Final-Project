//
//  LoginScreenViewController.swift
//  FinalProjectTatia
//
//  Created by Tatia on 15.01.24.
//

import UIKit

class LoginScreenViewController: UIViewController, UITextFieldDelegate {
    var titleLabel = UILabel()
    var imageView = UIImageView()
    var loginTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    
    private var loginString: String = ""
    private var passwordString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpTitle()
        setUpImage()
        setUpLoginTextField()
        setUpPasswordTextField()
        setUpButton()
    }

    private func readJson() -> User? {
        if let path = Bundle.main.path(forResource: "UserInfo", ofType: "json") {
            let fileURL = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: fileURL)
                
                return try JSONDecoder().decode(User.self, from: data)
            } catch(let error) {
               print("Error \(error)")
            }
            
            // Continue with reading the file...
        } else {
            print("File not found")
            return nil
        }
        return nil
    }
    
    @objc func onEnterButtonTapped() {
        guard let user = readJson() else { return }
        
        if loginString == user.mail && passwordString == user.password {
            let vc = ProductsViewController()
            vc.user = user
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if textField == loginTextField {
            loginString = updatedText
        } else if textField == passwordTextField {
            passwordString = updatedText
        }
        return true
    }
}

extension LoginScreenViewController {
    
    func setUpButton() {
        self.loginButton.setTitle("შესვლა", for: .normal)
        self.loginButton.backgroundColor = .systemBlue
        self.loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 12
        self.view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(onEnterButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Set top constraint
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            
            // Set leading constraint
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Set trailing constraint
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // Set height constraint (optional)
            loginButton.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    func setUpTitle() {
        self.titleLabel.text = "კეთილი იყოს მობრძანება"
        self.titleLabel.font = .systemFont(ofSize: 18)
        self.view.addSubview(titleLabel)
        self.titleLabel.textAlignment = .center
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setUpImage() {
        
        let imageName = "logo_image"
        let image = UIImage(named: imageName)
        self.imageView.image = image
       // imageView.frame = CGRect(x: 0, y: 0, width: 220, height: 150)
        self.view.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setUpPasswordTextField() {
        passwordTextField.placeholder = "პაროლი"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.tag = 1
        
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        passwordTextField.setLeftPaddingPoints(10)
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.delegate = self
        self.view.addSubview(passwordTextField)
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Set top constraint
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            
            // Set leading constraint
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Set trailing constraint
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // Set height constraint (optional)
            passwordTextField.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    func setUpLoginTextField() {
        loginTextField.placeholder = "ელ-ფოსტა"
        loginTextField.font = UIFont.systemFont(ofSize: 15)
        loginTextField.tag = 0
        loginTextField.layer.cornerRadius = 12
        loginTextField.layer.borderWidth = 2.0
        loginTextField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        loginTextField.setLeftPaddingPoints(10)
        
        loginTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        loginTextField.keyboardType = UIKeyboardType.default
        loginTextField.returnKeyType = UIReturnKeyType.done
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        loginTextField.delegate = self
        self.view.addSubview(loginTextField)
        
        self.loginTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Set top constraint
            loginTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            // Set leading constraint
            loginTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Set trailing constraint
            loginTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // Set height constraint (optional)
            loginTextField.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
