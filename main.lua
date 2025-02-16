-- Initialize the Tic-Tac-Toe board
board = {
    {"*", "*", "*"}, 
    {"*", "*", "*"},
    {"*", "*", "*"}
}

-- Function to print the current state of the board
function printBoard()
    for i = 1, 3 do
        for j = 1, 3 do
            io.write(board[i][j] .. " ")
        end
        print()
    end
end

-- Function to start the game
function startGame()
    print("Welcome to Tic-Tac-Toe!")
    print("The board spaces look like this\n{1, 2, 3 }\n{4, 5, 6 }\n{7, 8, 9 }")

    wantsToPlay = true
    while wantsToPlay do
        -- Reset the board
        board = {
            {"*", "*", "*"}, 
            {"*", "*", "*"},
            {"*", "*", "*"}
        }
        
        local player = math.random(1, 2) -- Randomly choose the starting player
        print("Player " .. player .. "'s turn")
        playGame(player)
        
        print("Do you want to play again? (yes/no)")
        local answer = io.read()
        if answer ~= "yes" then
            wantsToPlay = false
        end
    end
end

-- Function to play the game
function playGame(player)
    local gameFinished = false
    while not gameFinished do
        -- Check if the game is done
        local result = checkGameFinished()
        
        if result then
            print("Game Over! Winner: " .. result)
            gameFinished = true
            break
        end

        if player == 1 then
            -- Player's move
            print("Enter the position (1-9): ")
            local position = tonumber(io.read())
            local row = math.ceil(position / 3)
            local col = (position - 1) % 3 + 1

            if board[row][col] == "*" then
                board[row][col] = "X"
                printBoard() -- Print the board after the player's move
                player = 2 -- Switch to computer's turn
            else
                print("Position already taken. Try again.")
            end
        else
            -- Computer's move
            local bestScore = -math.huge
            local bestMove = nil

            for i = 1, 3 do
                for j = 1, 3 do
                    if board[i][j] == "*" then
                        board[i][j] = "O"
                        local score = minimax(board, 0, false)
                        board[i][j] = "*"
                        if score > bestScore then
                            bestScore = score
                            bestMove = {i, j}
                        end
                    end
                end
            end

            if bestMove then
                board[bestMove[1]][bestMove[2]] = "O"
                printBoard() -- Print the board after the computer's move
                player = 1 -- Switch to player's turn
            end
        end
    end
end

-- Minimax algorithm to determine the best move for the computer
function minimax(board, depth, isMaximizing)
    local result = checkGameFinished()
    if result then
        if result == "X" then
            return -1
        elseif result == "O" then
            return 1
        else
            return 0
        end
    end

    if isMaximizing then
        local bestScore = -math.huge
        for i = 1, 3 do
            for j = 1, 3 do
                if board[i][j] == "*" then
                    board[i][j] = "O"
                    local score = minimax(board, depth + 1, false)
                    board[i][j] = "*"
                    bestScore = math.max(score, bestScore)
                end
            end
        end
        return bestScore
    else
        local bestScore = math.huge
        for i = 1, 3 do
            for j = 1, 3 do
                if board[i][j] == "*" then
                    board[i][j] = "X"
                    local score = minimax(board, depth + 1, true)
                    board[i][j] = "*"
                    bestScore = math.min(score, bestScore)
                end
            end
        end
        return bestScore
    end
end

-- Function to check if the game is finished
function checkGameFinished()
    -- Check rows
    for i = 1, 3 do
        if board[i][1] == board[i][2] and board[i][2] == board[i][3] and board[i][1] ~= "*" then
            return board[i][1]
        end
        if board[1][i] == board[2][i] and board[2][i] == board[3][i] and board[1][i] ~= "*" then
            return board[1][i]
        end
    end
    -- Check diagonals
    if board[1][1] == board[2][2] and board[2][2] == board[3][3] and board[1][1] ~= "*" then
        return board[1][1]
    end
    if board[1][3] == board[2][2] and board[2][2] == board[3][1] and board[1][3] ~= "*" then
        return board[1][3]
    end
    -- Check for draw
    local isDraw = true
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == "*" then
                isDraw = false
                break
            end
        end
    end
    if isDraw then
        return "Draw"
    end
    return false
end

-- Start the game
startGame()