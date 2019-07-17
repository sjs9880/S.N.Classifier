:: (C) 2019. _SN_(sjs9880) all rights reserved.
:: 제작 _SN_ [ http://sjs9880.blog.me/221325814817 ] 2019.07.15 배포
:: 본 스크립트는 파일 이동, 삭제, 생성 에 관한 명령어가 포함되어있으며 사용 중 파일 손상이나 유실의 위험이 있습니다.

@ECHO OFF
TITLE S.N.Classifier v5.1 :: 파일 분류 스크립트
PUSHD "%~dp0"

:Loop
SET /A error=0
ECHO 파일을 확인하는중...
IF EXIST Setting.ini (
	ECHO Setting.ini ... OK
) ELSE (
	SET /A error=1
	ECHO Setting.ini ... NO
	ECHO Setting.ini 를 생성합니다.
	ECHO input=input	원본 파일 경로>Setting.ini
	ECHO output=output	파일 이동 경로>>Setting.ini
	ECHO DeleteDays=0	원본 파일 경로의 생성된지 n 일 된 파일 삭제, 0 : 삭제 안함>>Setting.ini
	ECHO LoopTime=0	0 : 작업 후 정지, 1~30 : n 초 대기 후 종료, 31 ~ : n 초 후 재실행>>Setting.ini
)
IF EXIST list.txt (
	ECHO list.txt ... OK
) ELSE (
	SET /A error=1
	ECHO list.txt ... NO
	ECHO list.txt 를 생성합니다.
	ECHO /[파일 이름에 포함된 단어]/[이동 경로에 생성할 폴더 이름]/[확장자] 파일 이름을 제외한 나머지 생략 가능>list.txt
)
IF %error%==1 (
	ECHO Setting.ini 또는 list.txt 파일을 확인할 수 없어 생성되었습니다.
	PAUSE
)

ECHO.
ECHO 설정을 불러오는중...
FOR /F "tokens=1,2 delims==	" %%a IN (Setting.ini) DO (
	IF %%a==input SET input=%%b
	IF %%a==output SET output=%%b
	IF %%a==DeleteDays SET /a DeleteDays=%%b
	IF %%a==LoopTime SET /a LoopTime=%%b
)
ECHO 확인 완료.

ECHO.
ECHO 디렉터리를 살펴보는 중...
IF EXIST "%input%\" (
	ECHO 원본 파일 경로가 존재합니다.
	ECHO [ %input% ]
) ELSE (
	ECHO 원본 파일 경로가 없습니다. 설정된 경로의 디렉터리를 생성합니다.
	ECHO [ %input% ]
	MD %input%
)
IF EXIST "%output%\" (
	ECHO 파일 이동 경로가 존재합니다.
	ECHO [ %output% ]
) ELSE (
	ECHO 파일 이동 경로가 없습니다. 설정된 경로의 디렉터리를 생성합니다.
	ECHO [ %output% ]
	MD %output%
)

ECHO.
ECHO ─────────────────────────────────────── [ 파일 분류 시작 ]─────────────────────────────────────────────
SET /a "countA=0"
SET /a "countB=0"
FOR /F "tokens=1-3 delims=/" %%c in (list.txt) do (
	SET /a "countA+=1" 
	IF "%%e"=="" (
		IF EXIST "%input%\*%%c*.*" (
			MD "%output%\%%d"
			MOVE "%input%\*%%c*.*" "%output%\%%d"
			SET /a "countB+=1" 
		)
	) ELSE (
		IF EXIST "%input%\*%%c*.%%e" (
			MD "%output%\%%d"
			MOVE "%input%\*%%c*.%%e" "%output%\%%d"
			SET /a "countB+=1" 
		)
	)
)
ECHO ─────────────────────────────────────── [ 파일 분류 종료 ]─────────────────────────────────────────────
ECHO 			%countA% 항목 중 %countB% 개의 파일 분류가 완료되었습니다.

ECHO.
IF %DeleteDays%==0 (
	ECHO 원본 경로의 오래된 파일을 삭제하지 않도록 설정되어 있습니다.
) ELSE (
	ECHO 원본 경로에서 %DeleteDays%일 이 지난 파일을 삭제 중입니다. 잠시만 기다려주세요.
	FORFILES /P "%input%" /D -%DeleteDays% /C "cmd /c DEL @file"
	ECHO 파일 삭제가 완료되었습니다.
)

ECHO.
SET /A min=%LoopTime%/60
IF %LoopTime%==0 PAUSE
IF %LoopTime% LEQ 30 (
	CHOICE /N /T %LoopTime% /D Y /M " %LoopTime% 초 후 종료됩니다."
	GOTO END
) ELSE (
	CHOICE /N /T %LoopTime% /D Y /M "약 %min% 분( %LoopTime% 초) 후 작업이 재실행 됩니다."
	IF %ERRORLEVEL%==1 GOTO Loop
)

:END
POPD