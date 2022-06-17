logging = dofile("lib/logging.lua")

logger           = logging.Logger.new(shell.getRunningProgram())
logger.file      = "main.log"
logger.websocket = http.websocket("ws://127.0.0.1:8080")

print("Logger Name:", logger.name)
logger:debug("Tets: debug")
logger:info("Tets: info")
logger:warn("Tets: warn")
logger:error("Tets: error")
logger:critical("Tets: critical")

logger.websocket.close()
