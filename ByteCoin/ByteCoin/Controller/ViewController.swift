
import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var bitycoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        
        gradientColorBackground()
        
    }
    
    func gradientColorBackground() {
        
        let color1 = #colorLiteral(red: 0.1913990378, green: 0.1725208163, blue: 0.02679961175, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [color1.cgColor, UIColor.gray.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}


//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return coinManager.currencyArray.count
    }
    
}


//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray[row]
      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let coinPrice = coinManager.currencyArray[row]
    
        return coinManager.getCoinPrice(for: coinPrice)
            
        
    }
    
}


//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didWithError(_ error: Error) {
        print(error)
    }

    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitycoinLabel.text = String(format: "%.2f", coin.rateID)
            self.currencyLabel.text = coin.currency
        }
    }


}
