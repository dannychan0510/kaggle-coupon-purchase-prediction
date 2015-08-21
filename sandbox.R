library("Metrics")

submission <- list("a b c")
actual <- list("a b c")

apk(3, actual, submission)




sand1 <- c("a", "b")
sand2 <- list(c("c", "a"))

mapk(3, sand2, sand1)



a1 = c(1, 2, 3, 4, 5)
a2 = c(6, 7, 8, 9, 10)
a3 = c(11, 12, 13, 14, 15)
aframe = data.frame(a1, a2, a3)

test <- list(aframe$a3)

strsplit(submission[1,2], " ")

?map

sandbox1 <- strsplit(submission[,2], " ")

sandbox1
sandbox2 <- list("c5bd351e6a58515f2468004c70e41529", "b9980a7f1d03b76b83358b169962b17a")
mapk(10, sandbox2, sandbox1)


test

sandbox2 <- data.frame(c(1, 1, 2, 3), c("a", "b", "c", "d"))
names(sandbox2) <- c("id", "purchase")

aggregate(purchase ~ id, data=sandbox2, FUN=paste, collapse=' ')

# sandbox1 <- strsplit(submission[,2], " ")
# aggregate(purchase ~ id, data=sandbox2, FUN=paste, collapse=' ')


minipredictions <- predictions[1:2]
miniactuals <- list("f5314cb0bb7c6878dc91b8d25910bc4a", c("4c2eb43816fc5df5186ff90ad8b2decb", "b9980a7f1d03b76b83358b169962b17a"))

mapk(10, miniactuals, minipredictions)
