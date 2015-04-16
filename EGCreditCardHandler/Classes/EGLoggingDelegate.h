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

typedef enum {
	EGLogLevelError,
	EGLogLevelWarn,
	EGLogLevelInfo,
	EGLogLevelDebug,
	EGLogLevelVerbose
} EGLogLevel;

/**
 * This delegate will receive logging callbacks from the card reader framework, and should
 * output them as appropriate for your implementation.
 */
@protocol EGLoggingDelegate <NSObject>

/**
 * Called when the card reader wishes to output a log message.
 */
- (void)logMessageWithLevel:(EGLogLevel)level file:(const char *)file function:(const char *)function lineNumber:(NSUInteger)lineNumber format:(NSString*)format, ...;


@end

#endif
