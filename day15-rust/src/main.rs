use std::collections::HashMap;

fn simulate(turn_number: u64, fist_numbers: &Vec<u64>) -> u64 {

    let mut last_numbers = HashMap::new();
    let mut init_turn: u64 = 1;

    for number in fist_numbers.iter() {
        last_numbers.insert(number.clone(), init_turn);
        init_turn += 1;
    }

    let mut next_number :u64 = 0;

    for turn in init_turn..turn_number {
        let last_turn = last_numbers.entry(next_number).or_insert(turn);
        next_number = turn - *last_turn;
        *last_turn = turn;
    }

    next_number
}

fn main() {

    let init_number = vec![1,20,8,12,0,14];
    
    let turn_number = 2020;

    let next_number = simulate(turn_number, &init_number);
    println!("last number for {} : {}", turn_number, next_number);

    let turn_number = 30000000;

    let next_number = simulate(turn_number, &init_number);
    println!("last number for {} : {}", turn_number, next_number);
}
