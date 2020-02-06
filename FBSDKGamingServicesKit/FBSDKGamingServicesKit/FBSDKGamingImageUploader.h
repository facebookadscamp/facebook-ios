// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#if SWIFT_PACKAGE
#import "FBSDKGamingServiceCompletionHandler.h"
#else
#import <FBSDKGamingServicesKit/FBSDKGamingServiceCompletionHandler.h>
#endif

@class FBSDKGamingImageUploaderConfiguration;

NS_SWIFT_NAME(GamingImageUploader)
@interface FBSDKGamingImageUploader : NSObject

/**
 Runs an upload to a users Gaming Profile with the given configuration

 @param configuration model object contain the content that will be uploaded
 @param completionHandler a callback that is fired dependent on the configuration.
  Fired when the upload completes or when the users returns to the caller app
  after the media dialog is shown.
 */
+ (void)uploadImageWithConfiguration:(FBSDKGamingImageUploaderConfiguration * _Nonnull)configuration
                andCompletionHandler:(FBSDKGamingServiceCompletionHandler _Nonnull)completionHandler;

@end
