fn invert_bin(bin: String) -> String {
    let mut inverted_bin: String = String::from("");
    for digit in bin.chars() {
        // The + 48 is for converting the int into an ascii code that represents this interger
        inverted_bin.push(((digit as u8 + 1) % 2 + 48) as char);
    }
    //println!("{}R{}", bin, inverted_bin);
    inverted_bin
}

fn build_random_code(startcode: String, needed_length: usize) -> String {

    //println!("{}>{}", startcode, startcode.chars().rev().collect::<String>());

    if startcode.len() >= needed_length {
        // Get the first "needed_length" !bytes! of startcode.
        // non ascii characters would break this
        return String::from(&startcode[0..needed_length])
    }

    return build_random_code(format!("{}{}{}", startcode, '0', invert_bin(startcode.chars().rev().collect::<String>())), needed_length);

}

fn get_checksum(code: String) -> String {

    if code.len() % 2 == 1 {
        return code;
    }

    let mut checksum = String::from("");
    let mut code_chars = code.chars();

    for idx in 0..code.len()-1 {
        if idx % 2 == 1 {
            continue;
        }
        if code_chars.next().unwrap() == code_chars.next().unwrap() {
            checksum.push('1');
        } else {
            checksum.push('0');
        }
    }

    get_checksum(checksum)

}

fn main() {

    let startcode_ = String::from("01000100010010111");
    let random_code = build_random_code(startcode_, 35651584);

    println!("Done :: {}", random_code);

    let checksum = get_checksum(random_code);

    println!("Checksum :: {}", checksum);


}
