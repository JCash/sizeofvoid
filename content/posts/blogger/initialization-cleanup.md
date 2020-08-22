---
author: 'Mathias Westerdahl'
title: 'Initialization cleanup'
date: 2020-08-22T00:00:00.002+01:00
tags : [C, C++]
authors: [mathias]
categories: [programming]
---

Every time I write a new system which has to do initialization, I have to deal with the potential cleanup of that function in the case that it actually fails.
Depending on what type of system I'm writing, I have to deal with the error in different ways, with different degrees of gracefulness.

The problem I have is that I think it's easy for the code to become messy, and becomes hard to read.
Granted, this problem domain is not very large, but readability is important and I think it has value to think about this area too.

To sum it up, I have no clear cut way or guidelines on how to deal with this. But I can at least provide some examples I've ended up with.

These examples are fairly representative of the code I use on a daily basis.
And the number of subsystems might vary from 1 to 10, so the code can become fairly messy.

Please let me know if there are any other examples I should add.

## Assert

If the system doesn't have to end gracefully, you can simply assert.
Using C++ exceptions would be very similar to the assert approach.

```cpp
int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    assert(res == 0 && "Failed to create system A");
    *system_x = system;
    return 0;
}
```

## Early return

You can also clean up as you go:

```cpp
int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        DeallocSystemX(system);
        return res;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        DestroySystemA(system->A);
        DeallocSystemX(system);
        return res;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        DestroySystemB(system->B);
        DestroySystemA(system->A);
        DeallocSystemX(system);
        return res;
    }

    *system_x = system;
    return 0;
}
```

Since there might be a fair amount of repetition here, and depending on the complexity of the destruction process,
you might want to invest in a `Cleanup()` function.


```cpp

static void Cleanup(SystemX* system)
{
    if (system->C)
        DestroySystemC(system->C);
    if (system->B)
        DestroySystemB(system->B);
    if (system->A)
        DestroySystemA(system->A);
    DeallocSystemX(system);
}

int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        Cleanup(system);
        return res;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        Cleanup(system);
        return res;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        Cleanup(system);
        return res;
    }

    *system_x = system;
    return 0;
}
```


## Cleanup at the end

Another option is to delay destruction until the end of the function.
Sometimes you create several systems, sometimes you wrap it in if-statements.

```cpp
int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
    }

    if (res == 0)
    {
        res = CreateSystemB(&system->B);
        if (res != 0)
        {
            log_error("Failed to create system B: %s", ErrorToString(res));
        }
    }

    if (res == 0)
    {
        res = CreateSystemC(&system->A);
        if (res != 0)
        {
            log_error("Failed to create system C: %s", ErrorToString(res));
        }
    }

    if (system->A == 0 || system->B == 0 || system->C == 0)
    {
        if (system->A)
            DestroySystemA(system->A);
        if (system->B)
            DestroySystemB(system->B);
        if (system->C)
            DestroySystemC(system->C);
        DeallocSystemX(system);
        return 1;
    }

    *system_x = system;
    return 0;
}
```

## Label

A variation of the cleanup at the end.
This has the benefit of never creating any subsequent sumb systems, if a prior one has failed.
I'm a big advocate for avoiding calling code if unnecessary.

I occasionally see people frowning upon the idea of using labels in their code, but I think it's a very valid tool to use.
Especially in this circumstance.

```cpp
int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    assert(res == 0 && "Failed to create system A");
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        goto bail;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        goto bail;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        goto bail;
    }

bail:
    if (res != 0)
    {
        if (system->A)
            DestroySystemA(system->A);
        if (system->B)
            DestroySystemB(system->B);
        if (system->C)
            DestroySystemC(system->C);
        DeallocSystemX(system);
        return 1;
    }

    *system_x = system;
    return 0;
}
```


## Summary

As I mentioned, there is no clear cut way of doing this, and I still have no favorite way of doing it.
Please let me know if I should add any other examples here.


