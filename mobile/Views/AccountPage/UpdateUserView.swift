//
//  UpdateUserView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct UpdateUserView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @Binding var user: User
    @State private var isUpdating = false
    @State private var isShowingDeleteConfirmationAlert = false
    @State private var isEmailValid = true
    @State private var isFirstNameValid = true
    @State private var isLastNameValid = true
    @State private var isPhoneValid = true
    @State private var isDateOfBirthValid = true
    @State private var isAddressValid = true
    @State private var isLinkedInURLValid = true
    @State private var isInstagramURLValid = true
    @State private var isFacebookURLValid = true
    @State private var isTwitterURLValid = true

    var body: some View {
        let maximumDateOfBirth = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        let reasonableMinimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date()) ?? Date()
        
        VStack {
            Text("Update Profile")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Here you can update your user profile information.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Form {
                if isUpdating {
                    ProgressView()
                } else {
                    Section(header: Text("Personal Information")) {
                        TextField("Email", text: $user.email, onEditingChanged: { editing in
                            if !editing {
                                isEmailValid = Validator.isValidEmail(user.email)
                            }
                        })
                        .keyboardType(.emailAddress)
                        .foregroundColor(isEmailValid ? .primary : .red)

                        TextField("First Name", text: $user.firstName, onEditingChanged: { editing in
                            if !editing {
                                isFirstNameValid = Validator.isValidName(user.firstName)
                            }
                        })
                        .foregroundColor(isFirstNameValid ? .primary : .red)

                        TextField("Last Name", text: $user.lastName, onEditingChanged: { editing in
                            if !editing {
                                isLastNameValid = Validator.isValidName(user.lastName)
                            }
                        })
                        .foregroundColor(isLastNameValid ? .primary : .red)

                        TextField("Phone Number", text: Binding(
                            get: { user.phone ?? "" },
                            set: { user.phone = $0 }
                        ), onEditingChanged: { editing in
                            if !editing {
                                isPhoneValid = Validator.isValidPhone(user.phone)
                            }})
                          .foregroundColor(isPhoneValid ? .primary : .red)

                        DatePicker("Date of Birth", selection: Binding(
                            get: { user.dateOfBirth ?? maximumDateOfBirth },
                            set: { user.dateOfBirth = $0 }
                        ), in: reasonableMinimumDate...maximumDateOfBirth, displayedComponents: .date)
                        .foregroundColor(isDateOfBirthValid ? .primary : .red)
                        .datePickerStyle(CompactDatePickerStyle())
                    }

                    Section(header: Text("Address Information")) {
                        TextField("Address", text: Binding(
                            get: { user.address ?? "" },
                            set: { user.address = $0 }
                        ))
                        .foregroundColor(isAddressValid ? .primary : .red)

                        TextField("City", text: Binding(
                            get: { user.city ?? "" },
                            set: { user.city = $0 }
                        ))

                        TextField("Postal Code", text: Binding(
                            get: { user.postalCode ?? "" },
                            set: { user.postalCode = $0 }
                        ))

                        TextField("Country Code", text: Binding(
                            get: { user.countryCode ?? "" },
                            set: { user.countryCode = $0 }
                        ))
                    }
                    
                    Section(header: Text("Social Media Links")) {
                           TextField("LinkedIn URL", text: Binding(
                            get: { user.linkedinURL ?? "" },
                            set: { user.linkedinURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isLinkedInURLValid ? .primary : .red)

                           TextField("Twitter URL", text:Binding(
                            get: { user.twitterURL ?? "" },
                            set: { user.twitterURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isTwitterURLValid ? .primary : .red)

                           TextField("Facebook URL", text: Binding(
                            get: { user.facebookURL ?? "" },
                            set: { user.facebookURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isFacebookURLValid ? .primary : .red)

                           TextField("Instagram URL", text: Binding(
                            get: { user.instagramURL ?? "" },
                            set: { user.instagramURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isInstagramURLValid ? .primary : .red)
                       }
                    
                }
                Button(action: {
                    if validateFields() {
                        updateUser(iteration: 0)
                    }
                    print("ValidateFields: \(validateFields())")
                }) {
                    Text("Update Profile")
                }
                .disabled(isUpdating)
                Section {
                    Button(action: {
                        isShowingDeleteConfirmationAlert = true
                    }) {
                        Text("Delete Profile").foregroundColor(Color("AlertColor"))
                    }.alert(isPresented: $isShowingDeleteConfirmationAlert) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete your profile? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete"), action: {
                                isUpdating = true
                                authenticationManager.deleteUser(iteration: 0) {
                                    isUpdating = false
                                }
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private func validateFields() -> Bool {
        isEmailValid = Validator.isValidEmail(user.email)
        isFirstNameValid = Validator.isValidName(user.firstName)
        isLastNameValid = Validator.isValidName(user.lastName)
        isPhoneValid = Validator.isValidPhone(user.phone)
        isDateOfBirthValid = true
        isAddressValid = true
        // TODO: Implement address validation
        isLinkedInURLValid = Validator.isValidLinkedInURL(user.linkedinURL)
        isTwitterURLValid = Validator.isValidTwitterURL(user.twitterURL)
        isFacebookURLValid = Validator.isValidFacebookURL(user.facebookURL)
        isInstagramURLValid = Validator.isValidInstagramURL(user.instagramURL)
        
        print("isEmailValid \(isEmailValid)")
        print("isFirstNameValid \(isFirstNameValid)")
        print("isLastNameValid \(isLastNameValid)")
        print("isPhoneValid \(isPhoneValid)")
        print("isDateOfBirthValid \(isDateOfBirthValid)")
        print("isAddressValid \(isAddressValid)")
        
        // Return true if all fields are valid
        return isEmailValid && isFirstNameValid && isLastNameValid && isPhoneValid && isDateOfBirthValid && isAddressValid && isLinkedInURLValid && isTwitterURLValid && isFacebookURLValid && isInstagramURLValid
    }
    
    func updateUser(iteration: Int) {
        print("Iteration \(iteration)")
        isUpdating = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.updateAccount(accessToken: accessToken, user: authenticationManager.current) { result in
                switch result {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        print("case .success \(apiResponse)")
                        self.errorHandlingManager.errorMessage = nil
                        isUpdating = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("case .failure, iteration: \(iteration)")
                        if iteration == 0 {
                            if case .authenticationError = error {
                                print("case .authenticationError")
                                // Authentication error (e.g., access token invalid)
                                // Refresh the access token and retry the request
                                self.authenticationManager.requestAccessToken() { accessTokenSuccess in
                                    if accessTokenSuccess{
                                        self.updateUser(iteration: 1)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                    }
                                }
                            } else {
                                print("case .else")
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                        }
                        isUpdating = false
                    }
                }
            }
        }
    }
}


struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        @State var user = User.generateRandomUser()
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        UpdateUserView(user: $user).environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
