import {
  Input,
  Secret,
} from "https://deno.land/x/cliffy@v0.17.2/prompt/mod.ts";

const genWPASupplicant = (ssid: string, pass: string) => `country=AR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="${ssid}"
  scan_ssid=1
  psk="${pass}"
  key_mgmt=WPA-PSK
}`;

const wifiSSID = await Input.prompt("WiFi SSID");
const wifiPass = await Secret.prompt("WiFi Password");

await Deno.create("ssh");
await Deno.writeTextFile(
  "wpa_supplicant.conf",
  genWPASupplicant(wifiSSID, wifiPass)
);
