
#set-location


#functions

function   Fill-Board-With-Symbol{

param(
    [char[,]]$board,
    [char]$symbol,
    [int]$boardSize
)    

    for ($i=0; $i -lt $boardSize; $i++) {

        for ($j=0; $j -lt $boardSize; $j++) {

            $board[$i,$j] = $symbol
             
        }
    }
}


function Print-Board {

param(
    [char[,]]$board,
    [int]$dimension
)

    for ($i=0; $i -lt $dimension; $i++) {

        for ($j=0; $j -lt $dimension; $j++) {

            Write-Host -NoNewline $board[$i,$j] " ";
        }
        echo ""
    }
}


function Place-Mines {

param(
    [char[,]]$board,
    [int]$boardSize
)

    [int]$mineNum = Read-Host "Please, enter the amount of mines you want to place on the board"

    #while( ($mineNum -ge $boardSize * $boardSize) -or ($mineNum -le 0) ) {
        
       # $mineNum = Read-Host "Please, provide smaller number of mines (game is impossible with given mine number)"
    #}

    #mine placing
    while($true) {
        $x = Get-Random -Minimum 0 -Maximum $boardSize
        $y = Get-Random -Minimum 0 -Maximum $boardSize

        if ($board[$x,$y] -eq '0'){

            $board[$x,$y] = 'X'
            
            $mineNum--
        }

        if ($mineNum -eq 0) {
            break
        }
    }

}

#end of functions


# 'main'

#greetings
Write-Output "welcome in mini minier :)"
[int]$size = Read-Host "Please, enter the board size"

#two boards (hidden and visible for player) creation
$playerBoard = New-Object 'char[,]' $size,$size
$computerBoard = New-Object 'char[,]' $size,$size


Fill-Board-With-Symbol -board $playerBoard   -boardSize $size -symbol '*'
Fill-Board-With-Symbol -board $computerBoard -symbol '0' -boardSize $size

#Print-Board -board $playerBoard -dimension $size
#Print-Board -dimension $size -board $computerBoard

Place-Mines -board $computerBoard  -boardSize $size

Print-Board -dimension $size -board $computerBoard


#functions










