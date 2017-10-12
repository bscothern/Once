//
//  OnceC.c
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//

#include "OnceC.h"
#include <stdlib.h>

// Used to make sure we have thread local storage for our context poitner.
static pthread_once_t oncePthreadSwiftContextKey = PTHREAD_ONCE_INIT;
static pthread_key_t pthreadSwiftContextKey;

void CleanThreadStorageKey(void) {
    pthread_key_delete(pthreadSwiftContextKey);
}

void SetupThreadStorageKey(void) {
    atexit(CleanThreadStorageKey);
    
    pthread_key_create(&pthreadSwiftContextKey, NULL);
    pthread_setspecific(pthreadSwiftContextKey, NULL);
}

OnceC OnceCCreate(void) {
    pthread_once(&oncePthreadSwiftContextKey, SetupThreadStorageKey);
    return (OnceC) { .p_once = PTHREAD_ONCE_INIT };
}

void OnceCRun(OnceC* onceC, OnceBlock block) {
    pthread_once(&onceC->p_once, block);
}

void SaveOnceContextPointer(const void* contextPointer) {
    pthread_setspecific(pthreadSwiftContextKey, contextPointer);
}

const void* GetOnceContextPointer(void) {
    return pthread_getspecific(pthreadSwiftContextKey);
}
