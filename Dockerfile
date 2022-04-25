# escape=`
FROM microsoft/dotnet-framework:4.7.2-runtime

LABEL doc-win="https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017"
LABEL doc-py="https://github.com/docker-library/python/blob/38dcdb4320c8668416205e044ee50489c059da18/3.7/windows/windowsservercore-1709/Dockerfile"

# Install build tools
# Restore the default Windows shell for correct batch processing below.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --all `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Install Python
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV PYTHON_VERSION 3.6.6
ENV PYTHON_RELEASE 3.6.6

RUN $url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); `
	Write-Host ('Downloading {0} ...' -f $url); `
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
	Invoke-WebRequest -Uri $url -OutFile 'python.exe'; `
	`
	Write-Host 'Installing ...'; `
# https://docs.python.org/3.5/using/windows.html#installing-without-ui
	Start-Process python.exe -Wait `
		-ArgumentList @( `
			'/quiet', `
			'InstallAllUsers=1', `
			'TargetDir=C:`Python', `
			'PrependPath=1', `
			'Shortcuts=0', `
			'Include_doc=0', `
			'Include_pip=0', `
			'Include_test=0' `
		); `
	`
# the installer updated PATH, so we should refresh our local value
	$env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); `
	`
	Write-Host 'Verifying install ...'; `
	Write-Host '  python --version'; python --version; `
	`
	Write-Host 'Removing ...'; `
	Remove-Item python.exe -Force; `
	`
	Write-Host 'Complete.';

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 18.1

RUN Write-Host ('Installing pip=={0} ...' -f $env:PYTHON_PIP_VERSION); `
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
	Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'; `
	python get-pip.py `
		--disable-pip-version-check `
		--no-cache-dir `
		('pip=={0}' -f $env:PYTHON_PIP_VERSION) `
	; `
	Remove-Item get-pip.py -Force; `
	`
	Write-Host 'Verifying pip install ...'; `
	pip --version; `
	`
	Write-Host 'Complete.';

CMD ["python"]
