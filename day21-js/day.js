function swap_pos(idxX, idxY, str) {

        tmp = str[idxX]
        str[idxX] = str[idxY]
        str[idxY] = tmp
        return str

}

function swap_letter(x, y, str) {

        str = str.join("")

        str = str.replace(new RegExp(x, "g"), "-") // x -> "-" -> y
        str = str.replace(new RegExp(y, "g"), "+") // y -> "+" -> x
        str = str.replace(/-/g, y)
        str = str.replace(/\+/g, x)
        return str.split("")

}

function rotate_left(num, str) {

        str = str.slice()

        if (num == 0) {
                return str
        }

        last = str[str.length - 1]

        for (sourceIdx = 0; sourceIdx < (str.length - 1); sourceIdx++) {
                if (sourceIdx == 0) {
                        targetIdx = str.length - 1
                } else {
                        targetIdx = sourceIdx - 1
                }
                str[targetIdx] = str[sourceIdx]
        }

        str[str.length - 2] = last
        return rotate_left(num - 1, str)
}

function rotate_right(num, str) {

        str = str.slice()

        if (num == 0) {
                return str
        }

        first = str[0]

        for (sourceIdx = (str.length - 1); sourceIdx > 0; sourceIdx--) {
                if (sourceIdx == str.length - 1) {
                        targetIdx = 0
                } else {
                        targetIdx = sourceIdx + 1
                }
                str[targetIdx] = str[sourceIdx]
        }

        str[1] = first
        return rotate_right(num - 1, str)

}

function rotate_on_pos(letter, str) {

        index = str.join("").indexOf(letter)

        if (index >= 4) {
                return rotate_right(index + 2, str)
        }
        return rotate_right(index + 1, str)
}

function decrypt_rotate_on_pos(letter, str) {

        // We'll just bruite force here by rotating
        // the string the opposite direction than the encryption
        // until the encrypted version of our generated decryption
        // is equal to the input string here.ß

        enc = str
        dec = str
        while (true) {
                dec = rotate_left(1, dec).slice()
                test_enc = rotate_on_pos(letter, dec)
                if (enc.join("") == test_enc.join("")) {
                        return dec
                }
        }

}

function reverse_positions(idxX, idxY, str) {

        return str.slice(0, idxX).concat(str.slice(idxX, parseInt(idxY) + 1).reverse()).concat(str.slice(parseInt(idxY) + 1))
}

function move_pos(idxX, idxY, str) {

        if (idxX < idxY) {
                return str.slice(0, idxX).concat(str.slice(parseInt(idxX) + 1, parseInt(idxY) + 1)).concat([str[idxX]]).concat(str.slice(parseInt(idxY) + 1))
        }

        return str.slice(0, idxY).concat([str[idxX]]).concat(str.slice(idxY, idxX)).concat(str.slice(parseInt(idxX) + 1))

}

function encrypt(rules, password) {

        for (i = 0; i < rules.length; i++) {

                line = rules[i]

                if (line.startsWith("swap position")) {
                        indexes = line.match(/\d+/g)
                        console.log("swap pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = swap_pos(indexes[0], indexes[1], password)
                } else if (line.startsWith("swap letter")) {
                        firstletter = line.match(/\s\w\s/)[0].trim()
                        secondletter = line.match(/\s\w$/)[0].trim()
                        console.log("swap left " + firstletter + ", " + secondletter + " :: IN :: " + password)
                        password = swap_letter(firstletter, secondletter, password)
                } else if (line.startsWith("rotate left")) {
                        num = line.match(/\d+/)
                        console.log("rot left " + num + " :: IN :: " + password)
                        password = rotate_left(num, password)
                } else if (line.startsWith("rotate right")) {
                        num = line.match(/\d+/)
                        console.log("rot right " + num + " :: IN :: " + password)
                        password = rotate_right(num, password)
                } else if (line.startsWith("rotate based on position of letter")) {
                        letter = line.match(/\w$/)
                        console.log("rot pos " + letter + " :: IN :: " + password)
                        password = rotate_on_pos(letter, password)
                } else if (line.startsWith("reverse positions")) {
                        indexes = line.match(/\d+/g)
                        console.log("reverse pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = reverse_positions(indexes[0], indexes[1], password)
                } else if (line.startsWith("move position")) {
                        indexes = line.match(/\d+/g)
                        console.log("move pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = move_pos(indexes[0], indexes[1], password)
                } else {
                        console.log("PARSING ERROR for line \"" + line + "\". Abort.")
                        break
                }

                console.log("OUT :: " + password)

                if (password.length > 8) {
                        console.log(password)
                        break
                }

        }

        return password
}

function decrypt(rules, password) {

        rules = rules.reverse()

        for (i = 0; i < rules.length; i++) {

                line = rules[i]

                if (line.startsWith("swap position")) {
                        indexes = line.match(/\d+/g)
                        console.log("swap pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = swap_pos(indexes[0], indexes[1], password)
                } else if (line.startsWith("swap letter")) {
                        firstletter = line.match(/\s\w\s/)[0].trim()
                        secondletter = line.match(/\s\w$/)[0].trim()
                        console.log("swap left " + firstletter + ", " + secondletter + " :: IN :: " + password)
                        password = swap_letter(firstletter, secondletter, password)
                } else if (line.startsWith("rotate left")) {
                        num = line.match(/\d+/)
                        console.log("rot right " + num + " :: IN :: " + password)
                        password = rotate_right(num, password)
                } else if (line.startsWith("rotate right")) {
                        num = line.match(/\d+/)
                        console.log("rot left " + num + " :: IN :: " + password)
                        password = rotate_left(num, password)
                } else if (line.startsWith("rotate based on position of letter")) {
                        letter = line.match(/\w$/)
                        console.log("rot pos (l) " + letter + " :: IN :: " + password)
                        password = decrypt_rotate_on_pos(letter, password)
                } else if (line.startsWith("reverse positions")) {
                        indexes = line.match(/\d+/g)
                        console.log("reverse pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = reverse_positions(indexes[0], indexes[1], password)
                } else if (line.startsWith("move position")) {
                        indexes = line.match(/\d+/g)
                        console.log("move pos " + indexes[0] + ", " + indexes[1] + " :: IN :: " + password)
                        password = move_pos(indexes[1], indexes[0], password)
                } else {
                        console.log("PARSING ERROR for line \"" + line + "\". Abort.")
                        break
                }

                console.log("OUT :: " + password)

                if (password.length > 8) {
                        console.log(password)
                        break
                }

        }

        return password
}


var input = require('./input.js')
var rules = input.input.match(/(.+)/g)
var testrules = input.testinput.match(/(.+)/g)

testpassword = "abcde".split("")
password = "abcdefgh".split("")

testtodecrypt = "decab".split("")
todecrypt = "fbgdceah".split("")

console.log(encrypt(rules, password).join(""))
console.log("---------------------------------------")
console.log(decrypt(rules, todecrypt).join(""))
console.log("---------------------------------------")
