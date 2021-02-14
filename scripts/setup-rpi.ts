import InputLoop from "https://deno.land/x/input@2.0.2/index.ts";

const genWPASupplicant = (ssid: string, pass: string) => `country=AR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="${ssid}"
  scan_ssid=1
  psk="${pass}"
  key_mgmt=WPA-PSK
}`;

const input = new InputLoop();
const wifiSSID = await input.question("WiFi SSID: ", false);
const wifiPass = await input.question("WiFi Password: ", false);

await Deno.create("ssh");
await Deno.writeTextFile(
  "wpa_supplicant.conf",
  genWPASupplicant(wifiSSID, wifiPass)
);
