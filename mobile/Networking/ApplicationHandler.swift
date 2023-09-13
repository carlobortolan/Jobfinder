//
//  ApplicationHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class ApplicationHandler {
    
    static func fetchApplication(accessToken: String, jobId: Int, completion: @escaping (Result<ApplicationResponse, APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(jobId)" +  Routes.APPLICATION_PATH ) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType: ApplicationResponse.self, completion: completion)
    }
    
    static func fetchOwnApplications(accessToken: String, completion: @escaping (Result<ApplicationsResponse, APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_APPLICATIONS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType: ApplicationsResponse.self, completion: completion)
    }
    
    static func createNormalApplication(accessToken: String, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating application with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        let requestBody = ["application": ["application_text": application.applicationText]]
        
        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.POST,
            accessToken: accessToken,
            responseType: APIResponse.self,
            requestBody: requestBody,
            completion: completion
        )
    }
    
    static func acceptApplication(accessToken: String, message: String?, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started accepting application with: \naccess_token: \(accessToken)\njobId: \(application.jobId)\nuserId: \(application.userId)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH + "/\(application.userId)" + Routes.ACCEPT_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
         
        if let message {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                queryParameters: ["message": message],
                completion: completion
            )
        } else {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                completion: completion
            )
        }
    }
    
    static func createAttachmentApplication(accessToken: String, application: Application, attachment: Data, format: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating application with: \naccess_token: \(accessToken)\njobId: \(application.jobId)\nuserId: \(application.userId)")

        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }


        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"application_text\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(application.applicationText)\r\n".data(using: .utf8)!)

        var contentType = ""
        switch format {
            case ".pdf":
                contentType = "application/pdf"
            case ".docx":
                contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            case ".xml":
                contentType = "text/xml"
            case ".txt":
                contentType = "text/plain"
            default:
                contentType = ""
        }
        let filename = "\(application.jobId)_\(application.userId)_cv\(format)"
        print("ContentType: \(contentType)")
        print("fileName: \(filename)")
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"application_attachment\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        body.append(attachment)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(APIError.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")
                print("HTTP Response: \(response.debugDescription)")
                
                RequestHandler.handleApiErrorsNew(data: data, statusCode: statusCode, completion: completion)
                switch statusCode {
                case 204:
                    completion(.failure(APIError.noContent(String(describing: ImageResponse.self))))
                case 200:
                    if let data = data {
                        do {
                            if let responseString = String(data: data, encoding: .utf8) {
                                print("Data as String: \(responseString)")
                            } else {
                                print("Failed to convert data to string")
                            }
                            let responseData = try JSONDecoder().decode(APIResponse.self, from: data)
                            completion(.success(responseData))
                        } catch {
                            print("JSON Error: \(error)")
                            completion(.failure(APIError.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                default:
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                        } catch {
                            completion(.failure(APIError.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                }
            }
        }.resume()
    }

    
    static func rejectApplication(accessToken: String, message: String?, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started rejecting application with: \naccess_token: \(accessToken)\njobId: \(application.jobId)\nuserId: \(application.userId)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH + "/\(application.userId)" + Routes.REJECT_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
                
        if let message {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                queryParameters: ["message": message],
                completion: completion
            )
        } else {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                completion: completion
            )
        }
    }
}

