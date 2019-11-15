//
//  OnceC.c
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017-2019 Braden Scothern. All rights reserved.
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

#include <stdlib.h>
#include "OnceC.h"

//MARK:- Forward Declarations

/// Used to make sure we have thread local storage for our context poitner.
static pthread_once_t oncePthreadSwiftContextKey = PTHREAD_ONCE_INIT;

/// Used to access the context pointer that swift specifies.
static pthread_key_t pthreadSwiftContextKey;

/// Cleans up thread local storage when `atexit()` is called.
static void OnceCleanThreadStorageKey(void);

/// Makes sure that `pthreadSwiftContextKey` is setup to be used.
static void OnceSetupThreadStorageKey(void);

/// A helper funciton that will save the given `contextPointer` to thread local storage.
///
/// @param contextPointer The pointer that should be saved into thread local storage and be accessible via `OnceGetContextPointer()`
static void OnceSaveContextPointer(const void* contextPointer);

//MARK:- Public Funcs
OnceC OnceCCreate(void) {
    pthread_once(&oncePthreadSwiftContextKey, OnceSetupThreadStorageKey);
    return (OnceC) { .p_once = PTHREAD_ONCE_INIT };
}

void OnceCRun(OnceC* onceC, OnceBlock block, const void* context) {
    OnceSaveContextPointer(context);
    pthread_once(&onceC->p_once, block);
}

const void* OnceGetContextPointer(void) {
    return pthread_getspecific(pthreadSwiftContextKey);
}

//MARK:- Private Funcs
static void OnceCleanThreadStorageKey(void) {
    pthread_key_delete(pthreadSwiftContextKey);
}

static void OnceSetupThreadStorageKey(void) {
    atexit(OnceCleanThreadStorageKey);
    
    pthread_key_create(&pthreadSwiftContextKey, NULL);
    pthread_setspecific(pthreadSwiftContextKey, NULL);
}

static void OnceSaveContextPointer(const void* contextPointer) {
    pthread_setspecific(pthreadSwiftContextKey, contextPointer);
}
