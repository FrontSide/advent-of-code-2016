require 'digest'

INPUT='jlmsuwbz'
NEEDED_KEY_COUNT=64

def getFirstTripletCharacter(hash)
    for idx in 0..hash.length-3
        if hash[idx] == hash[idx+1] && hash[idx] == hash[idx+2]
            return hash[idx]
        end
    end
    return nil
end

def isKey(hash, nextkHashes)
    tripletCharacter = getFirstTripletCharacter(hash)
    if tripletCharacter == nil
        return false
    end
    for nextHash in nextkHashes
        if nextHash.include?(tripletCharacter * 5)
            puts "#{nextHash} includes #{tripletCharacter * 5}"
            return true
        end
    end
    return false
end

def getMd5Hash(original, iterations)
    if iterations == 0
        return original
    end

    md5 = Digest::MD5.new
    md5.update original
    return getMd5Hash(md5.hexdigest, iterations-1)
end

foundKeys=0
hashes = Array.new
iterationIdx=0
while foundKeys < NEEDED_KEY_COUNT
    digest = getMd5Hash("#{INPUT}#{iterationIdx}", 2017)
    hashes.push(digest)
    if (iterationIdx >= 1001 && isKey(hashes[iterationIdx-1000], hashes[iterationIdx-999..iterationIdx]))
        foundKeys += 1
        puts "#{iterationIdx-1000} #{hashes[iterationIdx-1000]}"
    end
    iterationIdx += 1
end
