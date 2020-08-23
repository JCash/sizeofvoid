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

_Edit 2020-08-23: Thanks for all the suggestions and ideas. I've update examples of reverse order labels, result-and-error, leave-it-for-later and defer. Special thanks to [Don Williamson](https://twitter.com/Donzanoid), [Bobby Anguelov](https://twitter.com/Bobby_Anguelov), [Stefan Reinalter](https://twitter.com/molecularmusing) and [John McDonald](https://twitter.com/basisspace).<br>
I've also divided the variations into internal/external cleanup.
Here's the original [tweet](https://twitter.com/mwesterdahl76/status/1297156971989262340) in case there are new discussions popping up there in the future._

## Internal cleanup

These are the variations where the cleanup is handled directly inside the `Create()` function.

### Assert

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

### Early return

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

### Cleanup function
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

### Cleanup at the end

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
        res = CreateSystemC(&system->C);
        if (res != 0)
        {
            log_error("Failed to create system C: %s", ErrorToString(res));
        }
    }

    if (res != 0)
    {
        if (system->B)
            DestroySystemB(system->B);
        if (system->A)
            DestroySystemA(system->A);
        DeallocSystemX(system);
        return 1;
    }

    *system_x = system;
    return 0;
}
```

### Separate Create function

_Added 2020-08-23:_
As Don pointed out, the "Cleanup" example can be slightly rewritten, to move the `Cleanup()` call outside of the scope, and at the same time have a separate `Create()` function, which also matches well symmetry wise:

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

static int Create(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        return res;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        return res;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        return res;
    }

    *system_x = system;
    return 0;
}

int CreateSystemX(SystemX** system_x)
{
    if (!Create(system_x)) {
        Cleanup(*system_x);
        return 1;
    }
    return 0;
}
```

### Log and return

_Added 2020-08-23:_
A small variation to reduce number of lines, is to let the `log_error` function return the return value, and at the same time output the error in string form. I think it really improves on the readability.

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

static int Create(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        return log_error(res, "Failed to create system A");
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        return log_error(res, "Failed to create system B");
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        return log_error(res, "Failed to create system C");
    }

    *system_x = system;
    return 0;
}

int CreateSystemX(SystemX** system_x)
{
    if (!Create(system_x)) {
        Cleanup(*system_x);
        return 1;
    }
    return 0;
}
```


### Label

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
        if (system->C)
            DestroySystemC(system->C);
        if (system->B)
            DestroySystemB(system->B);
        if (system->A)
            DestroySystemA(system->A);
        DeallocSystemX(system);
        return 1;
    }

    *system_x = system;
    return 0;
}
```

### Reverse order labels

_Added 2020-08-23:_
A variation suggested by [John McDonald](https://twitter.com/basisspace), is to use multiple labels, and deconstruct in reverse order. This will eliminate the need for the if-statements:

```cpp
int CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        goto cleanup;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        goto cleanup_a;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        goto cleanup_b;
    }

    *system_x = system;
    return 0;

cleanup_b:  DestroySystemB(system->B);
cleanup_a:  DestroySystemA(system->A);
cleanup:    DeallocSystemX(system);
    return 1;
}
```


## External cleanup

These variations puts the responsibility of the cleanup on the caller.

### Destroy on error

_Added 2020-08-23:_
The "external" variation of the [Separate Create function]({{< relref "#separate-create-function" >}}) cleanup looks like this:

```cpp
void DestroySystemX(SystemX* system)
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
        return res;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        return res;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        return res;
    }

    *system_x = system;
    return 0;
}
```

And at the caller site:
```cpp
if (!CreateSystemX(system_x)) {
    DestroySystemX(*system_x);
}
```


### Result and Error tuple

_Added 2020-08-23:_
A c++ variation of the `foo` is to have the `Create` function return a 2-tuple, containing the value and the error code. I do think that the CreateSystemX()/DestroySystemX() loses a bit of its symmetry though, in terms of the return types. And I'm not sure the readability improved inside the `Create` function.

Here's [a link](http://www.furidamu.org/blog/2017/01/28/error-handling-with-statusor/) describing the pattern a bit more.

_(Reservations for any actual code errors, as I'm typing as I go, and I haven't actually used this pattern very much :) )_

```cpp
template<typename T, typename E>
struct Result {
    T   m_Value;
    E   m_Error;
    Result(T v, R e);
    bool is_ok();
    T    value();
    E    error();
};
```

```cpp
Result<SystemX*, int> CreateSystemX()
{
    SystemX* system = AllocSystemX();
    Result<SystemA*, int> result_a = CreateSystemA();
    if (!result_a.is_ok())
    {
        log_error(result_a.error(), "Failed to create system A");
        return Result<SystemX*, int>(system, result_a.error());
    }

    Result<SystemB*, int> result_b = CreateSystemB();
    if (!result_b.is_ok())
    {
        log_error(result_b.error(), "Failed to create system B");
        return Result<SystemX*, int>(system, result_b.error());
    }

    Result<SystemC*, int> result_c = CreateSystemC();
    if (!result_c.is_ok())
    {
        log_error(result_c.error(), "Failed to create system C");
        return Result<SystemX*, int>(system, result_c.error());
    }

    return Result<SystemX*, int>(system, 0);
}

void DestroySystemX(SystemX* system);
```

And, from the caller site:
```cpp
Result<SystemX*, int> result = CreateSystemX();
if (!result.is_ok())
    DestroySystemX(result.value());
```

### Leave it for later

_Added 2020-08-23:_
As Bobby suggested, we can also defer the entire cleanup until it was meant to be.
Since this puts the system in an unknown state, we must therefore add a flag indicating this.

One reason for this approach is that there might not be logging available in a live release build.

```cpp
void CreateSystemX(SystemX** system_x)
{
    SystemX* system = AllocSystemX();
    system->Initialized = 0;
    int res = CreateSystemA(&system->A);
    if (res != 0)
    {
        log_error("Failed to create system A: %s", ErrorToString(res));
        return;
    }

    res = CreateSystemB(&system->B);
    if (res != 0)
    {
        log_error("Failed to create system B: %s", ErrorToString(res));
        return;
    }

    res = CreateSystemC(&system->C);
    if (res != 0)
    {
        log_error("Failed to create system C: %s", ErrorToString(res));
        return;
    }

    system->Initialized = 1;
    *system_x = system;
}

void UpdateSystemX(SystemX* system)
{
    if (!system->Initialized)
        return;
}
```



## Summary

As I mentioned, there is no clear cut way of doing this, and I still have no favorite way of doing it.
Please let me know if I should add any other examples here.




