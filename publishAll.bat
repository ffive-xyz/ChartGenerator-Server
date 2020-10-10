projectPath="./ChartGenerator-Server/ChartGenerator-Server.csproj"
publishPrefix="./ChartGenerator-Server/Properties/PublishProfiles/"
publishSuffix=".pubxml"
publishProfiles=(linux-arm linux-x64 osx-x64 win-arm win-x64 win-x86)

for i in "${publishProfiles[@]}"
do
    dotnet publish "$projectPath" "/p:PublishProfile=${publishPrefix}${i}${publishSuffix}"
done