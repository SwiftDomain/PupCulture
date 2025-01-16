import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoading: Bool = false
    @State private var isSecure: Bool = true
    
    func authenticate() {
        // Reset message and loading indicator
        self.message = ""
        self.isLoading = true
        
        let url = URL(string: "http://localhost:5000/login")!
        let body = ["username": username, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.message = "No data in response: \(error?.localizedDescription ?? "Unknown error")"
                self.isLoading = false
                return
            }
            
            let responseJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            DispatchQueue.main.async {
                self.isLoading = false
                if let success = responseJSON["success"] as? Bool, success {
                    self.message = "Login successful"
                } else {
                    self.message = responseJSON["message"] as? String ?? "Unknown error"
                }
            }
        }.resume()
    }
    
    var body: some View {
        ZStack {
           // Color.gray.opacity(0.1).ignoresSafeArea()
            VStack {
                Spacer()
                
                SignInWithAppleButton(.continue) { request in
                      request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                      switch result {
                        case .success(let authResults):
                          print("Authorisation successful")
                        case .failure(let error):
                          print("Authorisation failed: \(error.localizedDescription)")
                      }
                    }
                    // black button
                    .signInWithAppleButtonStyle(.black)
                    // white button
                    .signInWithAppleButtonStyle(.white)
                    // white with border
                    .signInWithAppleButtonStyle(.whiteOutline)
                
                Spacer()
                Image(systemName: "dog.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 50)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                
                HStack {
                    if isSecure {
                        SecureField("Password", text: $password)
     
                    } else {
                        TextField("Password", text: $password)

                    }
                    Button(action: {
                        self.isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                
                Button(action: authenticate) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding()
                .disabled(username.isEmpty || password.isEmpty || isLoading)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                }
                
                Text(message)
                    .padding()
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding()
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .navigationBarHidden(true)
    }
}

// Extension to dismiss keyboard when tapped outside of text fields
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
