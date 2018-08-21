<#

WorldJournal.Files.psm1

    2018-08-15 Initial creation

#>

function Get-ChildItemPlus(){

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][Object[]]$Path
    )

    Begin{}
    Process{

        ForEach($p in $Path){

            Get-ChildItem $p | Sort-Object | ForEach-Object{

                if(Test-Path $_.FullName -PathType Container){

                    Write-Output (Get-Item $_.FullName)
                    Get-ChildItemPlus $_.FullName

                }else{

                    Write-Output (Get-Item $_.FullName)

                }
            }
        
        }
    
    }
    End{}
}



Function Move-Files() {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][Object[]]$File,
        [Parameter(Mandatory = $true)][string]$From,
        [Parameter(Mandatory = $true)][string]$To
    )

    Begin {}

    Process{

        ForEach($f in $File){

            $moveFrom   = $f.FullName
            $moveTo     = ($f.FullName).Replace($From, $To)
            $fromParent = (Split-Path ($moveFrom))
            $toParent   = (Split-Path ($moveTo))
            $obj        = New-Object -TypeName PSObject

            if(!(Test-Path $moveFrom -PathType Container)){

                if(!(Test-Path $toParent)){
                    New-Item $toParent -ItemType Directory | Out-Null
                }

                $obj | Add-Member -MemberType NoteProperty -Name FileType ¡Vvalue "File"
                $obj | Add-Member -MemberType NoteProperty -Name Verb ¡Vvalue "MOVE"
                $obj | Add-Member -MemberType NoteProperty -Name MoveFrom ¡Vvalue $moveFrom
                $obj | Add-Member -MemberType NoteProperty -Name MoveTo ¡Vvalue $moveTo
                $obj | Add-Member -MemberType NoteProperty -Name Noun ¡Vvalue $moveTo

                try{

                    Move-Item $moveFrom $moveTo -Force -ErrorAction Stop
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Good"
                
                }catch{
                
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Bad"
                    $obj | Add-Member -MemberType NoteProperty -Name Exception ¡Vvalue $_.Exception.Message
                }


            }else{

                $obj | Add-Member -MemberType NoteProperty -Name FileType ¡Vvalue "Directory"
                $obj | Add-Member -MemberType NoteProperty -Name Verb ¡Vvalue "REMOVE"
                $obj | Add-Member -MemberType NoteProperty -Name MoveFrom ¡Vvalue $moveFrom
                $obj | Add-Member -MemberType NoteProperty -Name MoveTo ¡Vvalue $moveTo
                $obj | Add-Member -MemberType NoteProperty -Name Noun ¡Vvalue $moveTo

                try{

                    Remove-Item -Path $moveFrom -Force -Recurse -ErrorAction Stop
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Good"
                
                }catch{

                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Bad"
                    $obj | Add-Member -MemberType NoteProperty -Name Exception ¡Vvalue $_.Exception.Message
                
                }

            }

            Write-Output $obj
        
        }
       
    }

    End{ }

}



Function Copy-Files() {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][Object[]]$File,
        [Parameter(Mandatory = $true)][string]$From,
        [Parameter(Mandatory = $true)][string]$To
    )

    Begin {}

    Process{

        ForEach($f in $File){

            $copyFrom   = $f.FullName
            $copyTo     = ($f.FullName).Replace($From, $To)
            $fromParent = (Split-Path ($copyFrom))
            $toParent   = (Split-Path ($copyTo))
            $obj        = New-Object -TypeName PSObject

            if(!(Test-Path $copyFrom -PathType Container)){

                #if(!(Test-Path $toParent)){
                #    New-Item $toParent -ItemType Directory | Out-Null
                #}

                $obj | Add-Member -MemberType NoteProperty -Name FileType ¡Vvalue "File"
                $obj | Add-Member -MemberType NoteProperty -Name Verb ¡Vvalue "COPY"
                $obj | Add-Member -MemberType NoteProperty -Name CopyFrom ¡Vvalue $copyFrom
                $obj | Add-Member -MemberType NoteProperty -Name CopyTo ¡Vvalue $copyTo
                $obj | Add-Member -MemberType NoteProperty -Name Noun ¡Vvalue $copyTo

                try{

                    Copy-Item $copyFrom $copyTo -Force -ErrorAction Stop
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Good"
                
                }catch{
                
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Bad"
                    $obj | Add-Member -MemberType NoteProperty -Name Exception ¡Vvalue $_.Exception.Message
                }


            }else{

                $obj | Add-Member -MemberType NoteProperty -Name FileType ¡Vvalue "Directory"
                $obj | Add-Member -MemberType NoteProperty -Name Verb ¡Vvalue "NEW"
                $obj | Add-Member -MemberType NoteProperty -Name CopyFrom ¡Vvalue $copyFrom
                $obj | Add-Member -MemberType NoteProperty -Name CopyTo ¡Vvalue $copyTo
                $obj | Add-Member -MemberType NoteProperty -Name Noun ¡Vvalue $copyTo

                try{

                    New-Item $copyTo -ItemType Directory | Out-Null
                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Good"
                
                }catch{

                    $obj | Add-Member -MemberType NoteProperty -Name Status ¡Vvalue "Bad"
                    $obj | Add-Member -MemberType NoteProperty -Name Exception ¡Vvalue $_.Exception.Message
                
                }

            }

            Write-Output $obj
        
        }
       
    }

    End{ }

}