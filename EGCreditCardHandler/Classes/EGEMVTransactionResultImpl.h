//
//  EGEMVTransactionResultImpl.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/20/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGTransactionResultImpl.h"
#import <EGPaymentService/EGEMVTransactionResult.h>

@interface EGEMVTransactionResultImpl : EGTransactionResultImpl <EGEMVTransactionResult>

@property(nonatomic,copy,readonly) NSString* eMVTrack2Encrypted;
@property(nonatomic,copy,readonly) NSString* eMVApplicationIdentifierField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerScriptTemplate1Field;
@property(nonatomic,copy,readonly) NSString* eMVIssuerScriptTemplate2Field;
@property(nonatomic,copy,readonly) NSString* eMVApplicationInterchangeProfileField;
@property(nonatomic,copy,readonly) NSString* eMVDedicatedFileNameField;
@property(nonatomic,copy,readonly) NSString* eMVAuthorizationResponseCodeField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerAuthenticationDataField;
@property(nonatomic,copy,readonly) NSString* eMVTerminalVerificationResultsField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionDateField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionStatusInformationField;
@property(nonatomic,copy,readonly) NSString* eMVCryptogramTransactionTypeField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerCountryCodeField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionCurrencyCodeField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionAmountField;
@property(nonatomic,copy,readonly) NSString* eMVApplicationUsageControlField;
@property(nonatomic,copy,readonly) NSString* eMVApplicationVersionNumberField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerActionCodeDenialField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerActionCodeOnlineField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerActionCodeDefaultField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerApplicationDataField;
@property(nonatomic,copy,readonly) NSString* eMVTerminalCountryCodeField;
@property(nonatomic,copy,readonly) NSString* eMVInterfaceDeviceSerialNumberField;
@property(nonatomic,copy,readonly) NSString* eMVApplicationCryptogramField;
@property(nonatomic,copy,readonly) NSString* eMVCryptogramInformationDataField;
@property(nonatomic,copy,readonly) NSString* eMVTerminalCapabilitiesField;
@property(nonatomic,copy,readonly) NSString* eMVCardholderVerificationMethodResultsField;
@property(nonatomic,copy,readonly) NSString* eMVTerminalTypeField;
@property(nonatomic,copy,readonly) NSString* eMVApplicationTransactionCounterField;
@property(nonatomic,copy,readonly) NSString* eMVUnpredictableNumberField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionSequenceCounterIDField;
@property(nonatomic,copy,readonly) NSString* eMVApplicationCurrencyCodeField;
@property(nonatomic,copy,readonly) NSString* eMVTransactionCategoryCodeField;
@property(nonatomic,copy,readonly) NSString* eMVIssuerScriptResultsField;
@property(nonatomic,copy,readonly) NSString* eMVPanSequenceNumber;
@property(nonatomic,copy,readonly) NSString* eMVServiceCode;
@property(nonatomic,copy,readonly) NSString* eMVShortFileIdentifier;
@property(nonatomic,copy,readonly) NSString* nonEMVPinEntryRequired;
@property(nonatomic,copy,readonly) NSString* nonEMVSignatureRequired;
@property(nonatomic,copy,readonly) NSString* nonEMVConfirmationResponseCode;
@property(nonatomic,copy,readonly) NSString* nonEMVTransactionType;
@property(nonatomic,copy,readonly) NSString* nonEMVErrorResponseCode;
@property(nonatomic,copy,readonly) NSString* nonEMVCardPaymentCode;
@property(nonatomic,copy,readonly) NSString* nonEMVCardEntryCode;

- (void)updateWithRBAParameter:(NSInteger)parameterId;

- (BOOL)isOfflineApproved;

@end
