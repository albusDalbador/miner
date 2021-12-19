
#set-location


#functions

function Is-Valid {
param(
    [Parameter(Mandatory=$true)]
    [int]$boardSize,

    [Parameter(Mandatory=$true)]
    [int]$x,

    [Parameter(Mandatory=$true)]
    [int]$y
)
    ( ($x -lt $boardSize) -and ($x -ge 0) ) -and ( ($y -lt $boardSize) -and ($y -ge 0) )  

}


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
    Write-Host -NoNewline " \Y "

    for ($i=0; $i -lt $dimension; $i++) {
        Write-Host -NoNewline "${i}  "
    }

    Write-Host ""

    Write-Host -NoNewline "X\ "

    for ($i=0; $i -lt $dimension; $i++) {
        Write-Host -NoNewline "___"
    }

    Write-Host ""
     

    for ($i=0; $i -lt $dimension; $i++) {
        
        Write-Host -NoNewline "${i} | "

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
    [int]$boardSize,

    [Parameter(Mandatory=$true)]
    [int]$mines
)

    while( ($mines -ge $boardSize * $boardSize) -or ($mines -le 0) ) {
        $mines = Read-Host "Please, provide smaller number of mines (game is impossible with given mine number) ${mines}"
    }
    

    #mine placing
    while($true) {
        $x = Get-Random -Minimum 0 -Maximum $boardSize
        $y = Get-Random -Minimum 0 -Maximum $boardSize

        if ($board[$x,$y] -eq '0'){

            $board[$x,$y] = 'X'
            
            $mines--
        }

        if ($mines -eq 0) {
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


function Count-Nearest-Mines {

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [int]$boardSize,

    [Parameter(Mandatory=$true)]
    [int]$xPoint,

    [Parameter(Mandatory=$true)]
    [int]$yPoint
)

    [int]$count =0;

    for ($i=$xPoint-1; $i -le $xPoint +1; $i++) {
        for ($j = $yPoint -1 ; $j -le $yPoint + 1; $j++) {
            
            if (Is-Valid -x $i -y $j -boardSize $boardSize) {
                if ($board[$i,$j] -eq 'X') {
                    $count++
                }
            }
        }
    }

    $count
}


function Place-Numbers-On-Board {

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$board,

    [Parameter(Mandatory=$true)]
    [int]$boardSize
)

    for ($i=0; $i -lt $boardSize; $i++) {
        for ($j = 0 ; $j -lt $boardSize; $j++) {
            if ($board[$i,$j] -ne 'X') {

                $board[$i,$j] = [string](Count-Nearest-Mines -board $board -boardSize $boardSize -xPoint $i -yPoint $j)
            }
        }
    }
}


function Disclose-Free-Neighbours {

param(
    [Parameter(Mandatory=$true)]
    [char[,]]$playerBoard,

    [Parameter(Mandatory=$true)]
    [char[,]]$computerBoard,

    [Parameter(Mandatory=$true)]
    [int]$boardSize,

    [Parameter(Mandatory=$true)]
    [int]$xPoint,

    [Parameter(Mandatory=$true)]
    [int]$yPoint,

    [Parameter(Mandatory=$true)]
    [ref]$closedFields
)

    #write-host $closedFields.Value
    $closedFields.Value --
    Update-Board -board $playerBoard -symbol $computerBoard[$xPoint,$yPoint] -xPoint $xPoint -yPoint $yPoint

    if ($computerBoard[$xPoint,$yPoint] -eq '0') {
     
        if (Is-Valid -boardSize $boardSize -x ($xPoint - 1) -y $yPoint) {
            if ($playerBoard[($xPoint -1),$yPoint] -ne $computerBoard[($xPoint -1),$yPoint]) {
                Disclose-Free-Neighbours -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $boardSize -xPoint ($xPoint -1) -yPoint $yPoint -closedFields $closedFields
            }                                                                                                                                               
        }                                                                                                                                                   
                                                                                                                                                            
        if (Is-Valid -boardSize $boardSize -x ($xPoint + 1) -y $yPoint) {                                                                                   
            if ($playerBoard[($xPoint +1),$yPoint] -ne $computerBoard[($xPoint +1),$yPoint]) {                                                              
                Disclose-Free-Neighbours -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $boardSize -xPoint ($xPoint +1) -yPoint $yPoint  -closedFields $closedFields
            }
        }

        if (Is-Valid -boardSize $boardSize -x $xPoint -y ($yPoint - 1)) {
            if ($playerBoard[$xPoint,($yPoint - 1)] -ne $computerBoard[$xPoint,($yPoint - 1)]) {
                Disclose-Free-Neighbours -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $boardSize -xPoint $xPoint -yPoint ($yPoint - 1) -closedFields $closedFields
            }
        }

        if (Is-Valid -boardSize $boardSize -x $xPoint -y ($yPoint + 1)) {
            if ($playerBoard[$xPoint,($yPoint + 1)] -ne $computerBoard[$xPoint,($yPoint + 1)]) {
                Disclose-Free-Neighbours -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $boardSize -xPoint $xPoint -yPoint ($yPoint + 1) -closedFields $closedFields
            }
        }

    }

}


