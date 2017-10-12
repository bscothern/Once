//
//  OnceC.h
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
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
