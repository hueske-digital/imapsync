#!/usr/bin/env bash
set -uo pipefail

: "${HOST1:?Missing HOST1}"
: "${USER1:?Missing USER1}"
: "${PASSWORD1:?Missing PASSWORD1}"
: "${HOST2:?Missing HOST2}"
: "${USER2:?Missing USER2}"
: "${PASSWORD2:?Missing PASSWORD2}"
: "${HEALTHCHECK_URL:?Missing HEALTHCHECK_URL}"
: "${SYNC_INTERVAL:?Missing SYNC_INTERVAL}"

START_URL="${HEALTHCHECK_URL}/start"
SUCCESS_URL="${HEALTHCHECK_URL}"
FAIL_URL="${HEALTHCHECK_URL}/fail"

echo "--------------------------------------------------"
echo "Starte imapsync im Intervall von $SYNC_INTERVAL Sekunden..."
echo "Quelle:      $USER1@$HOST1"
echo "Ziel:        $USER2@$HOST2"
echo "Parameter:   ${EXTRA_PARAMS:-<none>}"
echo "Healthcheck: $HEALTHCHECK_URL"
echo "--------------------------------------------------"

while true; do
  TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$TIMESTAMP] Pinge Start → $START_URL"
  curl -fsS "$START_URL" || echo "[$TIMESTAMP] WARN: /start Ping fehlgeschlagen"

  echo "[$TIMESTAMP] Starte Synchronisierung: $USER1@$HOST1 → $USER2@$HOST2"
  imapsync \
    --host1 "$HOST1" --user1 "$USER1" --password1 "$PASSWORD1" \
    --host2 "$HOST2" --user2 "$USER2" --password2 "$PASSWORD2" \
    $EXTRA_PARAMS
  EXIT_CODE=$?

  TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
  if [ $EXIT_CODE -eq 0 ]; then
    echo "[$TIMESTAMP] Synchronisierung erfolgreich abgeschlossen."
    echo "[$TIMESTAMP] Pinge Success → $SUCCESS_URL"
    curl -fsS "$SUCCESS_URL" || echo "[$TIMESTAMP] WARN: Success-Ping fehlgeschlagen"
  else
    echo "[$TIMESTAMP] FEHLER: Synchronisierung mit Exit-Code $EXIT_CODE abgebrochen!"
    echo "[$TIMESTAMP] Pinge Fail → $FAIL_URL"
    curl -fsS "$FAIL_URL" || echo "[$TIMESTAMP] WARN: Fail-Ping fehlgeschlagen"
  fi

  echo "[$TIMESTAMP] Warte $SYNC_INTERVAL Sekunden bis zum nächsten Lauf."
  sleep "$SYNC_INTERVAL"
done