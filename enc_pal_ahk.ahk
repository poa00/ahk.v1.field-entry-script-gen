Gui, Add, Text, W100 H20 +0x200,Selected CSV File
Gui, Add, Edit, x+10 W500 H20 vFilePath
Gui, Add, Button, x+10 W120 H20, Select File
Gui, Add, Text, W100 H20 +0x200 xs, Fields:
Gui, Add, ListBox, W740 H200 vFields
Gui, Add, Text, W100 H20 +0x200,Output File
Gui, Add, Edit, x+10 W500 H20 vOutputPath
Gui, Add, Button, x+10 W120 H20, Select Output Folder
Gui, Add, Text, W100 H20 +0x200 xs,Key Combo to use
Gui, Add, Hotkey, vKey W100 H20 x+10
Gui, Add, Button, W740 H40 xs, Generate File

Gui, Show, W760 H360, Persona Access to Loan AHK generator
return

ButtonSelectFile:
    FileSelectFile, csvFile , ,%MasD%, Select Field CSV, CSV (*.csv)
    If csvFile = 
        Return
    GuiControl, , FilePath, %csvFile%
    Loop, read, %csvFile%
    {
        LineNumber = %A_Index%
        Loop, parse, A_LoopReadLine, CSV, `,
        {
            GuiControl,,Fields,%A_LoopField%
        }
    }
    return

ButtonSelectOutputFolder:
    FileSelectFile, outputAHK, ,%MasD%,Select/Create Ouput File, AHK (*ahk)
    If outputAHK =
        Return
    If FileExist(outputAHK)
    {
        GuiControl, ,OutputPath,%outputAHK%
    }
    Else
    {
        GuiControl, ,OutputPath,%outputAHK%.ahk
    }
    return

ButtonGenerateFile:

    ControlGet listItems, List, , ListBox1
    ControlGetText, outPath, Edit2
    GuiControlGet, Key

    If Not(listItems) OR Not(outPath) OR Not(Key)
    {
        Msgbox, ,Generation Problem,Please complete everything before generating
        return
    }
    Else
    {
        FileAppend, %Key%::`n, %outPath%

        Loop, Parse, listItems, `n
        {
            if (A_Index = 1)
            {
                FileAppend, `tSend`, %A_LoopField%{tab}`n, %outPath%

            }

            else if !Mod(A_Index, 10)
            {
                FileAppend, `tSend`, %A_LoopField%{tab}{tab}{space}`n, %outPath%
            }
                
            else if !Mod(A_Index-1, 10)
            {
                FileAppend, `tSend`, {tab}%A_LoopField%{tab}`n, %outPath%
            }
            
            else
            {
                FileAppend, `tSend`, %A_LoopField%{tab}`n, %outPath%
            }
        }

        FileAppend, `treturn`n, %outPath%

        MsgBox, , Generation Completed, Generation Completed

        GuiControl, ,Fields, |
        GuiControl, ,FilePath
        GuiControl, ,OutputPath
        GuiControl, ,Key

        return
    }

GuiClose:
GuiEscape:
ExitApp
