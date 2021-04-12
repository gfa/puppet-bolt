#! /usr/bin/env python3
"""TL;DR chronic + flock + monitoring."""

# Implemented:
# - chronic
# - flock -E 0 -xn
# exit 666 (not really, just 154) when the command failed more than X times (3 by default)

import logging
import logging.config
import os
import hashlib

import subprocess  # nosec
import sys
from argparse import ArgumentParser

logger = logging.getLogger()


def configure_logging(*kwargs):
    """Configure logging."""
    message_format = "%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(message)s"
    date_format = "%Y-%m-%d %H:%M:%S"
    formatter = logging.Formatter(message_format, date_format)
    root_logger = logging.getLogger()
    args = kwargs[0]

    if args["console"]:
        # output to console
        stdout_handler = logging.StreamHandler(sys.stdout)
        stdout_handler.setFormatter(formatter)
        root_logger.addHandler(stdout_handler)

    syslog_handler = logging.handlers.SysLogHandler(address="/dev/log", facility="cron")
    syslog_handler.setFormatter(formatter)
    syslog_handler.ident = "cronrunner "

    root_logger.addHandler(syslog_handler)
    root_logger.setLevel(args["loglevel"])


def parse_arguments():
    """Parse CLI arguments."""
    parser = ArgumentParser(allow_abbrev=False)
    parser.add_argument(
        "--loglevel",
        default="ERROR",
        help="loglevel at which run cronrunner, default 'ERROR'",
        choices=["ERROR", "INFO", "DEBUG"],
    )
    parser.add_argument(
        "--lock-file",
        help="path to create a lock file, if the lock \
        exist the program won't run",
    )
    parser.add_argument(
        "--lock-fatal",
        default=False,
        action="store_true",
        help="if the existence of the lock should \
                terminate the program with an error",
    )
    parser.add_argument(
        "--console",
        default=False,
        action="store_true",
        help="output program's output to console",
    )
    parser.add_argument(
        "--max-fails",
        default=3,
        type=int,
        help="how many times can the program exit != 0 or not run becase the lockfile exists",
    )

    logger.debug("parse_arguments return: %s", parser.parse_known_args())
    return parser.parse_known_args()


def run_process(**kargs):
    """Run arbitrary processes using the subprocess module."""
    logger.info("running %s", kargs["command"])

    try:
        proc = subprocess.Popen(  # nosec
            kargs["command"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        logger.error("command not found: %s", kargs["command"])
        # sys.exit(127)
        return 127

    stdout, stderr = proc.communicate()
    logger.debug("process finished")

    logger.debug("stdout: %s", stdout)
    logger.debug("stderr: %s", stderr)
    logger.debug("return: %s", proc.returncode)
    logger.debug("PID: %s", proc.pid)

    if proc.returncode != 0:
        logger.error("command failed: %s", kargs["command"])
        logger.error("stdout: %s", stdout.rstrip())
        logger.error("stderr: %s", stderr.rstrip())
        logger.error("return: %s", proc.returncode)

    logger.info("done running %s", kargs["command"])
    return proc.returncode


def create_lockfile(child_arguments):
    """Create a lock file.

    returns True if everything went well
    false otherwise

    I cant use hash() because https://stackoverflow.com/a/27522708
    """
    arguments = " ".join(child_arguments)
    filename = "/tmp/" + hashlib.sha224(arguments.encode("utf-8")).hexdigest()
    logger.debug("generated filename: %s", filename)

    if not os.path.exists(filename):
        with open(filename, "w") as file:
            file.write((str(os.getpid())) + "\n")
            file.write(arguments + "\n")
            return True
    else:
        logger.warning("'%s' already running, lockfile: %s", arguments, filename)
        return False


def remove_lockfile(child_arguments):
    """Remove the lockfile."""
    arguments = " ".join(child_arguments)
    filename = "/tmp/" + hashlib.sha224(arguments.encode("utf-8")).hexdigest()

    logger.debug("removing : %s", filename)

    os.remove(filename)


def increment_fail_counter(child_arguments):
    """Increase the failed counter."""
    arguments = " ".join(child_arguments)
    filename = (
        "/tmp/" + hashlib.sha224(arguments.encode("utf-8")).hexdigest() + "-counter"
    )

    logger.debug("increase failed counter in: %s", filename)

    with open(filename, "a") as file:
        file.write(".")


def remove_fail_counter(child_arguments):
    """Remove the failed counter."""
    arguments = " ".join(child_arguments)
    filename = (
        "/tmp/" + hashlib.sha224(arguments.encode("utf-8")).hexdigest() + "-counter"
    )

    logger.debug("removing failed counter: %s", filename)

    try:
        os.remove(filename)
    except FileNotFoundError:
        pass


def check_fail_counter(child_arguments, max_fails):
    """Check if the fail counter went above the limit."""
    arguments = " ".join(child_arguments)
    filename = (
        "/tmp/" + hashlib.sha224(arguments.encode("utf-8")).hexdigest() + "-counter"
    )

    if os.path.exists(filename):
        failures = os.stat(filename).st_size

        if failures > max_fails:
            logger.error(
                "'%s' has failed more than %s times", child_arguments, max_fails
            )
            return 666


def main():
    """CLI entry point."""
    program_arguments, child_arguments = parse_arguments()
    program_arguments = vars(program_arguments)
    configure_logging(program_arguments)
    if not child_arguments:
        logging.error("I need something to run")
        sys.exit(0)

    runnable = create_lockfile(child_arguments)

    if runnable:
        proc_exit = run_process(command=child_arguments)
        remove_lockfile(child_arguments)
        if proc_exit > 0:
            increment_fail_counter(child_arguments)
        else:
            remove_fail_counter(child_arguments)
    else:
        increment_fail_counter(child_arguments)

    return check_fail_counter(child_arguments, program_arguments["max_fails"])


if __name__ == "__main__":
    sys.exit(main())
