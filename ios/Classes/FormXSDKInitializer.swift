//
//  FormXSDKInitializer.swift
//  formx_sdk_flutter
//
//  Created by wu mark on 2023/12/18.
//
import FormX

class FormXSDKInitializer {
    static let shared = FormXSDKInitializer()
    var extractorId: String?
    
    private var currentApiClient: FormXAPIClient? = nil
    
    func `init`(extractorId: String, accessToken: String, apiHost: String? = nil) {
        self.extractorId = extractorId
        currentApiClient = FormXAPIClient(accessToken: accessToken, apiHost: apiHost)
    }
    
    var apiClient: FormXAPIClient? {
        return currentApiClient
    }
}
