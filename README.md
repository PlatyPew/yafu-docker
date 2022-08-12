# Docker image for yafu for Arch Linux

```sh
# How to build the image
docker build -t platypew/yafu-docker:latest .
# Alternatively, you can pull from docker hub
docker pull platypew/yafu-docker:latest
```

You can remove the file and extract it from the docker image

```sh
docker create --name yafu platypew/yafu-docker:latest foo
docker cp yafu:/yafu.tgz .
```

You can install it into your Arch system by doing 

```sh
sudo pacman -S --noconfirm gmp gmp-ecm && \
    sudo tar -xzf yafu.tgz -C /
```
