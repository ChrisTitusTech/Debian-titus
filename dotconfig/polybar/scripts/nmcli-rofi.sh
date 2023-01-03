#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# default config
FIELDS=SSID,SECURITY,BARS
POSITION=0; XOFF=0; YOFF=0
MAGIC=-4
FONT="DejaVu Sans Mono Bold 14"

# supported locales (en, ru, de, fr, hi, ja)
declare -A LOC_ENABLE=(["en"]="enabled" ["ru"]="включен" ["de"]="aktiviert" ["fr"]="activé" ["hi"]="सक्षम" ["ja"]="有効")

# get current locale
CURRLOCALE=$(locale | grep 'LANG=[a-z]*' -o | sed 's/^LANG=//g')
# 'enabled' in currnet locale
ENABLED="${LOC_ENABLE["$CURRLOCALE"]}"

# get current uuid
CURRUUID=$(nmcli -f UUID,TYPE con show --active | grep wifi | awk '{print $1}')

# get wifi state
function wifistate () {
  echo "$(nmcli -fields WIFI g | sed -n 2p)"
}

# get active wifi connections
function wifiactive () {
  echo "$(nmcli con show --active | grep wifi)"
}

function if_wifistate () {
  # return a expression based on wifi state
  [[ "$(wifistate)" =~ $ENABLED ]] && rt=$1 || rt=$2
  echo $rt
}

function toggle_wifi () {
  toggle=$(if_wifistate "Disable Network" "Enable Network")
  echo $toggle
}

function current_connection () {
  currssid=$(iwgetid -r)
  [[ "$currssid" != '' ]] && currcon="Disconnect from $currssid" || currcon=""
  echo $currcon
}

function nmcli_list () {
  # get list of available connections without the active connection (if it's connected)
  echo "$(nmcli --fields IN-USE,"$FIELDS" device wifi list | sed "s/^IN-USE\s//g" | sed '/*/d' | sed 's/^ *//')"
}

function count_lines () {
  echo "$1" | wc -l
}

function linenum () {
  wa=$(wifiactive)
  list_lines_num=$(count_lines "$1")
  [[ "$wa" != '' ]] && ops=4 || ops=3

  lines=$(if_wifistate "$(($list_lines_num+$ops))" 1)
  echo $lines
}

function rwidth () {
    rwidth=$(echo "$1" | head -n 1 | awk '{print length($0); }')
    [[ $rwidth -lt ${#2} ]] && rwidth=${#2}
    [[ $rwidth -lt ${#3} ]] && rwidth=${#3}
    let rwidth=$rwidth+$MAGIC
    echo $rwidth
}

function menu () {
  wa=$(wifiactive); ws=$(wifistate);
  if [[ $ws =~ $ENABLED ]]; then
    if [[ "$wa" != '' ]]; then
        echo "$1\n\n$2\n$3\nManual Connection"
    else
        echo "$1\n\n$3\nManual Connection"
    fi
  else
    echo "$3"
  fi
}

function rofi_cmd () {
  # don't repeat lines with uniq -u
  echo -e "$1" | uniq -u | rofi -dmenu -p "Wi-Fi SSID" -lines "$LINENUM" \
    -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width "$RWIDTH"
}

function rofi_menu () {
    TOGGLE=$(toggle_wifi)
    CURRCONNECT=$(current_connection)
    [[ "$TOGGLE" =~ 'Enable' ]] && LIST="" || LIST=$(nmcli_list)

    MENU=$(menu "$LIST" "$CURRCONNECT" "$TOGGLE")

    LINENUM=$(linenum "$LIST")
    RWIDTH=$(rwidth "$LIST" "$TOGGLE" "$CURRCONNECT")

    rofi_cmd "$MENU"
}

function get_ssid () {
    # get fields in order
    eval FIELDSARR=( $(cat $NMCLI_ROFI_SOURCE | awk 'BEGIN { FS=","; OFS="\n" } /^FIELDS/ \
      { $1 = substr($1, 8); print $0; }') )

    # get position of SSID field
    for i in "${!FIELDSARR[@]}"; do
      if [[ "${FIELDSARR[$i]}" = "SSID" ]]; then
          SSID_POS="${i}";
      fi
    done

    # let for arithmetical vars
    let AWKSSIDPOS=$SSID_POS+1

    # get SSID from AWKSSIDPOS
    CHSSID=$(echo "$1" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $'$AWKSSIDPOS'}')
    echo "$CHSSID"
}

function cleanup_networks () {
  nmcli --fields UUID,TIMESTAMP-REAL,DEVICE con show | grep -e '--' |  awk '{print $1}' \
    | while read line; do nmcli con delete uuid $line; done
}

function main () {
    if [ -r "$DIR/nmcli-rofi/config" ]; then
      source "$DIR/config"
    elif [ -r "$HOME/.config/rofi/wifi" ]; then
      source "$HOME/.config/rofi/wifi"
    else
      echo "WARNING: config file not found! Using default values."
    fi

    OPS=$(rofi_menu)
    CHSSID=$(get_ssid "$OPS")

    if [[ "$OPS" =~ 'Disable' ]]; then
      nmcli radio wifi off

    elif [[ "$OPS" =~ 'Enable' ]]; then
      nmcli radio wifi on

    elif [[ "$OPS" =~ 'Disconnect' ]]; then
      nmcli con down uuid $CURRUUID

    elif [[ "$OPS" =~ 'Manual' ]]; then
      # Manual entry of the SSID
      MSSID=$(echo -en "" | rofi -dmenu -p "SSID" -mesg "Enter the SSID of the network" \
        -lines 0 -font "$FONT")

      # manual entry of the PASSWORD
      MPASS=$(echo -en "" | rofi -dmenu -password -p "PASSWORD" -mesg \
        "Enter the PASSWORD of the network" -lines 0 -font "$FONT")

      # If the user entered a manual password, then use the password nmcli command
      if [ "$MPASS" = "" ]; then
        nmcli dev wifi con "$MSSID"
      elif [ "$MSSID" != '' ] && [ "$MPASS" != '' ]; then
        nmcli dev wifi con "$MSSID" password "$MPASS"
      fi

    else
        if [[ "$OPS" =~ "WPA2" ]] || [[ "$OPS" =~ "WEP" ]]; then
          WIFIPASS=$(echo -en "" | rofi -dmenu -password -p "PASSWORD" \
            -mesg "Enter the PASSWORD of the network" -lines 0 -font "$FONT")
        fi

        if [[ "$CHSSID" != '' ]] && [[ "$WIFIPASS" != '' ]]; then
          nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
        fi
    fi
}

# clean up obsoleted connections
# nmcli --fields UUID,TIMESTAMP-REAL,DEVICE con show | grep never |  awk '{print $1}' | while read line; do nmcli con delete uuid $line; done

main
