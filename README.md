# IMAPSync Docker-Setup

Dieses Repository enthält ein Docker-Setup für die Synchronisation von IMAP-Postfächern mit `imapsync`. Die Synchronisation erfolgt in regelmäßigen Intervallen und unterstützt Multi-Architekturen (amd64, arm64).

## Inhaltsverzeichnis

- [Überblick](#überblick)
- [Voraussetzungen](#voraussetzungen)
- [Installation](#installation)
- [Konfiguration](#konfiguration)
- [Docker-Workflows](#docker-workflows)
- [Healthchecks](#healthchecks)
- [Lizenz](#lizenz)

## Überblick

Das Setup verwendet:
- **Docker**: Für die Bereitstellung der `imapsync`-Anwendung.
- **GitHub Actions**: Für den automatisierten Build und Push des Docker-Images.
- **Healthchecks**: Zur Überwachung der Synchronisationsläufe.

## Voraussetzungen

- Docker und Docker Compose müssen installiert sein.
- Ein GitHub-Account mit Zugriff auf das Container-Registry `ghcr.io`.

## Installation

1. Klone dieses Repository:
   ```bash
   git clone https://github.com/hueske-digital/imapsync-docker.git
   cd imapsync-docker
   ```

2. Kopiere die Beispieldatei `.env.example` und passe sie an:
   ```bash
   cp .env.example .env
   ```

3. Starte den Docker-Container:
   ```bash
   docker-compose up -d
   ```

## Konfiguration

Die Konfiguration erfolgt über die `.env`-Datei. Hier ein Beispiel:

```dotenv
HOST1=mail.mailserver.com
USER1=user1@example.com
PASSWORD1=1234
HOST2=mail.mailserver.com
USER2=user2@example.com
PASSWORD2=123445
EXTRA_PARAMS="--maxage 30 --nofoldersizes --nofoldersizesatend --automap"
SYNC_INTERVAL=3600
HEALTHCHECK_URL=https://healthcheck.io/asdf
```

### Wichtige Parameter

- **HOST1, USER1, PASSWORD1**: Zugangsdaten für das Quell-Postfach.
- **HOST2, USER2, PASSWORD2**: Zugangsdaten für das Ziel-Postfach.
- **EXTRA_PARAMS**: Zusätzliche Parameter für `imapsync`.
- **SYNC_INTERVAL**: Intervall in Sekunden zwischen den Synchronisationsläufen.
- **HEALTHCHECK_URL**: URL für Healthchecks.

## Docker-Workflows

### Build und Push des Docker-Images

Das Docker-Image wird automatisch durch den Workflow `docker-build-push.yml` gebaut und in die GitHub Container Registry gepusht.

### Repository-Aktivität

Der Workflow `github-keep-active.yml` sorgt dafür, dass das Repository aktiv bleibt.

## Healthchecks

Das Skript `sync.sh` sendet Healthcheck-Pings an die konfigurierten URLs:
- **Start-Ping**: Wird vor Beginn der Synchronisation gesendet.
- **Success-Ping**: Wird nach erfolgreicher Synchronisation gesendet.
- **Fail-Ping**: Wird bei einem Fehler gesendet.