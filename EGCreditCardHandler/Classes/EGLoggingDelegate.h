//
//  EGLoggingDelegate.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#ifndef EGCreditCardHandler_EGLoggingDelegate_h
#define EGCreditCardHandler_EGLoggingDelegate_h

#import <Foundation/Foundation.h>

/**
 * This delegate will receive logging callbacks from the card reader framework, and should
 * output them as appropriate for your implementation.
 */
@protocol EGLoggingDelegate <NSObject>

/**
 * Called when the card reader wished to log a message at the 'error' level.
 */
- (void)logError:(NSString*)message;

/**
 * Called when the card reader wished to log a message at the 'warning' level.
 */
- (void)logWarning:(NSString*)message;

/**
 * Called when the card reader wished to log a message at the 'info' level.
 */
- (void)logInfo:(NSString*)message;

/**
 * Called when the card reader wished to log a message at the 'debug' level.
 */
- (void)logDebug:(NSString*)message;

/**
 * Called when the card reader wished to log a message at the 'verbose' level.
 */
- (void)logVerbose:(NSString*)message;

@end

#endif