function End-Game-Write-Result {
    #[CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true
        )]
        [string]$response,

        [Parameter(Mandatory=$true)]
        [string]$gameResult,

        [Parameter(Mandatory=$true)]
        [string]$minesOnBoard,

        [Parameter(Mandatory=$true)]
        [string]$boardSize,

        [Parameter(Mandatory=$false)]
        [int]$fieldsLeft
    )

    DynamicParam{

        if ($response -eq "y") {

            $fileNameAttribute = New-Object `
            System.Management.Automation.ParameterAttribute

            $fileNameAttribute.Position = 2
            $fileNameAttribute.Mandatory = $true
            $fileNameAttribute.HelpMessage = "Enter filename, you want to save result in"

            $attributeCollection = New-Object `
            System.Collections.ObjectModel.Collection[system.attribute]
            $attributeCollection.Add($fileNameAttribute)

            $fileNameParam = New-Object `
            System.Management.Automation.RuntimeDefinedParameter('filename',[string],$attributeCollection)

            #$PSBoundParameters.filename = "filename.txt"

            $paramDictionary = New-Object `
            System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('filename',$fileNameParam);

            return $paramDictionary
        }   

        if ($response -ceq "n") {
            write-host "good luck"
        }

        
    }
 

    process {

        $date = (Get-Date).Year.ToString() + "." `
        + (Get-Date).Month.ToString() + "."`
        + (Get-Date).Day.ToString() + "__"`
        + (Get-Date).Hour.ToString() + "."`
        + (Get-Date).Minute.ToString()

        #Write-Host $date

         if (Test-Path -Path $PSBoundParameters.filename) {
            Write-Host "given file exist, result will added to file content"

            if ($gameResult -eq "LOST") {
                echo "$date  game result: $gameResult fields remained: $fieldsLeft  board size: $boardSize  total mines: $minesOnBoard"`
                 | Out-File $PSBoundParameters.filename -Append
            } else {
                echo "$date  $gameResult  board size: $boardSize  total mines: $minesOnBoard"`
                 | Out-File $PSBoundParameters.filename -Append
            }
         
         } else {
            Write-Host "Creating file" $PSBoundParameters.filename "..."

            if ($gameResult -eq "LOST") {
                echo "$date  game result: $gameResult fields remained: $fieldsLeft board size: $boardSize  total mines: $minesOnBoard"`
                 | Out-File $PSBoundParameters.filename -Append
            } else {
                echo "$date  $gameResult  board size: $boardSize  total mines: $minesOnBoard"`
                 | Out-File $PSBoundParameters.filename -Append
            }
         }

         if ($?) {
            Write-Host "Result successfuly writted to file " $PSBoundParameters.filename
         } else {
            Write-Host "Something went wrong"
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
    [int]$boardSize,

    [Parameter(Mandatory=$true)]
    [int]$numberOfMines
)

    Write-Host "game started..."

    [int]$closedFields = ($boardSize * $boardSize)

    while ($true) {

        clear


        Write-Host -NoNewline "Closed fields left: "
        Write-Host ($closedFields - $numberOfMines)

        Print-Board -board $playerBoard -dimension $boardSize
        write-host $closedFields

        if ($closedFields -eq $numberOfMines) {
            Write-Host "Congratulations, you won!"

            $prompt = Read-Host "Do you want to save your result? [y][n]"
            End-Game-Write-Result -response $prompt -gameResult "WON" -minesOnBoard $numberOfMines -boardSize $boardSize

            break
        }
        

        do {
            [int]$x = Read-Host "Enter x greater than 0 and less than ${boardSize}"
        }
        while( ($x -ge $boardSize) -or ($x -lt 0) ) 

        do {
            [int]$y = Read-Host "Enter y greater than 0 and less than ${boardSize}"
        }
        while( ($y -ge $boardSize) -or ($y -lt 0) )  


        #chosen field checking
        if ($computerBoard[$x,$y] -ne 'X') {

            Disclose-Free-Neighbours -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $boardSize -xPoint $x -yPoint $y -closedFields ([ref]$closedFields)

        } else {

            clear

            Write-Host "GAME OVER :("

            Disclose-All-Mines -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $size

            Print-Board -board $playerBoard -dimension $size 

            $prompt = Read-Host "Do you want to save your result? [y][n]"
            End-Game-Write-Result -response $prompt -gameResult "LOST" -fieldsLeft ($closedFields - $numberOfMines) -minesOnBoard $numberOfMines -boardSize $boardSize

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
#
#
Fill-Board-With-Symbol -board $playerBoard   -boardSize $size -symbol '*'
Fill-Board-With-Symbol -board $computerBoard -symbol '0' -boardSize $size
#
[int]$numberOfMines = Read-Host "Please, enter the amount of mines you want to place on the board"
#
Place-Mines -board $computerBoard  -boardSize $size -mines $numberOfMines
#
Place-Numbers-On-Board -board $computerBoard -boardSize $size
#
##Print-Board -dimension $size -board $computerBoard
#
Start-Game -playerBoard $playerBoard -computerBoard $computerBoard -boardSize $size -numberOfMines $numberOfMines



#end of 'main'










