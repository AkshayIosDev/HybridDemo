//
//  ApiConstants.swift
//  GeneralHomes
//
//  Created by Dev-Story on 30/04/20.
//  Copyright © 2020 Uma Shankar. All rights reserved.
//

import Foundation
struct API {
    
    // MARK:- Base URL
    
//    static let baseUrl = "http://65.0.42.148:5001"
    static let baseUrl =  "https://api.mindandmom.com"
    
    // MARK:- User API
    
    static let signup = baseUrl + "/user/signUp"
    static let login = baseUrl + "/user/login"
    static let sendOtp = baseUrl + "/user/sendOtp"
    static let verifyOtp = baseUrl + "/user/verifyOtp"
    static let logout = baseUrl + "/user/logout"
    static let forgotPassword = baseUrl + "/user/forgotPassword"
    static let googleLogin = baseUrl + "/user/googleLogin"
    static let createPayment = baseUrl + "/user/createPayment"
    static let updatePassword = baseUrl + "/user/updatePassword"
    static let updateProfile = baseUrl + "/user/updateProfile"
    static let plans = baseUrl + "/user/plans"
    static let profile = baseUrl + "/user/profile"
    static let questions = baseUrl + "/user/questions"
    static let blogs = baseUrl + "/user/blogs"
    static let videos = baseUrl + "/user/videos"
    static let meals = baseUrl + "/user/mealsDayWise"
    static let likeUnlike = baseUrl + "/user/likeUnlike"
    static let bookMarkedMeal = baseUrl + "/user/bookmarkedMeal"
    static let bookmarkedCategory = baseUrl + "/user/bookmarkedCategory"
    static let updateWeight = baseUrl + "/user/updateWeight"
    static let updatePressureLevel = baseUrl + "/user/updatePressureLevel"
    static let updateBumpSize = baseUrl + "/user/updateBumpSize"
    static let updateBabyKicks = baseUrl + "/user/updateBabyKicks"
    static let updateContraction = baseUrl + "/user/updateContraction"
    static let dashboard = baseUrl + "/user/dashboard"
    static let healthDashboard = baseUrl + "/user/healthDashboard"
    static let updateIntakeWater = baseUrl + "/user/updateIntakeWater"
    static let updateWater = baseUrl + "/user/updateWater"
    static let editIntakeWater = baseUrl + "/user/editIntakeWater"
    static let deleteIntakeWater = baseUrl + "/user/deleteIntakeWater"
    static let updatePill = baseUrl + "/user/updatePill"
    static let deletePill = baseUrl + "/user/deletePill"
    static let exerciseVideos = baseUrl + "/user/exercisevideodaywise"
    static let getBookmarkedVideo = baseUrl + "/user/bookmarkedExerciseVideos"
    static let bookmarkVideo = baseUrl + "/user/bookmarkExerciseVideo"
    static let updateTrimester = baseUrl + "/user/updateTrimester"
    static let addTrimester = baseUrl + "/user/addTrimester"
    static let deleteTrimesters = baseUrl + "/user/deleteTriester"
    static let updateInitialBumpSize = baseUrl + "/user/updateInitialBumpSize"
    static let deliveryReset = baseUrl + "/user/deliveryReset"
    static let addToDoList = baseUrl + "/user/addEditTodoList"
    static let notification = baseUrl + "/user/notification"
    static let checkmarkToDoList = baseUrl + "/user/checkMarkedToDoList"
    static let checkmarkTrimester = baseUrl + "/user/checkMarkedTrimester"
    static let createSubscription = baseUrl + "/user/createSubscription"
    static let deleteKick = baseUrl + "/user/deleteKick"
    static let cancelSubscription = baseUrl + "/user/cancelSubscription"
    static let deleteContraction = baseUrl + "/user/deleteContraction"
    static let changePassword = baseUrl + "/user/changePassword"
    static let paymentForIos = baseUrl + "/user/paymentForIos"
    static let TRUE_LABOR_URL = baseUrl + "/trueLaborLink"
    static let FALSE_LABOR_URL = baseUrl + "/falseLaborLink"
    static let PRIVACY_POLICY_URL = baseUrl + "/privacyPolicy"
    static let TERMS_AND_COND_URL = baseUrl + "/termsAndConditions"
    static let categories = baseUrl + "/user/categories"
    static let categoriesWellness = baseUrl + "/user/categoriesWellness"
    static let library = baseUrl + "/user/library"
    static let updateReminderWater = baseUrl + "/user/updateReminderWater"
    static let deleteTodo = baseUrl + "/user/deleteTodo"
    static let trimestersData = baseUrl + "/user/trimestersDataNew"
    static let updateTrimesterNew = baseUrl + "/user/updateTrimesterAndCopy"
    static let orderForRazorpay = baseUrl + "/user/orderForRazorpay"
    static let verifyPaymentForRazorPay = baseUrl + "/user/verifyPaymentForRazorPay"
    static let getVersion = baseUrl + "/user/getVersion"
    static let dashboardNew = baseUrl + "/user/dashboardNew"
    static let bookmarkAll = baseUrl + "/user/bookmarkAll"
    static let getAllbookmark = baseUrl + "/user/getAllbookmark"
}
