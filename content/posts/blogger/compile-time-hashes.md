---
title: 'Compile time hashes'
date: 2012-07-12T21:36:00.001+02:00
draft: false
tags : [MurmurHash3, constexpr, gcc, C++, clang]
authors: [mathias]
categories: [programming]
---

## C++11

Recently I’ve seen more and more of the C++11 features in the code reviews I oversee, so I needed to read up on the details. Some of the features were already featured in the C++0X standard, which has been semi-supported for some time now.

*   [C++11 on wikipedia](http://en.wikipedia.org/wiki/C%2B%2B11) \- A brief overview of the features
*   [Availability](http://www.aristeia.com/C++11/C++11FeatureAvailability.htm) \- A list of links specifying the different compilers’ support
*   [C++ Reference](http://en.cppreference.com/w/)

The second link will give you a hint of what’s supported for various compilers. Unfortunately, no current compiler supports C++11 entirely. And as usual it’s that MSVS is the farthest behind the standard.

The resulting files have been zipped together for your convenience: [mm3hash.zip](https://sites.google.com/site/mwesterdahlfiles/home/mm3hash.zip)

## constexpr

One feature that caught my eye was the [constexpr](http://en.cppreference.com/w/cpp/language/constexpr) keyword.

In short, it allows you to write functions that give you constant expressions at compile time.

Example:

```cpp
#include <stdio.h>

constexpr int multiply(int x, int y) {
  return x * y;
}
int main(int argc, const char** argv) {
  enum {
    eVal = multiply(3, 4)
  };

  printf("eVal == %d\n", eVal);
  return 0;
}
```

Here you see a case where the enum is initialized to something that’s actually evaluated at compile time. That gives you another tool in your belt that is even more powerful than any defined macro.

Another benefit of functions like these, is that they can also be used at runtime.

Constexpr functions has some interesting restrictions (I only list a few):

*   No local variables
*   No for loops, no if-statements
*   The body can only contain a single return statement
*   The function cannot return void

Fortunately, constexpr functions are allowed to use other constexpr functions and variables. This means recursion is allowed. Also, if-expressions are allowed.

This means that, if make your code into a giant one liner, chances are you can make it a constexpr function.


The main drawback, I think, is that the constexpr keyword isn’t implemented yet in MSVC 12rc. Hopefully, they’ll add it to their todo list soon..


## Hashes

Something that I’ve wanted for some time (but haven’t really pursued) is compile time hashes. It would allow me to remove some unwanted runtime hashing. When I searched for similar articles, I found a few related results:


*   [Quasi compile time hashing](http://www.altdevblogaday.com/2011/10/27/quasi-compile-time-string-hashing/) \- Stefan Reinalter
*   [Static hashes](http://bitsquid.blogspot.se/2010/10/static-hash-values.html) \- Niklas Frykholm
*   [Compile time string hashing](http://stackoverflow.com/questions/2111667/compile-time-string-hashing) \- Crc32 implementation on Stack overflow


Most results I got were either very old or based on defines or other tricks. I found two that were using constexpr and even one that is using some undefined murmur version.

My requirements were:

*   Use constexpr - To remove any redundant runtime hashing
*   Use Murmur3 - I want to use Murmur3 in the game engine, and I want the string hashing to yield the same results as the original implementation.


I chose the Murmur hash since it is fast, stable and has a fairly low [collision rate](http://blog.aggregateknowledge.com/tag/collision).


Actually converting the Murmur3 into a constexpr function wasn’t that difficult, since I had the original function to compare the results with.

The resulting code can been seen at the end of the article.


## Performance

Making the function entirely recursive would of course have a negative impact on the runtime performance. And when I used the function in the [SMHasher](http://code.google.com/p/smhasher/) framework it was indeed 30%-50% slower. I tested this on a 64 bit Macbook Pro @ 2.26 Ghz dual core with 2GB ram.

As I suspected (and hoped), the only difference between the original/modified functions was the speed performance. Given the speed decrease, you might want to rely on the original implementation if you wish to do runtime hashing.


## String literals

Another feature that seems interesting to me was the user defined literals. This allows you to hook into the parsing of the actual c++ text. This might come in handy for string hashes.
A quick example:

```cpp
#include <stdio.h>
#include <cstring>

struct String {
  String(const char* s, size_t len) : m_String(s), m_Length(len) {}
  const char* const m_String;
  const size_t m_Length;
};

String operator "" _str(const char* s, size_t len) {
  return String(s, len);
}

int main(int argv, const char** argc) {
  String s = "hello"_str;
  printf("string: %s\n", s.m_String);
  return 0;
}
```


There are other types of literals too as seen [here](http://en.wikipedia.org/wiki/C%2B%2B11#User-defined_literals).
The string literal can of course be constexpr too.


## Notes on implementation

The excessive recursive nature of the final function is of course affecting implementation and performance in some ways.

### Compilers

I started using the clang that came with XCode but I couldn’t get it to work. That was until I read that Apple apparently has “rolled their own” version of clang. Go figure. So when I installed a proper clang 3.2, my code worked without any errors. Clang 3.1 should work as well.

As for gcc, I tested the code using gcc 4.7. Gcc 4.6 version should work too.


### Casting

The original implementation relies on different pointer types. However, the constexpr function doesn’t allow casting a pointer between types. Hence I implemented the ConstString struct so I kept the same type between calls.


### Inlining

Although the compiler didn’t complain about putting the implementation in the cpp file, that essentially made the constexpr function an ordinary function. And when using the function to initialize an enum, it complained about the function not being implemented.

The solution was to put the implementation into the header file.


### Max depth

Since it’s actually a recursive method we’re using here, you might end up with an error like:

    error: constexpr evaluation depth exceedsmaximum of 512


The solution might be to increase the max depth like so: `-fconstexpr-depth=4096`
 

The default depth allowed me to produce hashes for keys of max length ~8100 characters. That should suffice for all my cases (resource names, events, objects id's etc).


### Did it work?

For simple cases like enums and switch cases, the compiler will immediately tell you if it couldn’t convert the constexpr function call into a compile time constant.


But since the constexpr functions are designed to also work at runtime, I needed to be sure that they worked as intended. And instead of looking at the assembler code, I used the strings command to output and grep the remaining built in strings:

    strings a.out | grep hello

There is a windows version of [strings](http://technet.microsoft.com/en-us/sysinternals/bb897439.aspx) from SysInternals.


### Are they doing it right?

The whole point of the compile time hashing is to remove the strings from the executable and free up CPU cycles at runtime. So we would like to prevent the users from inadvertently calling the functions at runtime.
Unfortunately, there is no such way. At least not that I could find.


### Debugging

The developers are likely to run into trouble at some point during the projects, and if we’ve done away with the strings, it’s going to be difficult reverse engineering the string from the hash.


So, in the spirit of this [blog entry](http://www.altdevblogaday.com/2011/10/27/quasi-compile-time-string-hashing/) by Stefan Reinalter, I started using an intermediary struct: StringHash. My implementation is slightly different to his version, but the idea is the same. In the optimized build, you may remove the string part of the StringHash using defines.


## Conclusions

With the constexpr keyword, it’s another nail in the coffin for the more complex defines. You get type safety for free, and you can also use the functions at runtime (if you wish).
As usual, playing with the code yourself teaches you stuff that can’t really be expressed well in a short blog entry. So I suggest that you get your hands dirty, perhaps converting some of your old defines into constexpr functions/variables.
As for the rest of the C++11 features, there is tons of details to read up on. Let us know if you find anything fun/useful!



## Oh.. yes... the code...

Almost forgot...
Here is the bundled code: [mm3hash.zip](https://sites.google.com/site/mwesterdahlfiles/home/mm3hash.zip)

And here's how to use it:

```cpp
enum ETest
{
    testval1 = MurmurHash3c_64( "hello enum" ),
    testval2 = "hello enum"_hash,
];

switch("hello switch"_hash)
{
    case "hello switch"_hash:  break;
};

constexpr StringHash sh = "hello string"_shash;
```

MurmurHash3c.h:

```cpp
#include <stdint.h>

struct uint128_t {
    constexpr uint128_t() : h1(0), h2(0) {}
    constexpr uint128_t( uint64_t _h1, uint64_t _h2 ) : h1(_h1), h2(_h2) {}
    constexpr bool operator == (const uint128_t& rhs) { return h1 == rhs.h1 && h2 == rhs.h2; }
    constexpr bool operator != (const uint128_t& rhs) { return !(*this == rhs); }
    uint64_t h1;
    uint64_t h2;
};


class ConstString {
public:
    template constexpr ConstString( const char(&s)[N] ) : m_Str( s ), m_Size( N-1 ) {}
    constexpr ConstString( const char* s, size_t len ) : m_Str( s ), m_Size( len ) {}

    constexpr size_t size() { return m_Size; }

    constexpr uint8_t operator[] (size_t n)
    {
        return (uint8_t)m_Str[n];
    }

    constexpr uint8_t getU8(size_t n)
    {
        return (uint8_t)m_Str[n];
    }

    constexpr uint64_t getU64(size_t n)
    {
        return uint64_t( (uint8_t)m_Str[n*8 + 0]) << 0 | uint64_t( (uint8_t)m_Str[n*8 + 1]) << 8 |
            uint64_t( (uint8_t)m_Str[n*8 + 2]) << 16 | uint64_t( (uint8_t)m_Str[n*8 + 3]) << 24 |
            uint64_t( (uint8_t)m_Str[n*8 + 4]) << 32 | uint64_t( (uint8_t)m_Str[n*8 + 5]) << 40 |
            uint64_t( (uint8_t)m_Str[n*8 + 6]) << 48 | uint64_t( (uint8_t)m_Str[n*8 + 7]) << 56;
    }

    constexpr inline uint128_t hash128(uint64_t seed=0x1234567) const
    {
        return _calcfinal( size(), _calcrest( *this, (size()/16)*16, size() & 15, _calcblocks( *this, size() / 16, 0, uint128_t(seed, seed)) ) );
    }

    constexpr inline uint64_t hash(uint64_t seed=0x1234567) const
    {
        return hash128(seed).h1;
    }

private:
 // The code here is a bit messy, but is essentially a functional representation of the MurmurHash3_x64_128 implementation
 // rebuilt from the ground up.

 constexpr inline static uint64_t _c1() { return 0x87c37b91114253d5LLU; }
 constexpr inline static uint64_t _c2() { return 0x4cf5ad432745937fLLU; }

 constexpr inline static uint64_t rotl64c( uint64_t x, int8_t r )
 {
   return (x << r) | (x >> (64 - r));
 }

 constexpr inline static uint64_t _downshift_and_xor( uint64_t k )
 {
   return k ^ (k >> 33);
 }

 constexpr inline static uint64_t _calcblock_h( const uint128_t value, const uint64_t h1, const uint64_t h2 )
 {
   return (h2 + rotl64c(h1 ^ (_c2() * rotl64c(value.h1 * _c1(),31)), 27)) * 5 + 0x52dce729;
 }

 constexpr inline static uint128_t _calcblock( const uint128_t value, uint64_t h1, uint64_t h2 )
 {
   return uint128_t( _calcblock_h(value, h1, h2),
                     (_calcblock_h(value, h1, h2) + rotl64c(h2 ^ (_c1() * rotl64c(value.h2 * _c2(), 33)), 31)) * 5 + 0x38495ab5 );
 }

 constexpr inline static uint128_t _calcblocks( const ConstString cs, const int nblocks, const int index, const uint128_t accum)
 {
  return nblocks == 0 ? accum : index == nblocks-1 ? _calcblock( uint128_t(cs.getU64(index*2+0), cs.getU64(index*2+1)), accum.h1, accum.h2 ) :
                 _calcblocks( cs, nblocks, index+1, _calcblock( uint128_t(cs.getU64(index*2+0), cs.getU64(index*2+1)), accum.h1, accum.h2 ) );
 }

 constexpr static uint128_t _add( const uint128_t value )
 {
  return uint128_t( value.h1 + value.h2, value.h2 * 2 + value.h1 );
 }

 constexpr static uint64_t _fmix_64( uint64_t k )
 {
   return _downshift_and_xor( _downshift_and_xor( _downshift_and_xor( k ) * 0xff51afd7ed558ccdLLU ) * 0xc4ceb9fe1a85ec53LLU );
 }

 constexpr static uint128_t _fmix( const uint128_t value )
 {
  return uint128_t( _fmix_64(value.h1), _fmix_64(value.h2) );
 }

 constexpr static uint64_t _calcrest_xor(const ConstString cs, const int offset, const int index, const uint64_t k)
 {
   return k ^ (uint64_t( cs[offset + index] ) << (index * 8));
 }

 constexpr static uint64_t _calcrest_k(const ConstString cs, const size_t offset, const size_t index, const size_t len, const uint64_t k)
 {
   return index == (len-1) ? _calcrest_xor(cs, offset, index, k) : _calcrest_xor(cs, offset, index, _calcrest_k(cs, offset, index+1, len, k) );
 }

 constexpr static uint128_t _calcrest(const ConstString cs, const uint64_t offset, const size_t restlen, const uint128_t value)
 {
   return restlen == 0  ? value :
          restlen > 8   ? uint128_t( value.h1 ^ (rotl64c( _calcrest_k( cs, offset, 0, restlen > 8 ? 8 : restlen, 0 ) * _c1(), 31) * _c2()),
                                     value.h2 ^ (rotl64c( _calcrest_k( cs, offset+8, 0, restlen-8, 0 ) * _c2(), 33) * _c1()) )
                        : uint128_t(value.h1 ^ (rotl64c( _calcrest_k( cs, offset, 0, restlen > 8 ? 8 : restlen, 0 ) * _c1(), 31) * _c2()),
                                     value.h2);
 }

 constexpr static uint128_t _calcfinal(const size_t len, const uint128_t value)
 {
   return _add( _fmix( _add( uint128_t(value.h1 ^ len, value.h2 ^ len) ) ) );
 }

 const char* m_Str;
 size_t m_Size;
};


//-----------------------------------------------------------------------------


constexpr uint64_t MurmurHash3c_64(const ConstString& cs, uint64_t seed = 0x1234567)
{
 return cs.hash(seed);
}

constexpr uint64_t operator "" _hash(const char* str, size_t len)
{
 return ConstString(str, len).hash();
}

inline void MurmurHash3c_x64_128( const char* key, int len, const uint32_t seed, void* out )
{
 ((uint128_t*)out)[0] = ConstString( key, len ).hash128(seed);
}
```

