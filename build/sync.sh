#!/bin/bash

: "${HOST1:?Missing HOST1}"
: "${USER1:?Missing USER1}"
: "${PASSWORD1:?Missing PASSWORD1}"
: "${HOST2:?Missing HOST2}"
: "${USER2:?Missing USER2}"
: "${PASSWORD2:?Missing PASSWORD2}"

echo "--------------------------------------------------"
echo "Starte imapsync im Intervall von $SYNC_INTERVAL Sekunden..."
echo "Quelle:      $USER1@$HOST1"
echo "Ziel:        $USER2@$HOST2"
echo "Parameter:   $EXTRA_PARAMS"
echo "--------------------------------------------------"

read -r -a EXTRA_ARR <<< "$EXTRA_PARAMS"

while true; do
  echo "[$(date)] Starte Synchronisierung: $USER1@$HOST1 → $USER2@$HOST2"
  imapsync \
    --host1 "$HOST1" --user1 "$USER1" --password1 "$PASSWORD1" \
    --host2 "$HOST2" --user2 "$USER2" --password2 "$PASSWORD2" \
    "${EXTRA_ARR[@]}"
  echo "[$(date)] Synchronisierung abgeschlossen."
  sleep "$SYNC_INTERVAL"
done