//
//  OnceC.h
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#ifndef OnceC_h
#define OnceC_h

#include <pthread.h>

/// The struct that we will expose to Swift since we cannot access `pthread_once_t`.
///
/// Because this only contains the `pthread_once_t`, it will be identical in size.
typedef struct _OnceC {
    pthread_once_t p_once;
} OnceC;

/// The function type that is expected by pthread_once.
typedef void (*OnceBlock)(void);

/// Create a `OnceC` and return it.
///
/// This will initialize the `pthread_once_t` that is backing up how Once works.
OnceC OnceCCreate(void);

/// Runs the block using pthread_once.
///
/// The context will be saved so the block can then access it via `GetOnceContextPointer()`
void OnceCRun(OnceC* onceC, OnceBlock block, const void* context);

/// Get the current context pointer.
///
/// This uses thread local storage.
const void* GetOnceContextPointer(void);

#endif /* OnceC_h */
