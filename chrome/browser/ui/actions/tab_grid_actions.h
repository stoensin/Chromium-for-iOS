// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ======                        New Architecture                         =====
// =         This code is only used in the new iOS Chrome architecture.       =
// ============================================================================

#ifndef IOS_CHROME_BROWSER_UI_ACTIONS_TAB_GRID_ACTIONS_H_
#define IOS_CHROME_BROWSER_UI_ACTIONS_TAB_GRID_ACTIONS_H_

#import <Foundation/Foundation.h>

// Target/Action methods relating to the tab grid.
@protocol TabGridActions
@optional
// Dismisses whatever UI is currently active and shows the tab grid.
- (void)showTabGrid:(id)sender;
@end

#endif  // IOS_CHROME_BROWSER_UI_ACTIONS_TAB_GRID_ACTIONS_H_