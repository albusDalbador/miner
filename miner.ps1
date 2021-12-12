
#set-location
Write-Output "welcome in mini minier :)"
[int]$size = Read-Host "Please, enter the board size"

$playerBoard = New-Object 'char[,]' $size,$size
$computerBoard = New-Object 'char[,]' $size,$size



Fill-Boad-With-Symbol($playerBoard,'*',$size)
#Fill-Boad-With-Symbol($computerBoard,'0',$size)

#Print-Board($playerBoard,$size)
#Print-Board($computerBoard,$size)



#functions

function Place-Mines([char[,]]$board,[int]$maxNum) {
    $mineNum = Read-Host "Please, enter the amount of mines you want to place on the board:"

    while( $mineNum -ge $maxNum) {
        $mineNum = Read-Host "Please, provide smaller number of mines (game is impossible with given mine number):"
    }

    #mine placing
    while($true) {
        $x = Get-Random -Minimum 0 -Maximum $size
        $y = Get-Random -Minimum 0 -Maximum $size

        if ($board[$x,$y] -eq '*'){

            #to do
            
        }
    }

}




function Print-Board([char[,]]$board,[int]$dimension) {

    for ($i=0; $i -lt $dimension; $i++) {

        for ($j=0; $j -lt $dimension; $j++) {

            Write-Host -NoNewline $board[$i,$j] " ";
        }
        echo ""
    }
}


function   Fill-Boad-With-Symbol([char[,]]$board, [char]$symbol,[int]$boardSize){
    #to do 

    for ($i=0; $i -lt $boardSize; $i++) {

        for ($j=0; $j -lt $boardSize; $j++) {

            $board[$i,$j] = $symbol
             
        }
    }
}

