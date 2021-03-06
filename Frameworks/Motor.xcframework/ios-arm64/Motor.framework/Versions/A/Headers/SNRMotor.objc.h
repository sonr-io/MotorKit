// Objective-C API for talking to github.com/sonr-io/sonr/bind/motor-mobile Go package.
//   gobind -lang=objc -prefix="SNR" github.com/sonr-io/sonr/bind/motor-mobile
//
// File is generated by gobind. Do not edit.

#ifndef __SNRMotor_H__
#define __SNRMotor_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


/**
 * Address returns the address of the wallet.
 */
FOUNDATION_EXPORT NSString* _Nonnull SNRMotorAddress(void);

/**
 * Balance returns the balance of the wallet.
 */
FOUNDATION_EXPORT long SNRMotorBalance(void);

FOUNDATION_EXPORT NSData* _Nullable SNRMotorCreateAccount(NSData* _Nullable buf, NSError* _Nullable* _Nullable error);

/**
 * DidDoc returns the DID document as JSON
 */
FOUNDATION_EXPORT NSString* _Nonnull SNRMotorDidDoc(void);

FOUNDATION_EXPORT NSData* _Nullable SNRMotorInit(NSData* _Nullable buf, NSError* _Nullable* _Nullable error);

FOUNDATION_EXPORT NSData* _Nullable SNRMotorLogin(NSData* _Nullable buf, NSError* _Nullable* _Nullable error);

#endif
