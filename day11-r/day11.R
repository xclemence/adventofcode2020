
library(purrr)
library(rlang)

get_neighbour <- function(items, x, y) {
    start_x <- x - 1;
    if (start_x == 0) {
        start_x = 1
    }

    end_x <- x + 1;
    if (end_x > length(items[[y]])) {
        end_x = length(items[[y]])
    }

    start_y <- y - 1;
    if (start_y == 0) {
        start_y = 1
    }

    end_y <- y + 1;
    if (end_y > length(items)) {
        end_y = length(items)
    }
    neighbour <- 0
    for (i in start_x:end_x) {
        for (j in start_y:end_y) {
            if ((i != x || j != y) && items[[j]][[i]] == "#") {
                neighbour <- neighbour + 1
            }
        }
    }
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
            } else if(seat == '#' &&  neighbour >= 4) {
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
