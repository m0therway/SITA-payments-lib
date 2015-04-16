//
//  EGCardReaderManager.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EGCardTransaction;
@protocol EGFlightInfo;
@protocol EGLoggingDelegate;

/**
 * A callback that is executed when a transaction is complete.
 * If an error occurs, the error parameter will be non-nil.
 */
typedef void (^EGTransactionCallback)(NSError* error);

/**
 * A manager responsible for interacting with the card reader device.
 */
@interface EGCardReaderManager : NSObject

/**
 * This delegate is responsible for providing logging facilities for the card reader.
 */
@property(nonatomic,readonly) id<EGLoggingDelegate> loggingDelegate;

/**
 * Standard initializer.
 */
- (instancetype)initWithLoggingDelegate:(id<EGLoggingDelegate>)loggingDelegate;

/**
 * Requests that the card reader perform a swipe transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param flightInfo An EGFlightInfo representing the current flight.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performSwipeTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback;

/**
 * Requests that the card reader perform an NFC transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param flightInfo An EGFlightInfo representing the current flight.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performNFCTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback;

/**
 * Requests that the card reader perform an EMV (i.e., chip and PIN) transaction.
 * This is an asynchronous operation.
 *
 * @param transaction An EGCardTransaction representing the desired transaction.
 * @param flightInfo An EGFlightInfo representing the current flight.
 * @param callback A block that will be executed when the transaction completes.
 */
- (void)performEMVTransaction:(id<EGCardTransaction>)transaction withFlightInfo:(id<EGFlightInfo>)flightInfo callback:(EGTransactionCallback)callback;

@end
