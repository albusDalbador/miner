
#set-location


#functions

function Fill-Board-With-Symbol{

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [char]$symbol,

    [Parameter(Mandatory=$true)]
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
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [int]$dimension
)
    Write-Host -NoNewline "   "

    for ($i=0; $i -lt $dimension; $i++) {
        Write-Host -NoNewline "${i}  "
    }

    Write-Host ""

    Write-Host -NoNewline "  "

    for ($i=0; $i -lt $dimension; $i++) {
        Write-Host -NoNewline "___"
    }

    Write-Host ""
     

    for ($i=0; $i -lt $dimension; $i++) {
        
        Write-Host -NoNewline "${i}| "

        for ($j=0; $j -lt $dimension; $j++) {

            Write-Host -NoNewline $board[$i,$j] " ";
        }
        echo ""
    }
}


function Place-Mines {

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [int]$boardSize
)

    [int]$mineNum = Read-Host "Please, enter the amount of mines you want to place on the board"

    while( ($mineNum -ge $boardSize * $boardSize) -or ($mineNum -le 0) ) {
        $mineNum = Read-Host "Please, provide smaller number of mines (game is impossible with given mine number)"
    }

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


function Update-Board {
    
param(
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [char]$symbol,

    [Parameter(Mandatory=$true)]
    [int]$xPoint,

    [Parameter(Mandatory=$true)]
    [int]$yPoint
)

    $board[$xPoint,$yPoint] = $symbol

}


function Disclose-All-Mines {
param(
    [Parameter(Mandatory=$true)]
    [char[,]]$playerBoard,

    [Parameter(Mandatory=$true)]
    [char[,]]$computerBoard,

    [Parameter(Mandatory=$true)]
    [int]$boardSize
)

    for ($i = 0 ; $i -lt $boardSize; $i++) {
        for ($j = 0; $j -lt $boardSize; $j++) {

            if ($computerBoard[$i,$j] -eq 'X') {
                Update-Board -board $playerBoard -symbol 'X' -xPoint $i -yPoint $j        
            }
        
        }
    }
}


function Start-Game {

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$playerBoard,

    [Parameter(Mandatory=$true)]
    [char[,]]$computerBoard,

    [Parameter(Mandatory=$true)]
    [int]$boardSize
)

    Write-Host "game started..."

    while ($true) {

        Print-Board -board $playerBoard -dimension $boardSize

        do {
            [int]$x = Read-Host "Enter x greater than 0 and less than ${boardSize}"
        }
        while( ($x -ge $boardSize) -or ($x -lt 0) ) 

        do {
            [int]$y = Read-Host "Enter y greater than 0 and less than ${boardSize}"
        }
        while( ($y -ge $boardSize) -or ($y -lt 0) )  

        if ($computerBoard[$x,$y] -ne 'X') {
            Update-Board -board $playerBoard -symbol $computerBoard[$x,$y] -xPoint $x -yPoint $y
        } else {
            Write-Host "game over :("

            Disclose-All-Mines -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $size

            Print-Board -board $playerBoard -dimension $size 

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

Place-Mines -board $computerBoard  -boardSize $size


#Print-Board -dimension $size -board $playerBoard


Start-Game -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $size


#end of 'main'










