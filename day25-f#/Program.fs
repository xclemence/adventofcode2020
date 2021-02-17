let rec tryLoopNumber (currentValue: int64) loopNumber endValue=
    match currentValue with
        | value when value = endValue -> loopNumber
        | _ -> tryLoopNumber ((currentValue * 7L) % 20201227L) (loopNumber + 1) endValue

let findLoopNumber = tryLoopNumber 1L 0

let rec generateEncryptionKey (baseValue: int64) key loop =
    match loop with
    | value when value = 0 -> baseValue
    | value -> generateEncryptionKey  ((baseValue * key) % 20201227L) key (value - 1) 


[<EntryPoint>]
let main argv =
    let cardPublicKey = 3248366L
    let doorPublicKey = 4738476L

    let cardLoopSize = findLoopNumber cardPublicKey
    let doorLoopSize = findLoopNumber doorPublicKey

    printfn "card loop %d " cardLoopSize
    printfn "door loop %d " doorLoopSize

    let encryptionKey = generateEncryptionKey 1L cardPublicKey doorLoopSize 

    printfn "encryption key %d " encryptionKey

    0 