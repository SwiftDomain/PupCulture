//
//  ContentView.swift
//  PupCulture
//
//  Created by BeastMode on 4/9/24.
//

import SwiftUI
import AuthenticationServices

struct PupCultureHome: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
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
                
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                // Perform login authentication here
                self.authenticate()
            }) {
                Text("Login")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
            
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
                //.signInWithAppleButtonStyle(.black)
                // white button
                //.signInWithAppleButtonStyle(.white)
                // white with border
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 50)
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Invalid username or password"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func authenticate() {
        // Dummy authentication for demonstration purposes
        if username == "user" && password == "password" {
            // Successful login
            print("Login successful")
        } else {
            // Failed login
            showAlert = true
        }
    }
}

struct PupCultureHome_Previews: PreviewProvider {
    static var previews: some View {
        PupCultureHome()
    }
}

