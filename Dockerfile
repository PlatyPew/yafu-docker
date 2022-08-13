FROM lopsided/archlinux:devel as build

RUN sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 8/g' /etc/pacman.conf && \
    pacman -Sy --noconfirm && \
    sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers && \
    curl -fsSL https://blackarch.org/strap.sh | sh && \
    pacman -S yay subversion --noconfirm && \
    groupadd users && groupadd wheel && \
    useradd -m -g users -G wheel -s /bin/bash builder

USER builder
WORKDIR /home/builder

RUN MAKEFLAGS="-j$(nproc)" yay -S --noconfirm yafu-git && \
    tar -czvf yafu.tgz /etc/yafu /usr/bin/yafu \
        /lib64/libecm.so* /lib64/libgmp.so* /lib64/libgomp.so*  /lib64/libgcc_s.so*

USER root
RUN sed -i 's/ecm_path=\.\.\\gmp-ecm\\bin\\x64\\Release\\ecm.exe/ecm_path=\/usr\/sbin\/ecm/g' /etc/yafu/yafu.ini

FROM scratch
COPY --from=build /home/builder/yafu.tgz .
