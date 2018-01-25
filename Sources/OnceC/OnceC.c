//
//  OnceC.c
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

#include "OnceC.h"
#include <stdlib.h>

void CleanThreadStorageKey(void);
void SetupThreadStorageKey(void);
void SaveOnceContextPointer(const void* contextPointer);

// Used to make sure we have thread local storage for our context poitner.
static pthread_once_t oncePthreadSwiftContextKey = PTHREAD_ONCE_INIT;
static pthread_key_t pthreadSwiftContextKey;

OnceC OnceCCreate(void) {
    pthread_once(&oncePthreadSwiftContextKey, SetupThreadStorageKey);
    return (OnceC) { .p_once = PTHREAD_ONCE_INIT };
}

void OnceCRun(OnceC* onceC, OnceBlock block, const void* context) {
    SaveOnceContextPointer(context);
    pthread_once(&onceC->p_once, block);
}

const void* GetOnceContextPointer(void) {
    return pthread_getspecific(pthreadSwiftContextKey);
}

//MARK:- Private
void CleanThreadStorageKey(void) {
    pthread_key_delete(pthreadSwiftContextKey);
}

void SetupThreadStorageKey(void) {
    atexit(CleanThreadStorageKey);
    
    pthread_key_create(&pthreadSwiftContextKey, NULL);
    pthread_setspecific(pthreadSwiftContextKey, NULL);
}

void SaveOnceContextPointer(const void* contextPointer) {
    pthread_setspecific(pthreadSwiftContextKey, contextPointer);
}