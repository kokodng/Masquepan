import Foundation

class ClienteHttp {
    // URL de nuestra API
    //let urlApi: String = "https://ide.c9.io/izvdamdaw/curso1718"
    //let urlApi: String = "https://ios-kokozv.c9users.io/ios/iospanaderia"
    let urlApi: String = "https://ios-javierrodrigueziturriaga.c9users.io/iospanaderia/"
    let respuesta: OnHttpResponse
    var urlPeticion: URLRequest
    
    // En la clasa POSO métodos que tranforman json en objetos y viceversa
    
    // Si el String no es una URL no crea la instancia
    // _ no son obligatorios
    // target - accion a ejecutar (urlApi + target)
    // responseObject - objeto a través del cual se pasa el resultado que se obtiene
    // method - GET, POST, PUT, DELETE
    // en data le pasas un diccionario con los datos que se quieren pasar en el body (los datos de json), any puede ser cualquier valor
    init?(target: String, authorization: String, responseObject: OnHttpResponse,
          _ method: String = "GET", _ data : Data = Data()) {
        guard let url = URL(string: self.urlApi + target) else {
            return nil
        }
        self.respuesta = responseObject
        self.urlPeticion = URLRequest(url: url)
        self.urlPeticion.httpMethod = method
        self.urlPeticion.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.urlPeticion.addValue(authorization, forHTTPHeaderField: "Authorization")
        if method != "GET" && data.count > 0 {
            self.urlPeticion.httpBody = data
        }
        

    }
    
    // crear el objeto y lanzar la petición
    // doInBackground
    func request() {
        // Iniciar el símbolo de red
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: self.urlPeticion,
                                   completionHandler: self.callBack)
        task.resume()
    }
    
    // callBack es el onPostExecute
    private func callBack(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        // Conexión asíncrona a la hebra principal
        DispatchQueue.main.async {
        // Finalizar el símbolo de red
            guard error == nil else {
                self.respuesta.onErrorReceivingData(message: "error")
                return
            }
            guard let datos = data else {
                self.respuesta.onErrorReceivingData(message: "error datos")
                return
            }
            self.respuesta.onDataReceived(data: datos)
        }
    }
}
