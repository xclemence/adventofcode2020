function deckplayers(filename)

    lines = open(filename) do file
        readlines(file)
    end

    player1 = Int[]
    player2 = Int[]

    first_user = true

    for line = lines[2:end]
        if startswith(line, "Player")
            first_user = false
            continue
        end
        if line == ""
            continue
        end
        value = parse(Int, line)
        first_user ?  push!(player1, value) : push!(player2, value)
    end

    return (player1, player2)
end
