# Variables
IOS_PROJECT_PATH=BookApp/BookApp.xcodeproj
IOS_SCHEME=BookApp
IOS_DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro"
SERVER_PATH=BookServer
SERVER_PID_FILE=.server_pid

.PHONY: project test server server-test up clean kill-server start-server

# Kill server if running
kill-server:
	@echo "Killing server if running..."
	@if [ -f $(SERVER_PID_FILE) ]; then \
		kill -9 $$(cat $(SERVER_PID_FILE)) && rm $(SERVER_PID_FILE); \
	else \
		echo "No server running."; \
	fi

# Start the server and save the PID
start-server:
	@echo "Starting Swift server..."
	@cd $(SERVER_PATH) && swift run & echo $$! > ../$(SERVER_PID_FILE)
	@echo "Waiting for server to be ready..."
	@sleep 3

# Run the app on the simulator
project:
	@$(MAKE) kill-server
	@$(MAKE) start-server
	@echo "Building and launching iOS app..."
	@xcodebuild -project $(IOS_PROJECT_PATH) -scheme $(IOS_SCHEME) -destination $(IOS_DESTINATION) build
	@xcrun simctl bootstatus booted -b
	@xcrun simctl install booted $(shell xcodebuild -project $(IOS_PROJECT_PATH) -scheme $(IOS_SCHEME) -destination $(IOS_DESTINATION) -showBuildSettings | grep -m1 BUILD_DIR | awk '{print $$3}')/Debug-iphonesimulator/$(IOS_SCHEME).app
	@xcrun simctl launch booted com.erikerice.BookApp
	@echo "App launched. Backend is still running."

# Execute app tests
test:
	@$(MAKE) kill-server
	@$(MAKE) start-server
	@echo "Running iOS tests..."
	@xcodebuild -project $(IOS_PROJECT_PATH) -scheme $(IOS_SCHEME) -destination $(IOS_DESTINATION) test
	@echo "Tests finished. Backend is still running."

# Execute server manually
server:
	cd $(SERVER_PATH) && swift build && swift run

# Execute server tests
server-test:
	cd $(SERVER_PATH) && swift test

# Clean builds
clean:
	cd $(SERVER_PATH) && swift package clean
	rm -rf $(shell xcodebuild -project $(IOS_PROJECT_PATH) -scheme $(IOS_SCHEME) -showBuildSettings | grep -m1 BUILD_DIR | awk '{print $$3}')

