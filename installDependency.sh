CHROME_VERSION="81.0.4044.138-1"
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -f install && apt-get -y install wget gnupg2 apt-utils --no-install-recommends
wget --quiet -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
    && apt-get install -y /tmp/chrome.deb --no-install-recommends --allow-downgrades fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
    && rm /tmp/chrome.deb
