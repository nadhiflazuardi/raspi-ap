#!/bin/bash

# === Configuration ===
PKG_NAME="raspi-ap-setup"
VERSION="1.0.0"
MAINTAINER="Your Name <you@example.com>"
DESCRIPTION="Raspberry Pi Access Point setup utility"
DEPENDENCIES="hostapd, dnsmasq, iptables, iptables-persistent, netfilter-persistent"

# === Directory Setup ===
BASE_DIR="$(pwd)/${PKG_NAME}"
BIN_DIR="${BASE_DIR}/usr/local/bin"
DEBIAN_DIR="${BASE_DIR}/DEBIAN"
EXTRA_DEB_DIR="${BASE_DIR}/opt/extra-debs"

echo "📦 Creating Debian package project: $PKG_NAME"

# Create folder structure
mkdir -p "$BIN_DIR" "$DEBIAN_DIR" "$EXTRA_DEB_DIR"

# === Create control file ===
cat > "${DEBIAN_DIR}/control" <<EOF
Package: $PKG_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Maintainer: $MAINTAINER
Depends: $DEPENDENCIES
Description: $DESCRIPTION
EOF

echo "✅ Created control file"

# === Create postinst script (optional) ===
cat > "${DEBIAN_DIR}/postinst" <<'EOF'
#!/bin/bash

echo "[INFO] Installing any bundled .deb files..."

if [ -d /opt/extra-debs ]; then
  for pkg in /opt/extra-debs/*.deb; do
    echo "Installing $pkg"
    dpkg -i "$pkg"
  done
fi

echo "[INFO] Done. You can now run: sudo setup-ap.sh"
EOF

chmod +x "${DEBIAN_DIR}/postinst"
echo "✅ Created postinst script"

# === Add placeholder main script ===
cat > "${BIN_DIR}/setup-ap.sh" <<'EOF'
#!/bin/bash
echo "This is a placeholder for your actual access point setup script."
EOF

chmod +x "${BIN_DIR}/setup-ap.sh"
echo "✅ Created placeholder script at /usr/local/bin/setup-ap.sh"

echo "🎉 Done! Your package source is ready at: $BASE_DIR"
echo "💡 To build the .deb, run:"
echo "   dpkg-deb --build $PKG_NAME"
