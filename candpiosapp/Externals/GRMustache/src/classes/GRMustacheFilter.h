// The MIT License
// 
// Copyright (c) 2012 Gwendal Roué
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "GRMustacheAvailabilityMacros.h"


// =============================================================================
#pragma mark - <GRMustacheFilter>

/**
 * The name of exceptions raised by GRMustache whenever a filter is missing, or
 * the object expected to conform to the <GRMustacheFilter> protocol does not.
 *
 * @see GRMustacheFilter protocol
 *
 * @since v4.3
 */
extern NSString * const GRMustacheFilterException AVAILABLE_GRMUSTACHE_VERSION_5_0_AND_LATER;


/**
 * The protocol for implementing GRMustache filters.
 *
 * The responsability of a GRMustacheFilter is to transform a value into
 * another.
 *
 * For instance, the tag `{{ uppercase(name) }}` uses a filter object that
 * returns the uppercase version of its input.
 *
 * **Companion guide:** https://github.com/groue/GRMustache/blob/master/Guides/runtime/filters.md
 *
 * @since v4.3
 */
@protocol GRMustacheFilter <NSObject>
@required

////////////////////////////////////////////////////////////////////////////////
/// @name Transforming Values
////////////////////////////////////////////////////////////////////////////////

/**
 * Applies some transformation to its input, and returns the transformed value.
 *
 * @param object  An object to be processed by the filter.
 *
 * @return A transformed value.
 *
 * @since v4.3
 */
- (id)transformedValue:(id)object AVAILABLE_GRMUSTACHE_VERSION_5_0_AND_LATER;

@end



// =============================================================================
#pragma mark - GRMustacheFilter

/**
 * The GRMustacheFilter class helps building mustache filters without writing a
 * custom class that conforms to the GRMustacheFilter protocol.
 *
 * **Companion guide:** https://github.com/groue/GRMustache/blob/master/Guides/runtime/filters.md
 *
 * @see GRMustacheFilter protocol
 *
 * @since v4.3
 */ 
@interface GRMustacheFilter : NSObject<GRMustacheFilter>

////////////////////////////////////////////////////////////////////////////////
/// @name Creating Filters
////////////////////////////////////////////////////////////////////////////////

/**
 * Returns a GRMustacheFilter object that executes the provided block when
 * tranforming a value.
 *
 * @param block   The block that transforms its input.
 *
 * @return a GRMustacheFilter object.
 *
 * @since v4.3
 */
+ (id)filterWithBlock:(id(^)(id value))block AVAILABLE_GRMUSTACHE_VERSION_5_0_AND_LATER;

@end
