//
//  OnceC.h
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017-2020 Braden Scothern. All rights reserved.
//

#ifndef OnceC_h
#define OnceC_h

#include <sys/types.h>
#include <pthread.h>

/// The struct that we will use in Swift since we cannot directly access `pthread_once_t`.
///
/// Because this only contains the `pthread_once_t`, it will be identical in size and layout.
typedef struct OnceC {
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
/// The context will be saved so the block can then access it via `OnceGetContextPointer()`
///
/// @param onceC The `OnceC` that should be used to protect the `block` of code that should be executed.
/// @param block The function that should be executed and protected by `onceC`.
/// @param context The context pointer that will be stored into thread local storage so it can be accessed in the `block`'s execution.
void OnceCRun(OnceC* onceC, OnceBlock block, const void* context);

/// Get the current context pointer.
///
/// This uses thread local storage.
const void* OnceGetContextPointer(void);

#endif /* OnceC_h */
