#!/opt/pyff/bin/python

import logging
import logging.config
import os
import random
import sys
import time
import yaml

from signal import SIGHUP


def setup_logging():
    with open("gunicorn_sighup_logger.yaml", "rt") as f:
        try:
            config = yaml.safe_load(f.read())
            logging.config.dictConfig(config)
        except Exception as e:
            print(e)
            print("Error in logging configuration. Using default config")
            logging.basicConfig()

def get_gunicorn_pid():
    pid_file = os.environ.get("GUNICORN_PID_FILE", "/tmp/gunicorn.pid")

    while True:
        try:
            with open(pid_file, "rt") as f:
                gunicorn_pid = int(f.read())
            return gunicorn_pid
        except FileNotFoundError:
            logging.info("PID file {} not found".format(pid_file))
            logging.debug("Sleeing for 5 seconds...")
            time.sleep(5)
            logging.debug("Awake!")
        except Exception as e:
            logging.error("Could not determine gunicorn PID: {}".format(e))
            raise


def main():
    setup_logging()

    gunicorn_pid = get_gunicorn_pid()

    logging.info("Using gunicorn PID {}".format(gunicorn_pid))

    sleep_time = int(os.environ.get("GUNICORN_SIGHUP_SLEEP_TIME_SECONDS",
                                    "3600"))
    jitter = random.randint(1, 300)

    while True:
        logging.debug("Going to sleep for {} seconds...".format(
                      sleep_time + jitter))
        time.sleep(sleep_time + jitter)
        logging.debug("Awake!")

        logging.debug("Sending SIGHUP to PID {}...".format(gunicorn_pid))
        os.kill(gunicorn_pid, SIGHUP)
        logging.info("Sent SIGHUP to PID {}".format(gunicorn_pid))


if __name__ == "__main__":
    ret = main()
    sys.exit(ret)
