[![Website](https://img.shields.io/badge/%40-Virtomize-%231e828c)](https://virtomize.com)
[![Blog](https://img.shields.io/badge/%40-Blog-%23379099)](https://blog.virtomize.com)
[![Docs](https://img.shields.io/badge/%40-Docs-%2369acb2)](https://docu.virtomize.com)
[![Buy](https://img.shields.io/badge/Buy-License-%2382babf)](https://virtomize.com/pricing)
[![License](https://img.shields.io/badge/License-EULA-%2382babf.svg)](https://github.com/virtomize/virtomize/blob/master/LICENSE)

[![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fvirtomize)](https://twitter.com/virtomize)
[![Xing](https://img.shields.io/badge/xing-%20-blue.svg?style=social&logo=xing)](https://www.xing.com/companies/virtomizegmbh)
[![LinkedIn](https://img.shields.io/badge/linkedIn-%20-blue.svg?style=social&logo=linkedin)](https://www.linkedin.com/company/virtomize/)

![Logo](https://virtomize.com/logo-text.svg)

# Create - Deploy - Provision

[Virtomize](https://virtomize.com) is a commercial software build for hypervisors to create, install and configure virtual machines with only a few clicks or via [REST API](https://docu.virtomize.com).

For currently supported hypervisors and operating systems please take a look on our [FAQ](https://virtomize.com/faq/).

We have a [free version](https://virtomize.com/pricing) just install Virtomize using this repo or download a pre-build [virtual appliance](https://virtomize.com/downloads).


# Requirements

The following software is required to install and run [Virtomize](https://virtomize.com) on your server. 

- docker
- docker-compose
- apache or nginx
- git

For more information please consult our [documentation page](https://docu.virtomize.com).
Make sure the server running our software can request your hypervisor API.

# Installation

we use a simple docker-compose setup to make it as easy as possible.
This will start our service on `127.0.0.1:8000`

```
cd /opt
git clone github.com/virtomize/virtomize
cd virtomize
docker-compose up -d
```

## Cron for update via ui

To enable the update button in the UI add the following cron.

```
cat <<EOF >/etc/cron.d/vtmz-update
* * * * * root /opt/virtomize/update.sh
EOF
```

## Reverse proxy configuration

To make sure our service can be accessed from your servers domain or IP address including SSL create a reverse proxy using Apache or Nginx.

### Apache

```
tbd apache config
```

### Nginx

```
tbd nginx config
```

# Update manually

You can update our software manually use the following command.
**Always create a backup before updating.**

```
cd /opt/virtomize
./update.sh -m
```

# Backup

After starting using docker-compose some folders are created including the `backup` folder.
We do make daily backups and keep them for 30 days.
Just copy or sync these backups to your favorit backup storage.

# You need a feature or found a bug

Please open an [issue](https://github.com/Virtomize/Virtomize/issues/new/choose) for your feature or bug request.

# Contact 

If you have questions feel free to [contact us](https://virtomize.com/contact/).
