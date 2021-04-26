#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ChartGenerator-Server/ChartGenerator-Server.csproj", "ChartGenerator-Server/"]
RUN dotnet restore "ChartGenerator-Server/ChartGenerator-Server.csproj"
COPY . .
WORKDIR "/src/ChartGenerator-Server"
RUN dotnet build "ChartGenerator-Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ChartGenerator-Server.csproj" -c Release -o /app/publish -p:PublishSingleFile=false --self-contained false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

#####################
#PUPPETEER RECIPE
#####################
# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.

ARG CHROME_VERSION="81.0.4044.138-1"
RUN apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
    && apt-get install -y /tmp/chrome.deb --no-install-recommends --allow-downgrades fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
    && rm /tmp/chrome.deb
    # && apt-get update \

# Add user, so we don't need --no-sandbox.
# same layer as npm install to keep re-chowned files from using up several hundred MBs more space    
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser
#####################
#END PUPPETEER RECIPE
#####################

WORKDIR /home/pptruser

ENV PUPPETEER_EXECUTABLE_PATH "/usr/bin/google-chrome"
COPY --from=publish /app/publish .
# ENTRYPOINT ["./ChartGenerator-Server"]
ENV ASPNETCORE_URLS=http://+:80 
ENTRYPOINT ["dotnet", "ChartGenerator-Server.dll"]
