# adbqr

Scan a QR code to pair your laptop with an Android phone for wireless debugging.
You don't need Android Studio, and you don't have to squint at the phone and type
`adb pair 10.0.0.5:37755 314159` by hand.

```
adbqr
```

Run it, then on the phone go to Developer options, Wireless debugging, "Pair
device with QR code", and scan. adbqr spots the phone over mDNS and does the
pairing for you.

## Install

```sh
brew install kristjan/tap/adbqr
```

Not a Homebrew person? `./install.sh` copies the script onto your PATH. It's a
plain bash script and runs on macOS and Linux alike.

You also need `adb` and `qrencode`, which aren't bundled:

```sh
# macOS
brew install --cask android-platform-tools
brew install qrencode

# Debian / Ubuntu
sudo apt install adb qrencode

# Fedora
sudo dnf install android-tools qrencode

# Arch
sudo pacman -S android-tools qrencode
```

If either is missing, adbqr tells you the right command for your system.

## Usage

```
adbqr                 # show the QR, pair when the phone appears
adbqr --timeout 120   # wait longer for the phone
adbqr --help
```

## How the QR renders

adbqr asks the terminal what it can handle and shows the best QR it'll display:

- Terminals with the Kitty graphics protocol (Ghostty, kitty, WezTerm, Konsole)
  get a real image.
- iTerm2 and WezTerm get one via the iTerm2 image protocol.
- Anything else, including macOS Terminal, VSCode, and piped output, gets a
  block-character QR from qrencode that scans fine.

It works this out at runtime by querying the terminal, so there's no list of
terminal names to keep current.

## The public Wi-Fi problem

Pairing depends on mDNS to locate the phone. The QR carries the pairing code but
not the phone's address, and that address shows up over mDNS. Lots of public and
guest networks run client isolation, which blocks mDNS between devices, so the
phone spins forever and nothing pairs.

You can't fix that from the laptop. Use a phone hotspot instead, or go over USB
with `adb tcpip`. adbqr warns you when the network looks like one of these, and
again if it's been waiting too long.

## What the QR actually contains

Android's pairing format:

```
WIFI:T:ADB;S:<service-name>;P:<pairing-code>;;
```

The `WIFI:` prefix is a red herring. There's no Wi-Fi network involved: `S` is an
mDNS service name rather than an SSID, and `P` is the pairing code rather than a
password. It never reads your SSID and never asks for Location permission.

## Hacking on it

```sh
make test
```

The tests want `bats` and `zbarimg`:

```sh
brew install bats-core zbar          # macOS
sudo apt install bats zbar-tools     # Debian / Ubuntu
sudo dnf install bats zbar           # Fedora
sudo pacman -S bats zbar             # Arch
```

They build
a QR, decode it again with `zbarimg`, and confirm the pairing string makes it
through, including the Kitty and iTerm2 image renderers.

## License

MIT
