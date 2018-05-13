//
//  PandoraModel.swift
//  SpotifyExample
//
//  Created by Rory Avant on 5/12/18.
//  Copyright © 2018 Rory Avant. All rights reserved.
//

import Foundation

class PandoraModel {
    
    struct PandoraConfig {
        
        let activeVxRewards : [String]
        let adkv : [String : Any]
        let allowProfileComments : Bool
        let artistAudioMessagesEnabled : Bool
        let artistPromoEmailsEnabled : Bool
        let authToken : String
        let birthYear : Int
        let config : [String : Any]
        let emailOptOut : Bool
        let explicitContentFilterEnabled : Bool
        let gender : String
        let highQualityStreamingEnabled : Bool
        let isNew : Bool
        let listenerId : String
        let listenerToken : String
        let minor : Bool
        let notifyOnComment : Bool
        let notifyOnFollow : Bool
        let profilePrivate : Bool
        let seenEducation : Bool
        let smartConversionAdUrl : String
        let smartConversionDisabled : Bool
        let smartConversionTimeoutMillis : Int
        let stationCount : Int
        let username : String
        let webClientVersion : String
        let webname : String
        let zipCode : String
        
        init(json: [String: Any]) {
            activeVxRewards              =    json["activeVxRewards"]              as? [String]         ?? [String]()
            adkv                         =    json["adkv"]                         as? [String : Any]   ?? [String: Any]()
            allowProfileComments         =    json["allowProfileComments"]         as? Bool             ?? false
            artistAudioMessagesEnabled   =    json["artistAudioMessagesEnabled"]   as? Bool             ?? false
            artistPromoEmailsEnabled     =    json["artistAudioMessagesEnabled"]   as? Bool             ?? false
            authToken                    =    json["authToken"]                    as? String           ?? ""
            birthYear                    =    json["birthYear"]                    as? Int              ?? 9999
            config                       =    json["config"]                       as? [String: Any]    ?? [String: Any]()
            emailOptOut                  =    json["emailOptOut"]                  as? Bool             ?? false
            explicitContentFilterEnabled =    json["explicitContentFilterEnabled"] as? Bool             ?? false
            gender                       =    json["gender"]                       as? String           ?? ""
            highQualityStreamingEnabled  =    json["highQualityStreamingEnabled"]  as? Bool             ?? false
            isNew                        =    json["isNew"]                        as? Bool             ?? false
            listenerId                   =    json["listenerId"]                   as? String           ?? ""
            listenerToken                =    json["listenerToken"]                as? String           ?? ""
            minor                        =    json["minor"]                        as? Bool             ?? true
            notifyOnComment              =    json["notifyOnComment"]              as? Bool             ?? false
            notifyOnFollow               =    json["notifyOnFollow"]               as? Bool             ?? false
            profilePrivate               =    json["profilePrivate"]               as? Bool             ?? false
            seenEducation                =    json["seenEducation"]                as? Bool             ?? false
            smartConversionAdUrl         =    json["smartConversionAdUrl"]         as? String           ?? ""
            smartConversionDisabled      =    json["smartConversionDisabled"]      as? Bool             ?? false
            smartConversionTimeoutMillis =    json["smartConversionTimeoutMillis"] as? Int              ?? 0
            stationCount                 =    json["stationCount"]                 as? Int              ?? 9999
            username                     =    json["username"]                     as? String           ?? ""
            webClientVersion             =    json["webClientVersion"]             as? String           ?? ""
            webname                      =    json["webname"]                      as? String           ?? ""
            zipCode                      =    json["zipCode"]                      as? String           ?? ""
        }
    }
}
