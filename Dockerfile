FROM alpine:3.11

# For access via VNC
EXPOSE map[5900/tcp:{}]

# For access via WIREGUARD
EXPOSE 51820

# Expose Ports of RouterOS
EXPOSE map[1194/tcp:{1194} 1701/tcp:{1701} 1723/tcp:{1723} 1812/udp:{1812} 1813/udp:{1813} 2021/tcp:{2021} 2022/tcp:{2022} 2023/tcp:{2023} 2027/tcp:{2027} 21/tcp:{2121} 22/tcp:{22222} 23/tcp:{2323} 443/tcp:{7443} 4500/udp:{4500} 50/tcp:{50} 500/udp:{500} 51/tcp:{51} 5900/tcp:{5900} 80/tcp:{80} 8080/tcp:{8080} 8291/tcp:{8291} 8728/tcp:{8728} 8729/tcp:{8729} 8900/tcp:{8900}]

# Change work dir (it will also create this folder if is not exist)
WORKDIR /routeros

# Install dependencies
#RUN /bin/sh -c set -xe \
# && apk add --no-cache --update \
#    netcat-openbsd qemu-x86_64 qemu-system-x86_64 \
#    busybox-extras iproute2 iputils \
#    bridge-utils iptables jq bash python3

# Install dependencies    
RUN /bin/sh -c set -xe \
 && apk add --no-cache --update \
    netcat-openbsd qemu-x86_64 qemu-system-x86_64 \
    busybox-extras iproute2 iputils \
    bridge-utils iptables jq bash python3 \
    unzip # buildkit

# Environments which may be change
ENV ROUTEROS_VERSON="7.6"
ENV ROUTEROS_IMAGE="chr-$ROUTEROS_VERSON.vdi"
ENV ROUTEROS_PATH="https://download.mikrotik.com/routeros/$ROUTEROS_VERSON/$ROUTEROS_IMAGE.zip"

# Download VDI image from remote site
RUN /bin/sh -c wget "$ROUTEROS_PATH"

# Copy script to routeros folder
ADD ["./scripts", "/routeros"] # buildkit

ENTRYPOINT ["/routeros/entrypoint.sh"]
