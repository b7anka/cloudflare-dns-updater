//
//  RecordType.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

// swiftlint:disable identifier_name
enum RecordType: String {
    
    case a = "A"
    case aaaa = "AAAA"
    case caa = "CAA"
    case cert = "CERT"
    case cname = "CNAME"
    case dnskey = "DNSKEY"
    case ds = "DS"
    case https = "HTTPS"
    case loc = "LOC"
    case mx = "MX"
    case naptr = "NAPTR"
    case ns = "NS"
    case ptr = "PTR"
    case smimea = "SMIMEA"
    case srv = "SRV"
    case sshfp = "SSHFP"
    case svcb = "SVCB"
    case tlsa = "TLSA"
    case txt = "TXT"
    case uri = "URI"
    
}
