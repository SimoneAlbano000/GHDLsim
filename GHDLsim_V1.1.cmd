:: Written by Simone Albano
:: MSYS2 installation needed!

@echo off
setlocal enabledelayedexpansion

:: Check for MSYS2 installation
if not exist "C:\msys64\msys2_shell.cmd" (
    echo "No MSYS2 installation found ..."
    exit
) else (
    goto GHDL
)

:GHDL
:: Check for GHDL and gtkwave installation
if not exist "C:\msys64\mingw64\bin\ghdl.exe" (
    goto INSTALL
) else (
    goto RUN
)

:INSTALL
:: Setting PATH
set PATH=%PATH%;C:\msys64\mingw64\bin
call C:\msys64\msys2_shell.cmd -c "yes | pacman -Syu && yes | pacman -S mingw64/mingw-w64-x86_64-ghdl-llvm mingw64/mingw-w64-x86_64-gtkwave"
:: Need to wait for process to finish
pause

:RUN
:: Ask for testbench entity name
set /p testbenchName="Enter the name of the VHDL testbench top-level entity, that should also match it's file name (default = testbench) ... "
if "%testbenchName%" == "" (
    set testbenchName=testbench
)

:: Ask for simulation time
set /p simTime="Enter the simulation time in ns ... "

:: Create a work directory
echo "Removing previous working directory and all it's files ..."
if exist %~dp0\work (rd /s /q %~dp0\work)
echo "Creating working directory ..."
mkdir %~dp0\work

:: Set work library, work directory and ieee standard library
:: Compile all the vhdl source code
FOR %%I in (%~dp0\*.vhd) DO (
    ghdl -a --ieee=standard -fsynopsys --warn-parenthesis --warn-others  --work=work --workdir=%~dp0\work -P%~dp0\ %%I
)
:: Search files in subfolders
FOR /D %%D IN (%~dp0\*) DO (
    FOR %%I in (%%D\*.vhd) DO (
        ghdl -a --ieee=standard -fsynopsys --warn-parenthesis --warn-others  --work=work --workdir=%~dp0\work -P%%D\ %%I
    )
)

cd %~dp0\work\
:: Link the project (testbench is the entity name of the testbench vhdl file)
ghdl -e --work=work --workdir=%~dp0\work -P%~dp0\ --ieee=standard -fsynopsys %testbenchName%
:: Run the compiled vhdl code and save the waveforms
ghdl -r %testbenchName% --stop-time=%simTime%ns --disp-time --assert-level=warning --wave=waveforms.ghw --ieee-asserts=enable
:: Launch gtkwave to view the wave dump
gtkwave waveforms.ghw
goto END

:ERROR
echo "Compile error... "

:END
endlocal
