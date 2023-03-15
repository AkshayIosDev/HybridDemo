//
//  Constants.swift
//  GeneralHomes
//
//  Created by Uma Shankar on 02/05/20.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import Foundation

//MARK: Custom Fonts

struct FontCustom {
    struct Inter {
        static let black = "Inter-Black"
        static let bold = "Inter-Bold"
        static let extraBold = "Inter-ExtraBold"
        static let extraLight = "Inter-ExtraLight"
        static let light = "Inter-Light"
        static let medium = "Inter-Medium"
        static let regular = "Inter-Regular"
        static let semiBold = "Inter-SemiBold"
        static let thin = "Inter-Thin"
    }
}

struct Constants{
    static let baseUrl = ""//BaseUrl.prod.value
    static let userLogs = "userLogs"
    static let user = "user"
    static let accessToken = "accessToken"
    static let deviceToken = "deviceToken"
    static let Success = "Success"
    static let rememberMe = "isRememberMe"
    static let termsAndConditions = "terms and conditions"
    static let login = "Log in"
    static let resendOtp = "Resend"
    static let signup = "Sign up"
    static let privacyPolicy = "privacy policy"
    static let agreeLabel = "I agree with terms and conditions and privacy policy"
    static let babySizeText = "Your baby is now the size of"
    static let TERMS_AND_COND = "Terms and Conditions"
    static let PRIVACY_POLICY = "Privacy Policy"
    static let invalidCredentials = "Invalid credentials"
    static let missingAuthentication = "Missing authentication"
    static let loginAgain = " please login again "
    static let isLogin = "isLogin"
    static let appId = "1541449232"
    static let dateformat = "dd-MM-yyyy"
    static let isoDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let dynamicLink = "https://partykings.page.link/tV8u"
    static let shareAppText = "shareAppText"
    static let deviceType = "iPhone"
    static let userType = "Driver"
}

extension Constants{
    static let S3_BUCKET_NAME_FOR_USER = "sosbucket/oderImage"
    static let S3_BUCKET_URL = "https://sosbucket.s3.us-east-2.amazonaws.com/"
    static let S3_BUCKET_IMGURL = "https://sosbucket.s3.us-east-2.amazonaws.com/oderImage/"
    static let COGNITO_POOL_ID = "us-east-2:4e7901e8-a7d9-4bd3-8fa5-0843f38939a3"
}

struct ParameterKey {
    static let email = "email"
    static let userName = "userName"
    static let deviceData = "deviceData"
    static let dateAndTime = "dateAndTime"
    static let devicName = "devicName"
    static let signalStrength = "signalStrength"
    static let duration = "duration"
    
    static let phoneNumber = "phoneNumber"
    static let sortByTime = "sortByTime"
    static let sortByDistance = "sortByDistance"
    static let otp = "otp"
    static let userId = "userId"
    static let fullName = "fullName"
    static let dob = "dob"
    static let gender = "gender"
    static let bio = "bio"
    static let eventName = "eventName"
    static let venue = "venue"
    static let name = "name"
    static let jobId = "jobId"
    static let jobIds = "jobIds"
    static let responde = "responde"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let startingTime = "startingTime"
    static let endingTime = "endingTime"
    static let description = "description"
    static let gestLimit = "guestLimit"
    static let category = "category"
    static let hostingEventAs = "hostingEventAs"
    static let partyImage = "partyImage"
    static let price = "price"
    static let images = "images"
    static let userImage = "userImage"
    static let userSelfi = "userSelfi"
    static let areaRadius = "areaRadius"
    static let minPrice = "minPrice"
    static let maxPrice = "maxPrice"
    static let eventHostedby = "eventHostedby"
    static let minAttendence = "minAttendence"
    static let maxAttendence = "maxAttendence"
    static let groupName = "groupName"
    static let groupParticipants = "groupParticipantsId"
    static let goingWith = "goingWith"
    static let partyId = "partyId"
    static let groupId = "groupId"
    static let eventId = "eventId"
    static let userRequestId = "userRequestId"
    static let status = "status"
    static let deviceToken = "deviceToken"
    static let rating = "rating"
    static let userType = "userType"
    static let deviceType = "deviceType"
}
