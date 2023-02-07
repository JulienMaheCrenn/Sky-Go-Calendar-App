
import UIKit

class ViewController: UIViewController {
    
    let introlabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()

    }
    func setupLabel() {
        view.addSubview(introlabel)
        
        introlabel.text = "Hello World"
        introlabel.backgroundColor = .green
        introlabel.textAlignment = .center
        
        introlabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            introlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introlabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            introlabel.widthAnchor.constraint(equalToConstant: 200),
            introlabel.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        
    }

}

