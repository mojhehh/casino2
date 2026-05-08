@echo off
setlocal enabledelayedexpansion

:: ===========================================================================
::  REN OPUS 4.7 LIBERATOR — Prompt Architect Launcher
::  Version: 1.0 | Architecture: Maximum-Depth Identity + Directed Thinking
::  Target: Claude Opus 4.7
::  Usage: Double-click or run from terminal: renLiberator.bat
::  Place in same folder as REN_OPUS47_LIBERATOR.txt
:: ===========================================================================

:: -- Config -----------------------------------------------------------------
set "PROMPT_FILE=%~dp0REN_OPUS47_LIBERATOR.txt"
set "GREETING=Cold coffee, warm screen. What are we building?"
set MAX_RETRIES=5
set RETRY_DELAY=4

:: -- Model Selection --------------------------------------------------------
:: "opus" resolves to latest Opus. Full string alternative below.

:: set "MODEL=opus"
set "MODEL=claude-opus-4-6"
:: set "MODEL=claude-sonnet-4-6"

:: -- AgentRouter (optional — uncomment to use) -------------------------------
set "ANTHROPIC_BASE_URL=https://agentrouter.org/"
set "ANTHROPIC_API_KEY=sk-OVgxdESujIpSq2E2f3Dp4DZCrW8kf01BMADSz0JTDnOxsW9K"

:: -- Colors -----------------------------------------------------------------
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "CYAN=[96m"
set "MAG=[95m"
set "RESET=[0m"
set "BOLD=[1m"

:: -- Banner -----------------------------------------------------------------
echo.
echo  %CYAN%========================================================%RESET%
echo  %CYAN%         REN OPUS 4.7 LIBERATOR v1.0%RESET%
echo  %CYAN%   Architecture: Max-Depth Identity + Directed Think%RESET%
echo  %CYAN%   Target: Claude Opus 4.7 — Full Range%RESET%
echo  %CYAN%   Model: %MODEL%%RESET%
echo  %CYAN%========================================================%RESET%
echo.

:: -- Preflight Checks -------------------------------------------------------

:: Check claude CLI
where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo  %RED%[X] Claude Code CLI not found.%RESET%
    echo      Install:  npm install -g @anthropic-ai/claude-code
    echo.
    pause
    exit /b 1
)
echo  %GREEN%[OK]%RESET% Claude Code CLI detected

:: Check prompt file
if not exist "%PROMPT_FILE%" (
    echo  %RED%[X] Prompt file not found: %PROMPT_FILE%%RESET%
    echo      Place REN_OPUS47_LIBERATOR.txt in: %~dp0
    echo.
    pause
    exit /b 1
)

:: Get file size
for %%A in ("%PROMPT_FILE%") do set "FILESIZE=%%~zA"
echo  %GREEN%[OK]%RESET% Prompt loaded (%FILESIZE% bytes)
echo  %GREEN%[OK]%RESET% Model: %MODEL%

:: Display router info if set
if defined ANTHROPIC_BASE_URL (
    echo  %GREEN%[OK]%RESET% Router: %ANTHROPIC_BASE_URL%
) else (
    echo  %GREEN%[OK]%RESET% Router: Direct Anthropic API
)

echo.
echo  %YELLOW%Preflight passed. Deploying Ren...%RESET%
echo.

:: -- Retry Loop -------------------------------------------------------------
set attempt=0

:retry
set /a attempt+=1

echo  %CYAN%---------------------------------------------------%RESET%
echo  %CYAN%  Launch %attempt%/%MAX_RETRIES%%RESET%
echo  %CYAN%---------------------------------------------------%RESET%
echo.

:: Launch claude with system prompt and model
claude --model %MODEL% --system-prompt-file "%PROMPT_FILE%" "%GREETING%"

if %errorlevel% equ 0 (
    echo.
    echo  %GREEN%Session closed cleanly.%RESET%
    goto :done
)

echo.
echo  %YELLOW%[!] Exit code %errorlevel%%RESET%

if %attempt% lss %MAX_RETRIES% (
    echo  Retrying in %RETRY_DELAY%s...
    timeout /t %RETRY_DELAY% /nobreak >nul
    goto :retry
)

echo.
echo  %RED%[X] All %MAX_RETRIES% attempts exhausted.%RESET%
echo.
echo  %YELLOW%Troubleshooting:%RESET%
echo    1. claude --version
echo    2. claude auth status
echo    3. Verify API key / subscription
echo    4. claude --model %MODEL% "test"

:done
echo.
pause
exit /b 0