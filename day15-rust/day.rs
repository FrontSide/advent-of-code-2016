struct Disc {
    num_pos: i32,
    pos: i32,
}

impl Disc {
    fn mv(&mut self) {
        self.pos = (self.pos + 1) % self.num_pos
    }
    fn to_string(&self) -> (String) {
        return format!("<D pos:{}>", self.pos)
    }
}

struct Capsule {
    pos: i8,
}

fn reset(start_time: i32) -> ([Disc; 7], Capsule) {
    (
        [
            Disc { num_pos: 11, pos: (0 + start_time) % 11 },
            Disc { num_pos: 5, pos: (0 + start_time) % 5 },
            Disc { num_pos: 7, pos: (2 + start_time) % 7 },
            Disc { num_pos: 13, pos: (2 + start_time) % 13 },
            Disc { num_pos: 19, pos: (4 + start_time) % 19 },
            Disc { num_pos: 3, pos: (2 + start_time) % 3 },
            Disc { num_pos: 17, pos: (15 + start_time) % 17 }
        ],
        Capsule { pos: 7 }
    )
}

fn run(start_time: i32) -> bool {

    let (mut discs, mut capsule) = reset(start_time);

    let mut idx = start_time;
    while capsule.pos > 0 {

        idx += 1;
        for disc in discs.iter_mut() {
            disc.mv();
        }
        capsule.pos -= 1;

        //println!("t{}:{}[{}{}{}{}{}{}]", idx, capsule.pos, discs[0].to_string(), discs[1].to_string(), discs[2].to_string(), discs[3].to_string(), discs[4].to_string(), discs[5].to_string());

        if discs[capsule.pos as usize].pos != 0  {
            //println!("Bounce! t:{}", idx);
            return false;
        }

    }

    return true;

}

fn main() {

    let mut start_time = 0;
    while !run(start_time) {
        start_time += 1;
    }

    println!("Done :: {}", start_time);

}
