

import UIKit
import FirebaseDatabase

class UserSignInViewController: UIViewController {
    
    let database: DatabaseReference
    let skyLogo = UIImageView()
    
    let signUpButton = UIButton()
    let logInButton = UIButton()
    
    init (database:DatabaseReference) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogo()
        setupButtons()

    }
    
    func setupLogo() {
        skyLogo.image = UIImage(named: "skyLogo")
        view.addSubview(skyLogo)
        
        skyLogo.contentMode = .scaleAspectFit
        
        skyLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skyLogo.heightAnchor.constraint(equalToConstant: 100),
        ])
        
    }
    
    func setupButtons() {
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        
        signUpButton.configuration = .filled()
        signUpButton.configuration?.baseBackgroundColor = .systemOrange
        signUpButton.configuration?.title = "Sign Up"
        signUpButton.configuration?.baseForegroundColor = .black
        
        logInButton.configuration = .filled()
        logInButton.configuration?.baseBackgroundColor = .systemGreen
        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.baseForegroundColor = .black
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.addTarget(self, action: #selector(goToSignUpScreen), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(goToLogInScreen), for: .touchUpInside)

        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            logInButton.widthAnchor.constraint(equalToConstant: 200),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    @objc func goToSignUpScreen() {
        let signUpScreen = SignUpViewController(database: database)
        navigationController?.pushViewController(signUpScreen, animated: true)
    }
    
    @objc func goToLogInScreen() {
        let logInScreen = LogInViewController()
        navigationController?.pushViewController(logInScreen, animated: true)
    }

}
