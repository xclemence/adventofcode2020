
function recursivecombat!(player1, player2, display = false)

    haswinner = isempty(player1) || isempty(player2)

    round  = 1
    
    knowdecks = []

    while !haswinner
        if display
            println("Round $round ($(length(player1)) vs $(length(player2)) - cache $(length(knowdecks)))")
            round += 1
        end

        deck = (copy(player1), copy(player2))

        if deck in knowdecks
            return 1
        else
            push!(knowdecks, deck)
        end

        turn!(player1, player2)
        haswinner = isempty(player1) || isempty(player2)
    end

    return isempty(player1) ? 2 : 1
end

function turn!(player1, player2)
    value1 = popfirst!(player1)
    value2 = popfirst!(player2)

    isplayer1win = false

    if value1 > length(player1) || value2 > length(player2)
        isplayer1win = value1 > value2
    else
        subplayer1 = player1[1:value1]
        subplayer2 = player2[1:value2]

        isplayer1win = recursivecombat!(subplayer1, subplayer2) == 1
    end

    isplayer1win ? append!(player1, [value1, value2]) : append!(player2, [value2, value1])
end