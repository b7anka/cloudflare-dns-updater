//
//  DefaultLoggerSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Quick
import Nimble
@testable import CloudflareDNSUpdater

final class DefaultLoggerSpec: QuickSpec {
    override static func spec() {
        describe("DefaultLogger") {
            var sut: DefaultLogger!
            
            beforeEach {
                sut = DefaultLogger.shared
            }
            
            context("when logging a message") {
                let testMessage = "Test message"
                
                context("in debug mode") {
                    beforeEach {
                        sut.setAppConfig(.debug)
                    }
                    
                    it("should print the message") {
                        let result = sut.logMessage(message: testMessage)
                        expect(result) == true
                    }
                }
                
                context("in release mode") {
                    beforeEach {
                        sut.setAppConfig(.release)
                    }
                    
                    it("should print the message") {
                        let result = sut.logMessage(message: testMessage)
                        expect(result) == false
                    }
                }
            }
        }
    }
}
