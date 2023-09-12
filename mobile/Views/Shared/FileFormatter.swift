//
//  FileFormatter.swift
//  mobile
//
//  Created by cb on 12.09.23.
//

import Foundation
import UniformTypeIdentifiers

struct FileFormatter {
    
    static func toUTType(allowedCvFormat: [String]) -> [UTType] {
        let recognizedFileExtensions: [String: UTType] = [
            ".pdf": .pdf,
            ".xml": .xml,
            ".txt": .plainText,
            ".docx": UTType("org.openxmlformats.wordprocessingml.document")!
        ]

        var allowedCvTypes: [UTType] = []

        for fileExtension in allowedCvFormat {
            let lowercasedExtension = fileExtension.lowercased()

            if let utType = recognizedFileExtensions[lowercasedExtension] {
                allowedCvTypes.append(utType)
            } else {
                // Handle custom or unsupported file extensions here
                print("Custom or unsupported file extension: \(fileExtension)")
                // Instead of fatalError, you can choose to handle it differently
            }
        }
        print("STRINGTypes: \(allowedCvFormat)")
        print("UTTypes: \(allowedCvTypes)")
        return allowedCvTypes
    }
    
    func handleDocumentSelection(fileName: String, result: Result<URL, Error>, completion: @escaping (Result<String, APIError>) -> Void) {
        switch result {
        case .success(let selectedURL):
            return completion(.success(selectedURL.lastPathComponent))
            
        case .failure(let error):
            print("File Selection Error: \(error.localizedDescription)")
            return completion(.failure(APIError.fileFormatError(error.localizedDescription)))
        }
    }
}
