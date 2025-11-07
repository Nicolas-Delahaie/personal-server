#!/usr/bin/env python3
"""
Ce script se connecte au bus système D-Bus, trouve le premier modem via
ModemManager et expose les interfaces en MQTT
"""
import asyncio
import logging
from pathlib import Path
from dbus_next.aio import MessageBus
from dbus_next.constants import BusType

LOG_FILE = Path(__file__).resolve().parent / "sms.log"
MM_BUS = "org.freedesktop.ModemManager1"

def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
        handlers=[
            logging.FileHandler(LOG_FILE, encoding="utf-8"),
            logging.StreamHandler(),
        ],
    )


async def fetch_and_log_sms():
    bus = await MessageBus(bus_type=BusType.SYSTEM).connect()

    manager_introspection = await bus.introspect(MM_BUS, "/org/freedesktop/ModemManager1")
    manager_proxy = bus.get_proxy_object(MM_BUS, "/org/freedesktop/ModemManager1", manager_introspection)
    object_manager = manager_proxy.get_interface("org.freedesktop.DBus.ObjectManager")
    managed_objects = await object_manager.call_get_managed_objects()

    modem_path = None
    for path, interfaces in managed_objects.items():
        if "org.freedesktop.ModemManager1.Modem" in interfaces:
            modem_path = path
            break

    if not modem_path:
        logging.error("Aucun modem trouvé")
        return

    logging.info(f"Modem trouvé : {modem_path}")

    modem_introspection = await bus.introspect(MM_BUS, modem_path)
    modem_proxy = bus.get_proxy_object(MM_BUS, modem_path, modem_introspection)
    messaging = modem_proxy.get_interface("org.freedesktop.ModemManager1.Modem.Messaging")

    sms_paths = await messaging.call_list()
    if not sms_paths:
        logging.info("Aucun SMS trouvé.")
        return

    logging.info(f"{len(sms_paths)} SMS trouvé(s). Enregistrement dans {LOG_FILE}")
    for sms_path in sms_paths:
        try:
            sms_introspection = await bus.introspect(MM_BUS, sms_path)
            sms_proxy = bus.get_proxy_object(MM_BUS, sms_path, sms_introspection)
            # Properties (use the standard Properties interface)
            props_iface = sms_proxy.get_interface("org.freedesktop.DBus.Properties")
            props = await props_iface.call_get_all("org.freedesktop.ModemManager1.Sms")

            number = props.get("Number").value if "Number" in props else "(inconnu)"
            text = props.get("Text").value if "Text" in props else ""
            timestamp = props.get("Timestamp").value if "Timestamp" in props else "(?)"

            logging.info("--- SMS reçu ---")
            logging.info(f"De: {number}")
            logging.info(f"Date: {timestamp}")
            logging.info(f"Texte: {text}")
        except Exception as e:
            logging.exception(f"Erreur lors de la lecture du SMS {sms_path}: {e}")

    # After processing all SMS, disconnect the bus so asyncio can finish cleanly
    await bus.wait_for_disconnect()


async def main():
    setup_logging()
    logging.info("Démarrage (dbus-next)")
    await fetch_and_log_sms()
    logging.info("Terminé. Fermeture.")


if __name__ == "__main__":
    asyncio.run(main())