import logging
import logging.handlers
import time

class LoggerSetup():
    def __init__(self):
        self.logger = logging.getLogger('')
        self.setup_logger()
    
    def setup_logger(self):
        LOG_FORMAT = '{ "time": "%(asctime)s", "name": "%(name)s", "level": "%(levelname)s", "message": "%(message)s"}'

        logging.basicConfig(level=logging.INFO)

        formatter = logging.Formatter(LOG_FORMAT)

        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)

        log_file = 'log/app.log'

        file = logging.handlers.TimedRotatingFileHandler(log_file, when='midnight', backupCount=5)
        file.setFormatter(formatter)

        self.logger.addHandler(console_handler)
        self.logger.addHandler(file)