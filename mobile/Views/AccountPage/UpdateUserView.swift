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
                        .foregroundColor(isEmailValid ? .primary : Color("AlertColor"))

                        TextField("First Name", text: $user.firstName, onEditingChanged: { editing in
                            if !editing {
                                isFirstNameValid = Validator.isValidName(user.firstName)
                            }
                        })
                        .foregroundColor(isFirstNameValid ? .primary : Color("AlertColor"))

                        TextField("Last Name", text: $user.lastName, onEditingChanged: { editing in
                            if !editing {
                                isLastNameValid = Validator.isValidName(user.lastName)
                            }
                        })
                        .foregroundColor(isLastNameValid ? .primary : Color("AlertColor"))

                        TextField("Phone Number", text: Binding(
                            get: { user.phone ?? "" },
                            set: { user.phone = $0 }
                        ), onEditingChanged: { editing in
                            if !editing {
                                isPhoneValid = Validator.isValidPhone(user.phone)
                            }})
                          .foregroundColor(isPhoneValid ? .primary : Color("AlertColor"))

                        DatePicker("Date of Birth", selection: Binding(
                            get: { user.dateOfBirth ?? maximumDateOfBirth },
                            set: { user.dateOfBirth = $0 }
                        ), in: reasonableMinimumDate...maximumDateOfBirth, displayedComponents: .date)
                        .foregroundColor(isDateOfBirthValid ? .primary : Color("AlertColor"))
                        .datePickerStyle(CompactDatePickerStyle())
                    }

                    Section(header: Text("Address Information")) {
                        TextField("Address", text: Binding(
                            get: { user.address ?? "" },
                            set: { user.address = $0 }
                        ))
                        .foregroundColor(isAddressValid ? .primary : Color("AlertColor"))

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
                               .foregroundColor(isLinkedInURLValid ? .primary : Color("AlertColor"))

                           TextField("Twitter URL", text:Binding(
                            get: { user.twitterURL ?? "" },
                            set: { user.twitterURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isTwitterURLValid ? .primary : Color("AlertColor"))

                           TextField("Facebook URL", text: Binding(
                            get: { user.facebookURL ?? "" },
                            set: { user.facebookURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isFacebookURLValid ? .primary : Color("AlertColor"))

                           TextField("Instagram URL", text: Binding(
                            get: { user.instagramURL ?? "" },
                            set: { user.instagramURL = $0 }
                           ))
                               .keyboardType(.URL)
                               .autocapitalization(.none)
                               .disableAutocorrection(true)
                               .foregroundColor(isInstagramURLValid ? .primary : Color("AlertColor"))
                       }
                    
                }
                Button(action: {
                    if validateFields() {
                        updateUser(iteration: 0)
                    }
                    print("ValidateFields: \(validateFields())")
                }) {
                    Text("Update Profile")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                }
                .disabled(isUpdating)
                Section {
                    Button(action: {
                        isShowingDeleteConfirmationAlert = true
                    }) {
                        Text("Delete Profile").fontWeight(.bold).foregroundColor(Color("AlertColor")).multilineTextAlignment(.center)
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
        var errorMessages: [String] = []
        
        isEmailValid = Validator.isValidEmail(user.email)
        if !isEmailValid {
            errorMessages.append("Invalid email")
        }
        
        isFirstNameValid = Validator.isValidName(user.firstName)
        if !isFirstNameValid {
            errorMessages.append("Invalid first name")
        }
        
        isLastNameValid = Validator.isValidName(user.lastName)
        if !isLastNameValid {
            errorMessages.append("Invalid last name")
        }
        
        isPhoneValid = Validator.isValidPhone(user.phone)
        if !isPhoneValid {
            errorMessages.append("Invalid phone number")
        }
        
        isDateOfBirthValid = true // You may implement this validation separately
        if !isDateOfBirthValid {
            errorMessages.append("Invalid date of birth")
        }
        
        isAddressValid = true // Implement address validation separately
        if !isAddressValid {
            errorMessages.append("Invalid address")
        }
        
        isLinkedInURLValid = Validator.isValidLinkedInURL(user.linkedinURL)
        if !isLinkedInURLValid {
            errorMessages.append("Invalid LinkedIn URL")
        }
        
        isTwitterURLValid = Validator.isValidTwitterURL(user.twitterURL)
        if !isTwitterURLValid {
            errorMessages.append("Invalid Twitter URL")
        }
        
        isFacebookURLValid = Validator.isValidFacebookURL(user.facebookURL)
        if !isFacebookURLValid {
            errorMessages.append("Invalid Facebook URL")
        }
        
        isInstagramURLValid = Validator.isValidInstagramURL(user.instagramURL)
        if !isInstagramURLValid {
            errorMessages.append("Invalid Instagram URL")
        }
        
        // Set the error message
        errorHandlingManager.errorMessage = errorMessages.joined(separator: "\n")
        
        // Return true if all fields are valid
        return errorMessages.isEmpty
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
