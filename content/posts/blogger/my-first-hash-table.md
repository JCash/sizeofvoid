---
title: 'My first hash table'
date: 2016-03-27T11:34:00.000+02:00
draft: false
tags : [open addressing, chaining, C++, Hashtable, cache, Robin Hood]
authors: [mathias]
categories: [programming]
---

Recently I realized I needed a hash table where I had complete control of the memory ownership.
Previously, as a placeholder, I just used a regular std::unordered_map, but now I had come to a point where it just needed to be replaced. I wanted to be able to reload my engine, while keeping the data intact in memory ([Handmade Hero](https://handmadehero.org/) style).

Since I had never written one myself, I though this might be a fun exercise/challenge.
Even though the wheel is already invented, doesn't mean you can't have fun building a new one, learn something from it, or even try to improve on it. Right?

One common way to implement a hash table is to use "chaining", which means that you use a table to do the initial lookup, and then use a linked list to resolve hash collisions. Another way is to use "open addressing", where you use a "probing sequence" to find an empty slot, in case of hash collisions.

TL;DR: The code is available on [GitHub](https://github.com/JCash/containers)

[![](https://3.bp.blogspot.com/-B-gUdDHeMPM/Vwi8AWJAS6I/AAAAAAAACQc/wr0rozoUkhk8W1IGXMjuoLHT8Avig5vvw/s400/timings_get_random.png)](https://3.bp.blogspot.com/-B-gUdDHeMPM/Vwi8AWJAS6I/AAAAAAAACQc/wr0rozoUkhk8W1IGXMjuoLHT8Avig5vvw/s1600/timings_get_random.png)

An example of the benchmarks found at the GitHub repo

## Disclaimer

There's really nothing new going on here, I just try to have fun and learn.

I have to mention that the choices I made are ones that I think are relevant for _my_ use case. These criteria might be something you care about, or it might not be.

Also, I don't want to seem to bash other implementations when I do comparisons. I simply wanted to have other implementations to compare against so that I knew if I was completely off in my implementations.


## Requirements

I wanted my implementation to have:

*   Fixed memory (per instance)

*   I don't want any dynamic allocations in my game
*   The memory belongs to each instance, not per type

*   Good performance

*   A game usually does add/remove/get from the hash table

Good to have:

*   Small memory footprint
*   Small code size
*   Readable code

Other:

*   Need to support more than 64k entries (not millions)
*   No need to actually hash, the content pipeline does all preprocessing

## Where to start?

In order to get good performance, a good place to start is to think about these things:

*   Algorithm
*   Memory allocations
*   Cache coherency

Since I saw this as an exercise, I wanted to try both chaining and open addressing.
Also, I have no need to hash the keys, since my content pipeline does that for me.

As for memory, I already knew that I wanted to have a fixed memory size. I don't need my table to grow, so I can preallocate my memory upfront (start of a level). And if I ever hit a limit, I will simply increase the memory needed.

### Cache coherence

You also need to think about the [cache coherency](https://en.wikipedia.org/wiki/Cache_coherence). If you're not used to think about it, now is a good time to start. I am by _no means_ an expert on the subject, but it's easy to get to an acceptable level of understanding.

A silly analogy:
While your cup of coffee still has coffee in it, it's quick to get a sip. Otherwise, you have to get up, get into the kitchen and get some more from the pot, if there is more, otherwise you have to make more. And, if you're out of coffee altogether, you have to go to the store to get it.

I think the (silly) analogy fits well enough with cache coherency. You want as fast access as possible to the memory you need. The bigger the distance from the place in memory you are, to the place you want to be, will eventually incur [cache misses](https://en.wikipedia.org/wiki/CPU_cache). And yes, it does matter a lot for performance.

I'm not going to explain that further, you can easily find better info online :)


## Chaining

[gist source](https://gist.github.com/JCash/12ef294c59ad24797b1b) (note that I ended up not using this version)

The basic setup is to have one array of buckets, where each bucket is the start of a singly linked list to handle the key collisions.

In some implementations you might find dynamic allocations for each entry. Not only does that break my requirement of having no dynamic allocations, it also requires more memory than needed. Since I won't support more than 2^32 entries, having pointers on a 64 bit system, will waste memory.

So, instead I use a uint32_t to store indices between the arrays. And all the linked list entries are just allocated in one array, and they can cross reference via their m_Next index.

In addition to those two arrays, I added a m_FreeBits array, where I store what list entries in the m_Entries array are free or not. This was an optimization for my iterator, so I didn't have to check against the (larger) m_Buckets array.

### Analysis

Although I found the implementation really satisfactory, it beat all but one implementation I tested against at the time. When comparing the performance to the Google's [dense\_hash\_map](https://github.com/sparsehash/sparsehash), that one was quite good at removing elements. Their implementation uses open addressing. So that gave me the incentive to start implementing the next algorithm.



### Open Addressing + Robin Hood

[source](https://github.com/JCash/containers/blob/master/src/hashtable.h)

In open addressing, you store all the entries in the same array. When inserting, if you get a hash collision, you resolve it by searching (probing) the array for an empty slot.



Early on, I found out about [Robin Hood hashing](http://codecapsule.com/2013/11/11/robin-hood-hashing/), which is a way to handle hash collisions in open addressing. Basically, you move entries based on their distance from their initial bucket. This "sorting" is very localized in the array, and the sorting gives you quite a speedup.



In order to keep track of what entries are used or not, I use an "empty key", which the user sets (same as Google's dense\_hash\_map). This removes the need to use a separate "free bit" array, or "member variable". It's simple enough to initialize it to something unlikely (0xBAADC0D3) and also assert on inserting/removing the empty key.

Also, when erasing from the table, I use a scheme called "[backward shift deletion](http://codecapsule.com/2013/11/17/robin-hood-hashing-backward-shift-deletion/)", which is what it sounds like: moving the elements "back" with respect to their distance to their initial bucket. This allows for better performance when getting/inserting new entries. (See [this link](http://codecapsule.com/2013/11/17/robin-hood-hashing-backward-shift-deletion/))

#### Analysis:

With this approach, I managed to get much better results across the board. And the dense\_hash\_map is currently only slightly faster at erasing entries, while my implementation is much faster at inserting, and faster at getting entries. All in all a very good result.



The performance boost wasn't entirely unexpected, since the number of comparisons in an unsuccessful lookup, is less in the open addressing algorithm ([source](https://en.wikipedia.org/wiki/Hash_table#Performance_analysis)).

### Overall notes:

**std::unordered_map**

If you're only looking for something simple, you can use std::unordered\_map, it's almost as fast as boost::unordered\_map, and beats it on occasions. And it's faster than std::map


**boost**
The boost::flat_map's best trait is that it is able to iterate fast. But, I wouldn't recommend using it as a map for inserting/removing entries often, then it's magnitudes slower! And, the code size is just huge.
A better fit would be the boost::unordered_map, but still... that code size!



**eastl**

I only tried the hash\_map, since that one was easy to use. Its performance was better than boost::unordered\_map. The fixed_map requires you to use an node count specified in the class template arguments, so that one is a no go for me. The code package is also quite large if you only wish to have a single container.



**google**

The best choice to go with in my opinion, if you want speed and something main stream and battle tested. The performance is really great. It also uses open addressing. Code size is medium sized.



**jc::hashtable**

In the end, I got an implementation I'm very happy with. I chose the open addressing algorithm, with Robin Hood hashing. Great performance, and very small code size (~330 loc) which makes it quite readable imho. The memory footprint is basically as small as it gets, minus the load factor overhead.

### Conclusion:

It was very fun to implement your own hashtable, and it turned out to be a lot less cumbersome than I initially thought. And hopefully, someone got inspired to write their own container, or perhaps challenge which one they're using.

### Further reading:

[http://codecapsule.com/2013/11/11/robin-hood-hashing/](http://codecapsule.com/2013/11/11/robin-hood-hashing/)
[http://codecapsule.com/2013/11/17/robin-hood-hashing-backward-shift-deletion/](http://codecapsule.com/2013/11/17/robin-hood-hashing-backward-shift-deletion/)