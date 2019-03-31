---
title: 'My first hashtable, part 2'
date: 2016-06-07T00:36:00.000+02:00
draft: false
tags : [open addressing, C++, Cache friendly, Fixed memory, Hashtable, Robin Hood]
authors: [mathias]
categories: [programming]
---

Since the implementation of my first version of my hash table, I've discovered some caveats:

* Key Size - The implementation was really good for small keys (e.g. uint64_t), but much worse for larger ones.

* Api - The "empty key" api didn't really sit well with me. Even though it was only exposed to the user in the class declaration.

So, I began reiterating my implementations, testing and benchmarking (which is a lot of fun), and after a while I came up with a result I'm quite satisfied with. Not only is the API nicer, but the performance is better; much more uniform, and in most cases faster than my previous implementation! And at ~270 lines of code, I think it's a pretty good alternative to the more common implementations out there :)

Code: [https://github.com/JCash/containers](https://github.com/JCash/containers)

Here are some samples from the benchmarks:

[![](https://4.bp.blogspot.com/-FtZsuHBJ6Nc/V1WdUdOlIfI/AAAAAAAACcg/BpflvlpSOMw5QcvlZoAEhrU3iS4SYmlkQCLcB/s320/timings_insert_random_sizeof%2528value%2529%253D%253D8.png)](https://4.bp.blogspot.com/-FtZsuHBJ6Nc/V1WdUdOlIfI/AAAAAAAACcg/BpflvlpSOMw5QcvlZoAEhrU3iS4SYmlkQCLcB/s1600/timings_insert_random_sizeof%2528value%2529%253D%253D8.png)

[![](https://1.bp.blogspot.com/-rpk7wG_LvoU/V1WdTxtMn_I/AAAAAAAACcQ/LfGKIs5vlnMFU5s6qj64ogA4wMtc_fBagCLcB/s320/timings_insert_random_sizeof%2528value%2529%253D%253D152.png)](https://1.bp.blogspot.com/-rpk7wG_LvoU/V1WdTxtMn_I/AAAAAAAACcQ/LfGKIs5vlnMFU5s6qj64ogA4wMtc_fBagCLcB/s1600/timings_insert_random_sizeof%2528value%2529%253D%253D152.png)

[![](https://3.bp.blogspot.com/-MyizgDTMVGg/V1WdUaXZQLI/AAAAAAAACck/8QmquFpyxnsqsYkfiQpAjmM9pUNV2ClLQCLcB/s320/timings_get_random_sizeof%2528value%2529%253D%253D8.png)](https://3.bp.blogspot.com/-MyizgDTMVGg/V1WdUaXZQLI/AAAAAAAACck/8QmquFpyxnsqsYkfiQpAjmM9pUNV2ClLQCLcB/s1600/timings_get_random_sizeof%2528value%2529%253D%253D8.png)

[![](https://1.bp.blogspot.com/-KIVSk1DEvtg/V1WdUAH33kI/AAAAAAAACcY/T7mBoBfy4Co3WXCa8NP-p98G90yUjK8MwCLcB/s320/timings_get_random_sizeof%2528value%2529%253D%253D152.png)](https://1.bp.blogspot.com/-KIVSk1DEvtg/V1WdUAH33kI/AAAAAAAACcY/T7mBoBfy4Co3WXCa8NP-p98G90yUjK8MwCLcB/s1600/timings_get_random_sizeof%2528value%2529%253D%253D152.png)

## Key Size

The obvious caveat to the implementation was that the Key was bundled together with the Value, in the same Entry-struct. So during Put/Erase, the values got shifted many times, doing many value copies. Ideally, you should only need to do one value copy, and you want to touch as few bytes as possible.

After a suggestion by my colleague [@NiklasWestberg](https://twitter.com/NiklasWestberg), I looked into separating the entry data from the value data. It was straight forward, creating two arrays (Entries, Values) where the Entry struct holds the key and an index into the Values array:

```cpp
struct Entry {
    KEY         m_Key;      // Key is also the hash
    uint32_t    m_Index;    // Index into the values array
};

struct Value {
    VALUE       m_Value;
    uint32_t    m_Next;     // Index into the values array
};
```

Since you now only need to write the value once, you get performance back due to the decrease in cache misses.
And when shifting entries during Put/Erase, you get performance back due to the increase in cache hits.
The drawback is that for smaller entries (~4-8 bytes), you get the extra overhead of having the data split into two arrays (cache misses)


## API

My beef with the previous api was that you had to specify an "Empty Key" function, which, upon creation, would assign an "Empty Value" to the hash table. This was used to mark elements as empty. It was a simple optimization by reusing the value field as a flag, as opposed to introducing a new field in the Entry struct.



In the new implementation, the Values array is touched a lot less often, and it's in fact implemented as a linked list. This removes the need for an "empty key", since we simply keep track of them in a separate list.

Also, another separate, smaller issue was that previously, the pointer returned from the Get() function, was volatile, and was potentially only valid until the next Put()/Erase(). The new implementation doesn't move the values as such, and the pointer is valid until you erase that key.



## The Create function

When timing the benchmarks, I noticed that the create function took some surprising amount of time.

It turned out to be the setup of the linked list (Values). Although it was a simple for-loop, it was expensive enough to warrant optimization.



What I did was to use a trick from the current Defold hash table. Instead of initializing the values array, I delay that until the values are freed up (one by one). So, during the first N inserts, we pick new value nodes off the array. And during erase, we simply store them back to the free list. Here's a snippet from the Put function:


```cpp
uint32_t valueindex;
if(m_InitialFreeList < m_Capacity) {
    valueindex = m_InitialFreeList++;
} else {
    valueindex = m_FreeList;
    m_FreeList = m_Values[valueindex].m_Next;
}
m_Values[valueindex].m_Value = value;
```



## Conclusion

Again, it's interesting to see the behavior of your (ond others) code. It helps you understand more of the choices you make when implementing things.

For instance, I have to say that I was a bit surprised to see the huge performance drop in the google::dense_hash_map, when they value sizes increases.