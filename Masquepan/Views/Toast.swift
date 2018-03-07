import UIKit
class Toast {
func toastView(messsage : String, view: UIView ){
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300,  height : 35))
    toastLabel.backgroundColor = UIColor.orange
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center;
    view.addSubview(toastLabel)
    toastLabel.text = messsage
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
        toastLabel.alpha = 0.0
        })
    }
}
