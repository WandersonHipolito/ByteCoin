
import Foundation



protocol CoinManagerDelegate {
    func didWithError(_ error: Error)
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
}


struct CoinManager {
    
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "1D52FAE6-5215-4772-A3C0-5E7AD52944C5"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
                        

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performSegue(urlString: urlString)
    }
    
    
    
    func performSegue(urlString: String) {
        if  let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didWithError(error!)
                    return
                }
                
                if let safeData = data{
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    
    func parseJSON(_ data: Data) ->  CoinModel?{

        let decoder = JSONDecoder()

        do {
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let rateID = decodeData.rate
            let currency = decodeData.asset_id_quote
            let crypto = decodeData.asset_id_base
            let coin = CoinModel(rateID: rateID, currency: currency, cripto: crypto)
            
            return coin
            

        } catch {
            self.delegate?.didWithError(error)
            return nil
            
        }
    }

    
}
