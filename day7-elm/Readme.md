## How to run

Tested with elm 0.18 on a Mac Book.

Elm isn't very good with large amounts of data.
Which is why I needed to partition the input in 20 arrays of 100 strings each.
You can find those arrays in valid elm syntax in the input_asarrays.txt file.
Just copy the content of that file into day.elm.

And then uncomment the section in the `main =` function that corresponds
to the task you want to execute.

Then run `elm-reactor` and open your browser on `localhost:8000`.

**Attention:** Again, elm isn't for big data (or maybe I did something terribly wrong), so loading the page in your browser might take up to a few *minutes*. If you have a weak computer or browser it might even crash. When I ran it on my 16GB memory MacBook the little spinning wheel was being displayed for at least a minute before the result was shown. Try to remove all the debugging/logging from day.elm if you can't run it.

If you want to use your own input, you can use `toarrays.py` to convert all the lines to elm-syntax arrays.

## Instructions
### Day 7: Internet Protocol Version 7

While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).

An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.

For example:

    abba[mnop]qrst supports TLS (abba outside square brackets).
    abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
    aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
    ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).

How many IPs in your puzzle input support TLS?

Your puzzle answer was 118.

#### Part Two

You would also like to know which IPs support SSL (super-secret listening).

An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

For example:

    aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
    xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
    aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
    zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).

How many IPs in your puzzle input support SSL?

Your puzzle answer was 260.

Both parts of this puzzle are complete! They provide two gold stars: **
