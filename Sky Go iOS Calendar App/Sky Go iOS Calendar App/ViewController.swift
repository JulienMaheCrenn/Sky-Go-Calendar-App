
import UIKit

class ViewController: UIViewController {
    
    let skyLogo = UIImageView()
    let usernameLabel = UILabel()
    let usernameTextInput = UITextField()
    let passwordLabel = UILabel()
    let passwordTextInput = UITextField()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogo()
        setupLabels()
        setupTextFields()

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
    
    func setupLabels() {
        view.addSubview(usernameLabel)
        view.addSubview(passwordLabel)
        
        usernameLabel.text = "Username"
        usernameLabel.backgroundColor = .green
        usernameLabel.textAlignment = .left
        
        passwordLabel.text = "Password"
        passwordLabel.backgroundColor = .green
        passwordLabel.textAlignment = .left
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            usernameLabel.widthAnchor.constraint(equalToConstant: 200),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            passwordLabel.widthAnchor.constraint(equalToConstant: 200),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    
    func setupTextFields() {
        view.addSubview(usernameTextInput)
        view.addSubview(passwordTextInput)
        
        usernameTextInput.backgroundColor = .red
        usernameTextInput.textColor = .white
        
        passwordTextInput.backgroundColor = .red
        passwordTextInput.textColor = .white
        
        usernameTextInput.translatesAutoresizingMaskIntoConstraints = false
        passwordTextInput.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextInput.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 50),
            usernameTextInput.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor),
            usernameTextInput.widthAnchor.constraint(equalToConstant: 200),
            usernameTextInput.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextInput.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor, constant: 50),
            passwordTextInput.centerXAnchor.constraint(equalTo: passwordLabel.centerXAnchor),
            passwordTextInput.widthAnchor.constraint(equalToConstant: 200),
            passwordTextInput.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}

