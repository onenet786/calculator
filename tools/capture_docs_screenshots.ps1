$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root 'docs\screenshots'
$chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
$port = 9223
$url = 'http://127.0.0.1:7357'
$profile = Join-Path $root '.tmp-chrome-docs'

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $profile | Out-Null

$chromeProcess = Start-Process -FilePath $chrome -ArgumentList @(
  '--headless=new',
  '--disable-gpu',
  '--no-first-run',
  "--remote-debugging-port=$port",
  "--user-data-dir=$profile",
  '--window-size=430,844',
  'about:blank'
) -WindowStyle Hidden -PassThru

function Send-CdpCommand {
  param(
    [System.Net.WebSockets.ClientWebSocket]$Socket,
    [int]$Id,
    [string]$Method,
    [object]$Params = @{}
  )

  $payload = [Text.Encoding]::UTF8.GetBytes((@{
        id = $Id
        method = $Method
        params = $Params
      } | ConvertTo-Json -Depth 8 -Compress))
  $segment = [ArraySegment[byte]]::new($payload)
  $Socket.SendAsync($segment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null

  $buffer = [byte[]]::new(65536)
  while ($true) {
    $builder = [Text.StringBuilder]::new()
    do {
      $received = $Socket.ReceiveAsync([ArraySegment[byte]]::new($buffer), [Threading.CancellationToken]::None).GetAwaiter().GetResult()
      [void]$builder.Append([Text.Encoding]::UTF8.GetString($buffer, 0, $received.Count))
    } while (-not $received.EndOfMessage)

    $message = $builder.ToString() | ConvertFrom-Json
    if ($message.id -eq $Id) {
      return $message
    }
  }
}

function Click-Point {
  param(
    [System.Net.WebSockets.ClientWebSocket]$Socket,
    [ref]$Id,
    [int]$X,
    [int]$Y
  )

  Send-CdpCommand $Socket (++$Id.Value) 'Input.dispatchMouseEvent' @{
    type = 'mousePressed'
    x = $X
    y = $Y
    button = 'left'
    clickCount = 1
  } | Out-Null
  Send-CdpCommand $Socket (++$Id.Value) 'Input.dispatchMouseEvent' @{
    type = 'mouseReleased'
    x = $X
    y = $Y
    button = 'left'
    clickCount = 1
  } | Out-Null
}

function Capture-Page {
  param(
    [System.Net.WebSockets.ClientWebSocket]$Socket,
    [ref]$Id,
    [string]$FileName
  )

  $result = Send-CdpCommand $Socket (++$Id.Value) 'Page.captureScreenshot' @{
    format = 'png'
    captureBeyondViewport = $false
  }
  [IO.File]::WriteAllBytes((Join-Path $outDir $FileName), [Convert]::FromBase64String($result.result.data))
}

try {
  Start-Sleep -Seconds 2
  $target = (Invoke-RestMethod -Method Put "http://127.0.0.1:$port/json/new?$url")
  $socket = [System.Net.WebSockets.ClientWebSocket]::new()
  $socket.ConnectAsync([Uri]$target.webSocketDebuggerUrl, [Threading.CancellationToken]::None).GetAwaiter().GetResult()
  $id = 0

  Send-CdpCommand $socket (++$id) 'Page.enable' | Out-Null
  Send-CdpCommand $socket (++$id) 'Emulation.setDeviceMetricsOverride' @{
    width = 430
    height = 844
    deviceScaleFactor = 1
    mobile = $true
  } | Out-Null
  Send-CdpCommand $socket (++$id) 'Page.navigate' @{ url = $url } | Out-Null
  Start-Sleep -Seconds 8
  Capture-Page $socket ([ref]$id) 'home.png'

  Click-Point $socket ([ref]$id) 44 40
  Start-Sleep -Seconds 2
  Capture-Page $socket ([ref]$id) 'learning-menu.png'

  Send-CdpCommand $socket (++$id) 'Page.navigate' @{ url = $url } | Out-Null
  Start-Sleep -Seconds 8
  Click-Point $socket ([ref]$id) 165 525
  Start-Sleep -Milliseconds 350
  Click-Point $socket ([ref]$id) 367 704
  Start-Sleep -Milliseconds 350
  Click-Point $socket ([ref]$id) 267 525
  Start-Sleep -Milliseconds 350
  Click-Point $socket ([ref]$id) 367 790
  Start-Sleep -Seconds 1
  Capture-Page $socket ([ref]$id) 'calculation-history.png'

  $socket.Dispose()
}
finally {
  if ($chromeProcess -and -not $chromeProcess.HasExited) {
    Stop-Process -Id $chromeProcess.Id -Force
  }
}
