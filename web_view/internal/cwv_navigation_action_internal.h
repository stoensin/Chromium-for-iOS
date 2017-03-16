// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_WEB_VIEW_INTERNAL_CWV_NAVIGATION_ACTION_INTERNAL_H_
#define IOS_WEB_VIEW_INTERNAL_CWV_NAVIGATION_ACTION_INTERNAL_H_

#import "ios/web_view/public/cwv_navigation_action.h"

@interface CWVNavigationAction ()

- (nonnull instancetype)init NS_UNAVAILABLE;

- (nonnull instancetype)initWithRequest:(nonnull NSURLRequest*)request
                          userInitiated:(BOOL)userInitiated
    NS_DESIGNATED_INITIALIZER;

@end

#endif  // IOS_WEB_VIEW_INTERNAL_CWV_NAVIGATION_ACTION_INTERNAL_H_
