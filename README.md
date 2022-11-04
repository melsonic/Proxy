# Proxy

## For linux:
#### Configure using GUI

Open the network settings and set the your system wide network proxy.
Network -> Network proxy -> Configure -> Apply system wide.
Keep the Socks Host Blank if you want to acess web.whatsapp.com.

SERVER: 172.16.2.11
PORT: 3128

#### Add the following lines to _~/.bashrc_

```
export http_proxy=http://172.16.2.11:3128/ 
export https_proxy=http://172.16.2.11:3128/
```

#### Add the following lines to _/etc/apt/apt.conf_

```
Acquire::http::Proxy "http://172.16.2.11:3128/"; 
Acquire::https::Proxy "http://172.16.2.11:3128/"; 
```

#### Add the following lines to _/etc/bash.bashrc_

```
export http_proxy=http://172.16.2.11:3128/
export https_proxy=http://172.16.2.11:3128/
```

#### Add the following lines to _/etc/environment_

```
export http_proxy="http://172.16.2.11:3128/"
export https_proxy="http://172.16.2.11:3128/"
```

### For yarn
```
yarn config set proxy http://172.16.2.11:3128/
yarn config set https-proxy http://172.16.2.11:3128/
```

### delete yarn proxy
```
yarn config delete proxy
yarn config delete https-proxy
```

### configure the proxy settings for snap
```
sudo snap set system proxy.http="http://172.16.2.11:3128/"
sudo snap set system proxy.https="http://172.16.2.11:3128/"
```

### configurations for docker
```
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://192.16.2.11:3128",
     "httpsProxy": "http://192.16.2.11:3128",
     "noProxy": "*.test.example.com,.example2.com,127.0.0.0/8"
   }
 }
}

```

```
[Service]
Environment="HTTP_PROXY=http://172.16.2.11:3128"
Environment="HTTPS_PROXY=http://10.0.1.60:3128"
Environment="NO_PROXY=localhost,127.0.0.1"
```


<br><br>
## For Windows:
#### Configure using GUI
Open the network settings and set the proxy and port
Proxy: 172.16.199.41
Port: 8080

#### For conda
To change environment variables on Windows:
1. In the Start menu, search for “env”.
2. Select “Edit Environment Variables for your account”
3. Select “Environment Variables…”
4. Press “New…”
5. Add two variables http_proxy and https_proxy both with the same value: http://172.16.199.41:8080

#### For git
```
git config --global --unset http.proxy
git config --global http.proxy http://172.16.199.41:8080
git config --global --get http.proxy
```

#### For npm
```
npm config set http-proxy http://172.16.199.41:8080
npm config set https-proxy http://172.16.199.41:8080
```
