function combat!(player1, player2)

    haswinner = false

    while !haswinner
        playturn!(player1, player2)
        haswinner = isempty(player1) || isempty(player2)
    end
end

function playturn!(player1, player2)
    value1 = popfirst!(player1)
    value2 = popfirst!(player2)

    value1 > value2 ? append!(player1, [value1, value2]) : append!(player2, [value2, value1])
end