function Get-LanzouDirectLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $false)]
        [string]$Password = ""
    )

    $ApiUrl = "https://lanzou.yuyuqaq.cn/api/parse"
    $body = @{ url = $Url; pwd = $Password } | ConvertTo-Json

    $headers = @{
        "Content-Type"  = "application/json"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        "Origin"        = "https://lanzou.yuyuqaq.cn"
        "Referer"       = "https://lanzou.yuyuqaq.cn/"
    }

    try {
        $response = Invoke-WebRequest -Uri $ApiUrl -Method Post -Body $body `
            -Headers $headers -UseBasicParsing
        $result = $response.Content | ConvertFrom-Json

        if ($result.code -ne 0) {
            throw "解析失败: $($result.msg)"
        }
        return $result.data.downUrl
    }
    catch {
        throw "请求或解析出错: $_"
    }
}

echo "Program Started!"
$link = Get-LanzouDirectLink -Url "https://bwe.lanzoum.com/i7G7O3xf5fhe" -Password 0000
echo "Got IDM Link!"
echo "Downloading IDM... Total Size: 8MB"
Invoke-WebRequest -Uri $link -OutFile ".\IDM.exe"
.\IDM.exe -o".\" -y

$link1 = Get-LanzouDirectLink -Url "https://bwe.lanzouc.com/i7CD34bq0lkd" -Password 0000
$link2 = Get-LanzouDirectLink -Url "https://bwe.lanzouc.com/ipDWd4bq0muj" -Password 0000
echo $link1
echo $link2

while(-not (Test-Path -Path .\IDM\IDMan.exe -PathType Leaf)){
    Start-Sleep -Milliseconds 500
}
echo "IDM Downloaded!"
Start-Sleep -Milliseconds 1500

echo ""
echo "Now Download Part1"
.\IDM\IDMan.exe /d $link1 /p $PWD.Path /f "MC1.21.11-NormalTiny-v2-P1.exe" /n 
echo "Task Created!"

while(-not (Test-Path -Path ".\MC1.21.11-NormalTiny-v2-P1.exe" -PathType Leaf)){
    Start-Sleep -Milliseconds 1000
}
echo "Download Part1 Successed!"
Start-Sleep -Milliseconds 500
.\MC1.21.11-NormalTiny-v2-P1.exe -o".\" -y

echo ""
echo "Now Download Part2"
.\IDM\IDMan.exe /d $link2 /p $PWD.Path /f "MC1.21.11-NormalTiny-v2-P2.exe" /n 
echo "Task Created!"

while(-not (Test-Path -Path ".\MC1.21.11-NormalTiny-v2-P2.exe" -PathType Leaf)){
    Start-Sleep -Milliseconds 1000
}
echo "Download Part2 Successed!"
Start-Sleep -Milliseconds 500
.\MC1.21.11-NormalTiny-v2-P2.exe -o".\" -y

while(-not (Test-Path -Path ".\hmcl-dev-3.5.8.248.exe" -PathType Leaf)){
    Start-Sleep -Milliseconds 500
}
while(-not (Test-Path -Path ".\.minecraft\launcher_profiles.json" -PathType Leaf)){
    Start-Sleep -Milliseconds 500
}
Start-Sleep -Milliseconds 1000
echo "Unziped!"
start "hmcl-dev-3.5.8.248.exe"
echo "Launched HMCL!"

echo "Finish!"
pause
