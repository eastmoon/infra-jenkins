@rem
@rem Copyright 2020 the original author jacky.eastmoon
@rem All commad module need 3 method :
@rem [command]        : Command script
@rem [command]-args   : Command script options setting function
@rem [command]-help   : Command description
@rem Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
@rem But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
@rem NOTE, batch call [command]-args it could call correct one or call [command] and "-args" is parameter.
@rem

:: ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

:: ------------------- declare CLI file variable -------------------
@rem retrieve project name
@rem Ref : https://www.robvanderwoude.com/ntfor.php
@rem Directory = %~dp0
@rem Object Name With Quotations=%0
@rem Object Name Without Quotes=%~0
@rem Bat File Drive = %~d0
@rem Full File Name = %~n0%~x0
@rem File Name Without Extension = %~n0
@rem File Extension = %~x0

set CLI_DIRECTORY=%~dp0
set CLI_FILE=%~n0%~x0
set CLI_FILENAME=%~n0
set CLI_FILEEXTENSION=%~x0

:: ------------------- declare CLI variable -------------------

set BREADCRUMB=cli
set COMMAND=
set COMMAND_BC_AGRS=
set COMMAND_AC_AGRS=

:: ------------------- declare variable -------------------

for %%a in ("%cd%") do (
    set PROJECT_NAME=%%~na
)
set PROJECT_ENV=dev

:: ------------------- execute script -------------------

call :main %*
goto end

:: ------------------- declare function -------------------

:main (
    call :argv-parser %*
    call :%BREADCRUMB%-args %COMMAND_BC_AGRS%
    call :main-args %COMMAND_BC_AGRS%
    IF defined COMMAND (
        set BREADCRUMB=%BREADCRUMB%-%COMMAND%
        call :main %COMMAND_AC_AGRS%
    ) else (
        call :%BREADCRUMB%
    )
    goto end
)
:main-args (
    for %%p in (%*) do (
        if "%%p"=="-h" ( set BREADCRUMB=%BREADCRUMB%-help )
        if "%%p"=="--help" ( set BREADCRUMB=%BREADCRUMB%-help )
    )
    goto end
)
:argv-parser (
    set COMMAND=
    set COMMAND_BC_AGRS=
    set COMMAND_AC_AGRS=
    set is_find_cmd=
    for %%p in (%*) do (
        IF NOT defined is_find_cmd (
            echo %%p | findstr /r "\-" >nul 2>&1
            if errorlevel 1 (
                set COMMAND=%%p
                set is_find_cmd=TRUE
            ) else (
                set COMMAND_BC_AGRS=!COMMAND_BC_AGRS! %%p
            )
        ) else (
            set COMMAND_AC_AGRS=!COMMAND_AC_AGRS! %%p
        )
    )
    goto end
)

:: ------------------- Main mathod -------------------

:cli (
    goto cli-help
)

:cli-args (
    for %%p in (%*) do (
        if "%%p"=="--prod" ( set PROJECT_ENV=prod )
    )
    goto end
)

:cli-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo If not input any command, at default will show HELP
    echo.
    echo Options:
    echo      --help, -h        Show more information with CLI.
    echo      --pord            Setting project environment with "prod", default is "dev"
    echo.
    echo Command:
    echo      up                Startup Server.
    echo      down              Close down Server.
    echo      dev               Startup DEV Server.
    echo.
    echo Run 'cli [COMMAND] --help' for more information on a command.
    goto end
)

:: ------------------- Command "up" mathod -------------------

:cli-up-docker-prepare (
    @rem Create .env for compose
    echo Current Environment %PROJECT_ENV%
    echo TAG=%PROJECT_NAME% > ./docker/.env
    echo JENKINS_DATA=%cd%\cache\jenkins-data >> ./docker/.env
    echo JENKINS_DOCKER_CERTS=%cd%\cache\jenkins-docker-certs >> ./docker/.env

    echo ^> Build ebook Docker images
    docker build --rm ^
        -t docker-jenkins:%PROJECT_NAME% ^
        ./docker/jenkins

    docker build --rm ^
        -t docker-jenkins-dev:%PROJECT_NAME% ^
        ./docker/jenkins-dev

    IF NOT EXIST %cd%\cache (
        mkdir %cd%\cache
    )
    goto end
)

:cli-up (
    echo ^> Server UP with %PROJECT_ENV% environment
    call :cli-up-docker-prepare
    echo ^> Initial cache from source
    docker run -ti --rm ^
      	-v %cd%\cache\jenkins-data:/cache ^
      	-v %cd%\src:/source ^
      	docker-jenkins-dev:%PROJECT_NAME% sh init.sh
    echo ^> Startup Jenkins service
    docker-compose -f ./docker/docker-compose.yml up -d
    goto end
)

:cli-up-args (
    goto end
)

:cli-up-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end
)

:: ------------------- Command "down" mathod -------------------

:cli-down (
    echo ^> Server DOWN
    docker rm -f docker-jenkins-dev_%PROJECT_NAME%
    docker-compose -f ./docker/docker-compose.yml down
    goto end
)

:cli-down-args (
    goto end
)

:cli-down-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Close down Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end
)

:: ------------------- Command "dev" mathod -------------------

:cli-dev (
    call :cli-up
    echo ^> Start dev service
    docker rm -f docker-jenkins-dev_%PROJECT_NAME%
    docker run -ti --rm --detach^
    	-v %cd%\cache\jenkins-data:/cache ^
    	-v %cd%\src:/source ^
      --name docker-jenkins-dev_%PROJECT_NAME% ^
      docker-jenkins-dev:%PROJECT_NAME% sh sync.sh
    goto end
)

:cli-dev-args (
    goto end
)

:cli-dev-help (
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup DEV Server
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end
)

:: ------------------- End method-------------------

:end (
    endlocal
)
