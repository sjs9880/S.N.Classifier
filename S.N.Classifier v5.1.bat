:: (C) 2019. _SN_(sjs9880) all rights reserved.
:: ���� _SN_ [ http://sjs9880.blog.me/221325814817 ] 2019.07.15 ����
:: �� ��ũ��Ʈ�� ���� �̵�, ����, ���� �� ���� ��ɾ ���ԵǾ������� ��� �� ���� �ջ��̳� ������ ������ �ֽ��ϴ�.

@ECHO OFF
TITLE S.N.Classifier v5.1 :: ���� �з� ��ũ��Ʈ
PUSHD "%~dp0"

:Loop
SET /A error=0
ECHO ������ Ȯ���ϴ���...
IF EXIST Setting.ini (
	ECHO Setting.ini ... OK
) ELSE (
	SET /A error=1
	ECHO Setting.ini ... NO
	ECHO Setting.ini �� �����մϴ�.
	ECHO input=input	���� ���� ���>Setting.ini
	ECHO output=output	���� �̵� ���>>Setting.ini
	ECHO DeleteDays=0	���� ���� ����� �������� n �� �� ���� ����, 0 : ���� ����>>Setting.ini
	ECHO LoopTime=0	0 : �۾� �� ����, 1~30 : n �� ��� �� ����, 31 ~ : n �� �� �����>>Setting.ini
)
IF EXIST list.txt (
	ECHO list.txt ... OK
) ELSE (
	SET /A error=1
	ECHO list.txt ... NO
	ECHO list.txt �� �����մϴ�.
	ECHO /[���� �̸��� ���Ե� �ܾ�]/[�̵� ��ο� ������ ���� �̸�]/[Ȯ����] ���� �̸��� ������ ������ ���� ����>list.txt
)
IF %error%==1 (
	ECHO Setting.ini �Ǵ� list.txt ������ Ȯ���� �� ���� �����Ǿ����ϴ�.
	PAUSE
)

ECHO.
ECHO ������ �ҷ�������...
FOR /F "tokens=1,2 delims==	" %%a IN (Setting.ini) DO (
	IF %%a==input SET input=%%b
	IF %%a==output SET output=%%b
	IF %%a==DeleteDays SET /a DeleteDays=%%b
	IF %%a==LoopTime SET /a LoopTime=%%b
)
ECHO Ȯ�� �Ϸ�.

ECHO.
ECHO ���͸��� ���캸�� ��...
IF EXIST "%input%\" (
	ECHO ���� ���� ��ΰ� �����մϴ�.
	ECHO [ %input% ]
) ELSE (
	ECHO ���� ���� ��ΰ� �����ϴ�. ������ ����� ���͸��� �����մϴ�.
	ECHO [ %input% ]
	MD %input%
)
IF EXIST "%output%\" (
	ECHO ���� �̵� ��ΰ� �����մϴ�.
	ECHO [ %output% ]
) ELSE (
	ECHO ���� �̵� ��ΰ� �����ϴ�. ������ ����� ���͸��� �����մϴ�.
	ECHO [ %output% ]
	MD %output%
)

ECHO.
ECHO ������������������������������������������������������������������������������ [ ���� �з� ���� ]������������������������������������������������������������������������������������������
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
ECHO ������������������������������������������������������������������������������ [ ���� �з� ���� ]������������������������������������������������������������������������������������������
ECHO 			%countA% �׸� �� %countB% ���� ���� �з��� �Ϸ�Ǿ����ϴ�.

ECHO.
IF %DeleteDays%==0 (
	ECHO ���� ����� ������ ������ �������� �ʵ��� �����Ǿ� �ֽ��ϴ�.
) ELSE (
	ECHO ���� ��ο��� %DeleteDays%�� �� ���� ������ ���� ���Դϴ�. ��ø� ��ٷ��ּ���.
	FORFILES /P "%input%" /D -%DeleteDays% /C "cmd /c DEL @file"
	ECHO ���� ������ �Ϸ�Ǿ����ϴ�.
)

ECHO.
SET /A min=%LoopTime%/60
IF %LoopTime%==0 PAUSE
IF %LoopTime% LEQ 30 (
	CHOICE /N /T %LoopTime% /D Y /M " %LoopTime% �� �� ����˴ϴ�."
	GOTO END
) ELSE (
	CHOICE /N /T %LoopTime% /D Y /M "�� %min% ��( %LoopTime% ��) �� �۾��� ����� �˴ϴ�."
	IF %ERRORLEVEL%==1 GOTO Loop
)

:END
POPD