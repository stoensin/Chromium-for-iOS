// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_CHROME_BROWSER_CONTENT_SUGGESTIONS_MEDIATOR_UTIL_H_
#define IOS_CHROME_BROWSER_CONTENT_SUGGESTIONS_MEDIATOR_UTIL_H_

#include "base/bind.h"
#include "base/optional.h"
#include "components/ntp_snippets/category_info.h"
#include "components/ntp_snippets/content_suggestion.h"
#include "components/ntp_snippets/status.h"
#import "ios/chrome/browser/ui/content_suggestions/content_suggestion.h"
#import "ios/chrome/browser/ui/content_suggestions/identifier/content_suggestions_section_information.h"

namespace ntp_snippets {
class ContentSuggestion;
class Category;
class CategoryInfo;
}

@class ContentSuggestionsCategoryWrapper;

// TODO(crbug.com/701275): Once base::BindBlock supports the move semantics,
// remove this wrapper.
// Wraps a callback taking a const ref to a callback taking an object.
void BindWrapper(
    base::Callback<void(ntp_snippets::Status status_code,
                        const std::vector<ntp_snippets::ContentSuggestion>&
                            suggestions)> callback,
    ntp_snippets::Status status_code,
    std::vector<ntp_snippets::ContentSuggestion> suggestions);

// Returns the Type for this |category|.
ContentSuggestionType TypeForCategory(ntp_snippets::Category category);

// Returns the section ID for this |category|.
ContentSuggestionsSectionID SectionIDForCategory(
    ntp_snippets::Category category);

// Returns the section layout corresponding to the category |layout|.
ContentSuggestionsSectionLayout SectionLayoutForLayout(
    ntp_snippets::ContentSuggestionsCardLayout layout);

// Converts a ntp_snippets::ContentSuggestion to an Objective-C
// ContentSuggestion.
ContentSuggestion* ConvertContentSuggestion(
    const ntp_snippets::ContentSuggestion& contentSuggestion);

// Returns a SectionInformation for a |category|, filled with the
// |categoryInfo|.
ContentSuggestionsSectionInformation* SectionInformationFromCategoryInfo(
    const base::Optional<ntp_snippets::CategoryInfo>& categoryInfo,
    const ntp_snippets::Category& category);

// Returns a ntp_snippets::ID based on a Objective-C Category and the ID in the
// category.
ntp_snippets::ContentSuggestion::ID SuggestionIDForSectionID(
    ContentSuggestionsCategoryWrapper* category,
    const std::string& id_in_category);

#endif  // IOS_CHROME_BROWSER_CONTENT_SUGGESTIONS_MEDIATOR_UTIL_H_
