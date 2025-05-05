FROM cirrusci/flutter:latest

# Download and install Flutter 3.29.0
RUN curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz \
    && tar xf flutter_linux_3.29.0-stable.tar.xz \
    && rm -rf /usr/local/flutter \
    && mv flutter /usr/local/flutter \
    && export PATH="/usr/local/flutter/bin:$PATH" \
    && flutter --version