@echo off
echo Building Web Browser Engineering ePub...

REM Set up paths
set PANDOC_PATH=C:\Users\zerxx\AppData\Local\Pandoc\pandoc.exe
set PYTHON_PATH=C:\Python310\python.exe

REM Check if pandoc exists
if not exist "%PANDOC_PATH%" (
    echo Error: Pandoc not found at %PANDOC_PATH%
    exit /b 1
)

REM Check if python exists
if not exist "%PYTHON_PATH%" (
    echo Error: Python not found at %PYTHON_PATH%
    exit /b 1
)

REM Check if cover image exists
if not exist "cover.jpg" (
    echo Warning: Cover image cover.jpg not found - ePub will be built without cover
    echo Please save the cover image as cover.jpg in the root directory
)

REM Create temporary python3 symlink for compatibility
echo Creating python3 alias...
copy "%PYTHON_PATH%" python3.exe > nul

REM Run pandoc with all the bells and whistles
echo Running pandoc...
"%PANDOC_PATH%" ^
  --number-sections ^
  --standalone ^
  --from markdown ^
  --to epub ^
  --metadata-file=config.json ^
  --lua-filter=infra/filter.lua ^
  --highlight-style=infra/wbecode.theme ^
  --css=www/book-epub.css ^
  --epub-cover-image=cover.jpg ^
  --toc ^
  --metadata=mode:epub ^
  --metadata=title:"Web Browser Engineering" ^
  --metadata=author:"Pavel Panchekha and Chris Harrelson" ^
  book/preface.md book/about.md book/intro.md book/history.md ^
  book/http.md book/graphics.md book/text.md book/html.md ^
  book/layout.md book/styles.md book/chrome.md book/forms.md ^
  book/scripts.md book/security.md book/visual-effects.md ^
  book/scheduling.md book/animations.md book/accessibility.md ^
  book/embeds.md book/invalidation.md book/skipped.md ^
  book/change.md book/glossary.md book/bibliography.md ^
  book/classes.md book/porting.md ^
  -o book.epub

REM Clean up
echo Cleaning up...
if exist python3.exe del python3.exe

if %ERRORLEVEL% EQU 0 (
    echo Success! ePub created as book.epub
    dir book.epub
) else (
    echo Failed with error code %ERRORLEVEL%
) 