
library(purrr)
library(rlang)

next_seat_occupied <- function(items, x, y, increment_x, increment_y) {
    max_x <- length(items[[y]])
    max_y <- length(items)

    current_x <- x
    current_y <- y

    repeat { 
        current_x <- current_x + increment_x
        current_y <- current_y + increment_y

        if(current_x == 0 || current_x > max_x)
            return(FALSE)

        if(current_y == 0 || current_y > max_y)
            return(FALSE)
        value <- items[[current_y]][[current_x]]

        if(value != '.')
            return(value == '#')
    }
}

get_neighbour <- function(items, x, y) {
    neighbour <- 0

    neighbour <- neighbour + if(next_seat_occupied(items, x, y, -1, -1)) 1 else 0
    neighbour <- neighbour + if(next_seat_occupied(items, x, y, -1, 0)) 1 else 0
    neighbour <- neighbour + if(next_seat_occupied(items, x, y, -1, 1)) 1 else 0

    neighbour <- neighbour + if(next_seat_occupied(items, x, y, 0, -1)) 1 else 0
    neighbour <- neighbour + if(next_seat_occupied(items, x, y, 0, 1)) 1 else 0

    neighbour <- neighbour + if(next_seat_occupied(items, x, y, 1, -1)) 1 else 0
    neighbour <- neighbour + if(next_seat_occupied(items, x, y, 1, 0)) 1 else 0
    neighbour <- neighbour + if(next_seat_occupied(items, x, y, 1, 1)) 1 else 0
   
    neighbour
}

simulate <- function(items) {
    new_value <- duplicate(items)
    for (j in 1:length(new_value)) {
        for (i in 1:length(new_value[[j]])) {
            seat <- new_value[[j]][[i]]

            neighbour <- get_neighbour(items, i, j)

            if (seat == 'L' &&  neighbour == 0) {
                new_value[[j]][[i]] <- "#"
            } else if(seat == '#' &&  neighbour >= 5) {
                new_value[[j]][[i]] <- "L"
            }
        }
    }

    new_value
}

lines <- strsplit(readLines("data.txt"), "\r\n")
values <- lines %>% map(function(item) unlist(strsplit(item, "")))

index <- 1;
repeat { 
    new_values <- simulate(values) 
    if(identical(new_values, values)) {
       break
    }
    values <- new_values
   
    sprintf("iteration : %d\n", index) %>% cat()
    index <- index + 1;
}

values %>% unlist() %>% keep(function(x) x == "#") %>% length()
