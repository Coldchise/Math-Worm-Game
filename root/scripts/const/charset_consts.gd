class_name CharsetConsts
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const DIGITS: String = "0123456789"
const LOWERCASE: String = "abcdefghijklmnopqrstuvwxyz"
const UPPERCASE: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const LETTERS: String = LOWERCASE + UPPERCASE
const USERNAME: String = LETTERS + DIGITS
const SPECIAL: String = " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
const ASCII: String = USERNAME + SPECIAL
