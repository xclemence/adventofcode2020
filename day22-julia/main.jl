include("readfile.jl")
include("combat.jl")
include("recursivecombat.jl")

function playscore(player)
    score = 0
    iterator = 1
    for value = Iterators.reverse(player)
       score += value * iterator
       iterator += 1 
    end
    return score
end

(player1, player2) = deckplayers("data\\final")

cloneplayer1 = copy(player1)
cloneplayer2 = copy(player2)

combat!(cloneplayer1, cloneplayer2)
result = playscore(cloneplayer1) + playscore(cloneplayer2)
println("Result combat: $result")

winner = recursivecombat!(player1, player2, false)

println("recursive combat winner: $winner")

println("recursive combat player 1: $(playscore(player1))")
println("recursive combat player 2: $(playscore(player2))")
